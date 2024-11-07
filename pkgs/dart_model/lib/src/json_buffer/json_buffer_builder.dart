// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

part 'closed_list.dart';
part 'closed_map.dart';
part 'explanations.dart';
part 'growable_map.dart';
part 'iterables.dart';
part 'type.dart';
part 'typed_map.dart';

class JsonBufferBuilder {
  /// The root map of the buffer.
  ///
  /// It's a "growable map": entries can be added to it.
  late final Map<String, Object?> map;

  Uint8List _buffer;

  /// The next free location to write to in the buffer.
  int _nextFree;

  /// Whether writes are allowed.
  final bool _allowWrites;

  /// [_Pointer]s to [TypedMapSchema]s used by [_TypedMap]s, so that the
  /// same schema is only written once.
  final Map<TypedMapSchema, _Pointer> _pointersBySchema = Map.identity();

  /// [TypedMapSchema] used by [_TypedMap]s by [_Pointer], so that the same
  /// schema is only read once.
  final Map<_Pointer, TypedMapSchema> _schemasByPointer = {};

  /// [_Pointer]s to `String`s, so that the same `String` is only written once.
  final Map<String, _Pointer> _pointersByString = {};

  JsonBufferBuilder.deserialize(this._buffer)
      : _allowWrites = false,
        _nextFree = _buffer.length {
    map = _readGrowableMap<Object?>(0, null);
  }

  JsonBufferBuilder()
      : _allowWrites = true,
        _buffer = Uint8List(_initialBufferSize),
        _nextFree = 0 {
    map = createGrowableMap<Object?>();
  }

  /// Computes the identity hash of the object at [pointer] from its raw bytes.
  ///
  /// Any nested pointers use the hash of the values they point to.
  ///
  /// If [type] is provided, [pointer] should point directly at the object.
  /// Otherwise a [Type] will be read first, followed by the value.
  ///
  /// If [alreadyDereferenced] is `true`, then for types which are pointers,
  /// [pointer] already points at the top of the object, and should not be
  /// followed before reading the object.
  int fingerprint(int pointer, {Type? type, bool alreadyDereferenced = false}) {
    if (type == null) {
      type = _readType(pointer);
      pointer += _typeSize;
    }
    return _fingerprint(pointer, type,
        alreadyDereferenced: alreadyDereferenced);
  }

  /// Computes the identity hash of the object at [pointer] with a known [type]
  /// from its raw bytes.
  ///
  /// If [alreadyDereferenced] is `true`, then for types which are pointers,
  /// [pointer] already points at the top of the object, and should not be
  /// followed before reading the object.
  int _fingerprint(_Pointer pointer, Type type,
      {bool alreadyDereferenced = false}) {
    // Dereference [pointer] if it is a pointer type, and hasn't already been
    // dereferenced.
    if (type.isPointer && !alreadyDereferenced) {
      pointer = _readPointer(pointer);
    }

    switch (type) {
      case Type.nil:
        return null.hashCode;
      case Type.type:
        return _buffer[pointer];
      case Type.pointer:
        return fingerprint(pointer);
      case Type.uint32:
        return _readUint32(pointer);
      case Type.boolean:
        return _buffer[pointer];
      case Type.anyPointer:
        return fingerprint(pointer);
      case Type.stringPointer:
        final length = _readLength(pointer);
        pointer += _lengthSize;
        return Object.hashAll(_buffer.sublist(pointer, pointer + length));
      case Type.closedListPointer:
        return _ClosedList(this, pointer).fingerprint;
      case Type.closedMapPointer:
        return _ClosedMap(this, pointer, null).fingerprint;
      case Type.growableMapPointer:
        return _GrowableMap<Object?>(this, pointer, null).fingerprint;
      case Type.typedMapPointer:
        return _TypedMap(this, pointer, null).fingerprint;
    }
  }

  /// The JSON data.
  ///
  /// The buffer is _not_ copied, unpredictable behavior will result if it is
  /// mutated.
  Uint8List serialize() => Uint8List.sublistView(_buffer, 0, _nextFree);

  /// The number of bytes written.
  int get length => _nextFree;

  /// Reads the value at [_Pointer], which must have been written with
  /// [_writeAny].
  Object? _readAny(_Pointer pointer, {Map<String, Object?>? parent}) {
    final type = _readType(pointer);
    return _read(type, pointer + _typeSize, parent: parent);
  }

  /// Reads the value of type [Type] at [_Pointer].
  Object? _read(Type type, _Pointer pointer, {Map<String, Object?>? parent}) {
    switch (type) {
      case Type.nil:
        return null;
      case Type.type:
        return _readType(pointer);
      case Type.pointer:
        return _readPointer(pointer);
      case Type.uint32:
        return _readUint32(pointer);
      case Type.boolean:
        return _readBoolean(pointer);
      case Type.anyPointer:
        return _read(_readType(pointer), pointer + _typeSize);
      case Type.stringPointer:
        return _readString(_readPointer(pointer));
      case Type.closedListPointer:
        return _readClosedList(_readPointer(pointer));
      case Type.closedMapPointer:
        return _readClosedMap(_readPointer(pointer), parent);
      case Type.growableMapPointer:
        return _readGrowableMap<Object?>(_readPointer(pointer), parent);
      case Type.typedMapPointer:
        return _readTypedMap(_readPointer(pointer), parent);
    }
  }

  /// Writes the type of [value] then writes the value using [_writeAnyOfType].
  void _writeAny(_Pointer pointer, Object? value) {
    _explanations?.push('_writeAny $pointer $value');
    final type = Type._of(value, this);
    _writeType(pointer, type);
    _writeAnyOfType(type, pointer + _typeSize, value);
    _explanations?.pop();
  }

  /// Writes [value] of type [type] to [pointer].
  ///
  /// The type is assumed to be known statically and is not written.
  ///
  /// If [value] fits in four bytes, it is written directly.
  ///
  /// Otherwise, a pointer is written. It might be a pointer to an existing
  /// value if there is one, or a new value may be written as well.
  ///
  /// `Type.anyPointer` is a special case; it uses five bytes. Because
  /// `Type._of` never returns `Type.anyPointer` the caller can always know
  /// ahead of time that `anyPointer` will be needed, and should reserve five
  /// bytes.
  void _writeAnyOfType(Type type, _Pointer pointer, Object? value) {
    _explanations?.push('_writeAnyOfType $type $pointer $value');
    switch (type) {
      case Type.nil:
        // Nothing to write.
        break;

      case Type.type:
        _writeType(pointer, value as Type);

      case Type.pointer:
        _writePointer(pointer, value as _Pointer);

      case Type.uint32:
        _writeUint32(pointer, value as int);

      case Type.boolean:
        _writeBoolean(pointer, value as bool);

      case Type.anyPointer:
        _writeAny(pointer, value);

      case Type.stringPointer:
        _writePointer(pointer, _pointerToString(value as String));

      case Type.closedListPointer:
        _writePointer(pointer, _addClosedList(value as List<Object?>));

      case Type.closedMapPointer:
        _writePointer(pointer, _addClosedMap(value as Map<String, Object?>));

      case Type.growableMapPointer:
        _writePointer(
            pointer, _pointerToGrowableMap(value as _GrowableMap<Object?>));

      case Type.typedMapPointer:
        _writePointer(pointer, _pointerToTypedMap(value as _TypedMap));
    }
    _explanations?.pop();
  }

  /// Returns a [_Pointer] to the `String` [string].
  ///
  /// Returns the [_Pointer] of an existing equal `String` if there is one,
  /// otherwise adds it.
  _Pointer _pointerToString(String string) =>
      _pointersByString[string] ??= _addString(string);

  /// Adds the `String` [string], returns a [_Pointer] to it.
  _Pointer _addString(String string) {
    _explanations?.push('__pointerToString $string');
    final bytes = utf8.encode(string);
    final length = bytes.length;
    final pointer = _reserve(_lengthSize + length);
    _writeLength(pointer, length);
    _setRange(pointer + _lengthSize, pointer + _lengthSize + length, bytes);
    _explanations?.pop();
    return pointer;
  }

  /// Reads the String at [pointer].
  String _readString(_Pointer pointer) {
    final length = _readLength(pointer);
    return utf8.decode(
        _buffer.sublist(pointer + _lengthSize, pointer + _lengthSize + length));
  }

  /// Writes [type] at [pointer].
  void _writeType(_Pointer pointer, Type type) {
    _explanations?.push('_writeType $type');
    _setByte(pointer, type.index);
    _explanations?.pop();
  }

  /// Reads the `Type` at [pointer].
  Type _readType(_Pointer pointer) {
    return Type.values[_buffer[pointer]];
  }

  /// Writes [length] at [pointer].
  void _writeLength(_Pointer pointer, int length,
      {bool allowOverwrite = false}) {
    _explanations?.push('_writeLength $length');
    __writeUint32(pointer, length, allowOverwrite: allowOverwrite);
    _explanations?.pop();
  }

  /// Reads the length at [_Pointer].
  _Pointer _readLength(_Pointer pointer) => _readUint32(pointer);

  /// Writes [pointerValue] at [pointer].
  void _writePointer(_Pointer pointer, _Pointer pointerValue) {
    _explanations?.push('_writePointer $pointerValue');
    __writeUint32(pointer, pointerValue);
    _explanations?.pop();
  }

  /// Reads the [_Pointer] at [_Pointer].
  _Pointer _readPointer(_Pointer pointer) => _readUint32(pointer);

  /// Writes [value] at [pointer].
  void _writeUint32(_Pointer pointer, int value) {
    _explanations?.push('_writeUint32 $value');
    __writeUint32(pointer, value);
    _explanations?.pop();
  }

  void __writeUint32(_Pointer pointer, int value,
      {bool allowOverwrite = false}) {
    _setFourBytes(pointer, value & 0xff, (value >> 8) & 0xff,
        (value >> 16) & 0xff, (value >> 24) & 0xff,
        allowOverwrite: allowOverwrite);
  }

  /// Reads the uint32 at [_Pointer].
  int _readUint32(_Pointer pointer) =>
      _buffer[pointer] +
      (_buffer[pointer + 1] << 8) +
      (_buffer[pointer + 2] << 16) +
      (_buffer[pointer + 3] << 24);

  /// Writes [boolean] at [pointer].
  void _writeBoolean(_Pointer pointer, bool boolean) {
    _explanations?.push('_writeBoolean $boolean');
    _setByte(pointer, boolean ? 1 : 0);
    _explanations?.pop();
  }

  /// Reads the `bool` at [_Pointer].
  bool _readBoolean(_Pointer pointer) {
    switch (_buffer[pointer]) {
      case 0:
        return false;
      case 1:
        return true;
      default:
        throw StateError('Not a valid boolean: ${_buffer[pointer]}');
    }
  }

  /// Reads the bit at [pointer], index [bitIndex].
  bool _readBit(_Pointer pointer, int bitIndex) {
    return ((_buffer[pointer] >> bitIndex) & 1) == 1;
  }

  /// Sets the byte at [pointer] to [uint8].
  ///
  /// If [_explanations] is being used, [allowOverwrite] controls whether
  /// multiple writes to the same byte will be allowed or will throw.
  void _setByte(_Pointer pointer, int uint8, {bool allowOverwrite = false}) {
    _checkAllowWrites();
    _explanations?.explain(pointer, allowOverwrite: allowOverwrite);
    _buffer[pointer] = uint8;
  }

  /// Sets the four bytes at [pointer] to [b1] [b2] [b3] [b4].
  ///
  /// If [_explanations] is being used, [allowOverwrite] controls whether
  /// multiple writes to the same byte will be allowed or will throw.
  void _setFourBytes(_Pointer pointer, int b1, int b2, int b3, int b4,
      {bool allowOverwrite = false}) {
    _setByte(pointer, b1, allowOverwrite: allowOverwrite);
    _setByte(pointer + 1, b2, allowOverwrite: allowOverwrite);
    _setByte(pointer + 2, b3, allowOverwrite: allowOverwrite);
    _setByte(pointer + 3, b4, allowOverwrite: allowOverwrite);
  }

  /// Sets the rang of bytes [from] until [to] to [bytes].
  void _setRange(_Pointer from, _Pointer to, Uint8List bytes) {
    _checkAllowWrites();
    _explanations?.explainRange(from, to);
    _buffer.setRange(from, to, bytes);
  }

  /// Reserves [bytes] number of bytes.
  ///
  /// Increases `_nextFree` accordingly. Expands the buffer if necessary.
  ///
  /// Returns a [_Pointer] to the reserved space.
  _Pointer _reserve(int bytes) {
    _checkAllowWrites();
    final result = _nextFree;
    _nextFree += bytes;
    while (_nextFree > _buffer.length) {
      // TODO(davidmorgan): pass desired size to avoid multiple copies.
      _expand();
    }
    return result;
  }

  /// Copies into a new buffer that's twice as big.
  void _expand() {
    final oldBuffer = _buffer;
    _buffer = Uint8List(_buffer.length * 2);
    _buffer.setRange(0, oldBuffer.length, oldBuffer);
  }

  /// Throws if writes are not allowed.
  void _checkAllowWrites() {
    if (!_allowWrites) throw StateError('This JsonBufferBuilder is read-only.');
  }

  /// Explanations of each byte in the buffer.
  ///
  /// Run tests with `dart -Ddebug_json_buffer=true test -c source` to enable.
  ///
  /// Then, [JsonBufferBuilder#toString] prints additional information for
  /// each byte.
  final _Explanations? _explanations =
      const bool.fromEnvironment('debug_json_buffer') ? _Explanations() : null;

  @override
  String toString() {
    if (_explanations == null) return 'JsonBufferBuilder($_nextFree, $_buffer)';
    final result = StringBuffer('JsonBufferBuilder($_nextFree):\n');
    for (var i = 0; i != _nextFree; ++i) {
      final value = _buffer[i];
      final explanation = _explanations._explanationsByPointer[i];
      if (explanation == null) {
        result.writeln('$i: $value');
      } else {
        result.writeln('$i: $value, $explanation');
      }
    }
    return result.toString();
  }
}
