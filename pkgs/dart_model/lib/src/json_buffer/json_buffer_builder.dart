// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

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

  final Map<TypedMapSchema, Pointer> _pointersBySchema = Map.identity();
  final Map<Pointer, TypedMapSchema> _schemasByPointer = {};

  final Map<String, Pointer> _pointersByString = {};

  JsonBufferBuilder.deserialize(this._buffer)
      : _allowWrites = false,
        _nextFree = _buffer.length {
    map = _readGrowableMap<Object?>(0);
  }

  JsonBufferBuilder()
      : _allowWrites = true,
        _buffer = Uint8List(_initialBufferSize),
        _nextFree = 0 {
    map = createGrowableMap<Object?>();
  }

  /// The JSON data.
  ///
  /// The buffer is _not_ copied, unpredictable behavior will result if it is
  /// mutated.
  Uint8List serialize() => Uint8List.sublistView(_buffer, 0, _nextFree);

  /// The number of bytes written.
  int get length => _nextFree;

  /// Reads the value at [Pointer], which must have been written with
  /// [_writeAny].
  Object? _readAny(Pointer pointer) {
    final type = readType(pointer);
    return _read(type, pointer + _typeSize);
  }

  /// Reads the value of type [Type] at [Pointer].
  Object? _read(Type type, Pointer pointer) {
    switch (type) {
      case Type.nil:
        return null;
      case Type.type:
        return readType(pointer);
      case Type.pointer:
        return readPointer(pointer);
      case Type.uint32:
        return readUint32(pointer);
      case Type.boolean:
        return readBoolean(pointer);
      case Type.stringPointer:
        return readString(readPointer(pointer));
      case Type.closedMapPointer:
        return readClosedMap(readPointer(pointer));
      case Type.growableMapPointer:
        return _readGrowableMap<Object?>(readPointer(pointer));
      case Type.typedMapPointer:
        return readTypedMap(readPointer(pointer));
    }
  }

  /// Writes the type of [value] then writes the value using [_writeAnyOfType].
  void _writeAny(Pointer pointer, Object? value) {
    explanations?.push('_writeAny $pointer $value');
    final type = Type._of(value);
    _writeType(pointer, type);
    _writeAnyOfType(type, pointer + _typeSize, value);
    explanations?.pop();
  }

  /// Writes [value] of type [type] to [pointer].
  ///
  /// The type is assumed to be known statically and is not written.
  ///
  /// If [value] fits in four bytes, it is written directly.
  ///
  /// Otherwise, a pointer is written. It might be a pointer to an existing
  /// value if there is one, or a new value may be written as well.
  void _writeAnyOfType(Type type, Pointer pointer, Object? value) {
    explanations?.push('_writeAnyOfType $type $pointer $value');
    switch (type) {
      case Type.nil:
        // Nothing to write.
        break;

      case Type.type:
        _writeType(pointer, value as Type);

      case Type.pointer:
        _writePointer(pointer, value as Pointer);

      case Type.uint32:
        _writeUint32(pointer, value as int);

      case Type.boolean:
        _writeBoolean(pointer, value as bool);

      case Type.stringPointer:
        _writePointer(pointer, _pointerToString(value as String));

      case Type.closedMapPointer:
        _writePointer(pointer, _addClosedMap(value as Map<String, Object?>));

      case Type.growableMapPointer:
        _writePointer(
            pointer, _pointerToGrowableMap(value as _GrowableMap<Object?>));

      case Type.typedMapPointer:
        _writePointer(pointer, _pointerToTypedMap(value as _TypedMap));
    }
    explanations?.pop();
  }

  /// Returns a [Pointer] to the `String` [value].
  ///
  /// Returns the [Pointer] of an existing equal `String` if there is one,
  /// otherwise adds it.
  Pointer _pointerToString(String value) =>
      _pointersByString[value] ??= _addString(value);

  Pointer _addString(String value) {
    explanations?.push('__pointerToString $value');
    final bytes = utf8.encode(value);
    final length = bytes.length;
    final pointer = _reserve(_lengthSize + length);
    _writeLength(pointer, length);
    _setRange(pointer + 4, pointer + 4 + length, bytes);
    explanations?.pop();
    return pointer;
  }

  void _writeType(Pointer pointer, Type value) {
    explanations?.push('_writeType $value');
    _setByte(pointer, value.index);
    explanations?.pop();
  }

  Type readType(Pointer pointer) {
    return Type.values[_buffer[pointer]];
  }

  void _writeLength(Pointer pointer, Pointer value,
      {bool allowOverwrite = false}) {
    explanations?.push('_writeLength $value');
    __writeUint32(pointer, value, allowOverwrite: allowOverwrite);
    explanations?.pop();
  }

  /// Adds a new pointer pointing to [pointer], returns it.
  Pointer _addPointerTo(Pointer pointer) {
    explanations?.push('_addPointerToPointer $pointer');
    final result = _reserve(4);
    _writePointer(result, pointer);
    explanations?.pop();
    return result;
  }

  void _writePointer(Pointer pointer, Pointer value) {
    explanations?.push('_writePointer $value');
    __writeUint32(pointer, value);
    explanations?.pop();
  }

  void _writeUint32(Pointer pointer, int value) {
    explanations?.push('_writeUint32 $value');
    __writeUint32(pointer, value);
    explanations?.pop();
  }

  void __writeUint32(Pointer pointer, int value,
      {bool allowOverwrite = false}) {
    _setFourBytes(pointer, value & 0xff, (value >> 8) & 0xff,
        (value >> 16) & 0xff, (value >> 24) & 0xff,
        allowOverwrite: allowOverwrite);
  }

  void _writeBoolean(Pointer pointer, bool value) {
    explanations?.push('_writeBoolean $value');
    _setByte(pointer, value ? 1 : 0);
    explanations?.pop();
  }

  /// Reads the length at [Pointer].
  Pointer readLength(Pointer pointer) => _readUint32(pointer);

  /// Reads the [Pointer] at [Pointer].
  Pointer readPointer(Pointer pointer) => _readUint32(pointer);

  /// Reads the uint32 at [Pointer].
  int readUint32(Pointer pointer) => _readUint32(pointer);

  int _readUint32(Pointer pointer) =>
      _buffer[pointer] +
      (_buffer[pointer + 1] << 8) +
      (_buffer[pointer + 2] << 16) +
      (_buffer[pointer + 3] << 24);

  /// Reads the boolean at [Pointer].
  bool readBoolean(Pointer pointer) {
    switch (_buffer[pointer]) {
      case 0:
        return false;
      case 1:
        return true;
      default:
        throw StateError('Not a valid boolean: ${_buffer[pointer]}');
    }
  }

  /// Reads the String at [Pointer].
  String readString(Pointer pointer) {
    final length = readLength(pointer);
    return utf8.decode(
        _buffer.sublist(pointer + _lengthSize, pointer + _lengthSize + length));
  }

  void _setBit(Pointer pointer, int bitIndex, bool value) {
    _checkAllowWrites();
    explanations?.explain(pointer, allowOverwrite: true);
    if (value) {
      _buffer[pointer] |= 1 << bitIndex;
    } else {
      _buffer[pointer] &= 0xff ^ (1 << bitIndex);
    }
  }

  bool readBit(Pointer pointer, int bitIndex) {
    return ((_buffer[pointer] >> bitIndex) & 1) == 1;
  }

  void _setByte(Pointer pointer, int uint8, {bool allowOverwrite = false}) {
    _checkAllowWrites();
    explanations?.explain(pointer, allowOverwrite: allowOverwrite);
    _buffer[pointer] = uint8;
  }

  void _setFourBytes(Pointer pointer, int b1, int b2, int b3, int b4,
      {bool allowOverwrite = false}) {
    _setByte(pointer, b1, allowOverwrite: allowOverwrite);
    _setByte(pointer + 1, b2, allowOverwrite: allowOverwrite);
    _setByte(pointer + 2, b3, allowOverwrite: allowOverwrite);
    _setByte(pointer + 3, b4, allowOverwrite: allowOverwrite);
  }

  void _setRange(Pointer from, Pointer to, Uint8List bytes) {
    _checkAllowWrites();
    explanations?.explainRange(from, to);
    _buffer.setRange(from, to, bytes);
  }

  /// Reserves [bytes] number of bytes.
  ///
  /// Increases `_nextFree` accordingly. Expands the buffer if necessary.
  ///
  /// Returns a [Pointer] to the reserved space.
  Pointer _reserve(int bytes) {
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

  void _checkAllowWrites() {
    if (!_allowWrites) throw StateError('This JsonBufferBuilder is read-only.');
  }

  @override
  String toString() {
    if (explanations == null) return 'JsonBufferBuilder($_nextFree, $_buffer)';
    final result = StringBuffer('JsonBufferBuilder($_nextFree):\n');
    for (var i = 0; i != _nextFree; ++i) {
      final value = _buffer[i];
      final explanation = explanations!._explanationsByPointer[i];
      if (explanation == null) {
        result.writeln('$i: $value');
      } else {
        result.writeln('$i: $value, $explanation');
      }
    }
    return result.toString();
  }
}
