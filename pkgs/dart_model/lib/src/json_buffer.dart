// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

/// Map with lazily evaluated values.
///
/// This is the efficient way to accumulate data into a [JsonBuffer]. Nested
/// maps should also be `LazyMap`.
class LazyMap with MapMixin<String, Object?> implements Map<String, Object?> {
  final List<String> _keys;
  final Object? Function(String) lookup;

  LazyMap(Iterable<String> keys, this.lookup) : _keys = keys.toList();

  @override
  Iterable<String> get keys => _keys;

  @override
  Object? operator [](Object? key) {
    if (key is! String) {
      throw ArgumentError('Only String keys are allowed, got: $key');
    }
    return lookup(key);
  }

  @override
  void operator []=(String key, Object? value) =>
      throw UnsupportedError('LazyMap is immutable.');

  @override
  void clear() => throw UnsupportedError('LazyMap is immutable.');

  @override
  Object? remove(Object? key) =>
      throw UnsupportedError('LazyMap is immutable.');
}

/// Bytebuffer-backed JSON data.
///
/// Data can be accumulated directly into the buffer which is then immediately
/// ready to write to the wire. On the receiving side, the data can be
/// accessed directly as a `Map<String, Object?>` without copying out of the
/// buffer.
///
/// The constructor takes a [Map], but passing in a normal `Map` _does_
/// require copying. Instead, instantiate with a [LazyMap]. The lazy map will
/// then be evaluated into the buffer. Nested maps in the `LazyMap` must _also_
/// use `LazyMap` otherwise it will still be necessary to copy those.
//
// TODO(davidmorgan): check if it's worth adding a `LazyList` for the same
// reason.
// TODO(davidmorgan): this is just a proof of concept to make sure `dart_model`
// is compatible with fast JSON. Write up a design for discussion, complete
// the implementation.
class JsonBuffer {
  // TODO(davidmorgan): _seenStrings and _decodedStrings are some simple
  // optimizations; complete the design and implementation.
  final Map<String, _Pointer> _seenStrings = {};
  final Map<_Pointer, String> _decodedStrings = {};

  /// The JSON data.
  final _buffer = BytesBuilder(copy: false);

  /// Instantiates a buffer holding [map].
  JsonBuffer(Map<String, Object?> map) {
    _addMap(map);
  }

  /// Immutable `Map` view of the JSON data.
  late final Map<String, Object?> asMap = _JsonBufferMap._(this, 0);

  /// Instantiates using previously-serialized data.
  ///
  /// The buffer is _not_ copied, unpredictable behavior will result if it is
  /// mutated.
  JsonBuffer.deserialize(Uint8List bytes) {
    _buffer.add(bytes);
  }

  /// The JSON data.
  ///
  /// The buffer is _not_ copied, unpredictable behavior will result if it is
  /// mutated.
  Uint8List serialize() {
    // BytesBuilder doesn't provide a way to access just the bytes without also
    // clearing the builder, so we take the bytes and then just add them back.
    //
    // If there is more than one chunk currently in the buffer, this will end up
    // creating a copy of all the bytes, into a single buffer. Subsequent calls
    // however will always just have the one chunk, and will not copy.
    var bytes = _buffer.takeBytes();
    _buffer.add(bytes);
    return bytes;
  }

  /// Adds a `Map` to the buffer.
  void _addMap(Map<String, Object?> map) {
    List<String> keys;
    Object? Function(String) lookup;
    if (map is LazyMap) {
      keys = map._keys;
      lookup = map.lookup;
    } else {
      keys = map.keys.toList();
      lookup = map.lookup;
    }
    _evaluateAndAddMap(keys, lookup);
  }

  /// Adds a `Map` to the buffer.
  ///
  /// The `Map` is represented as a `List` of keys and a lookup function, to
  /// allow values to be written directly rather than copied.
  void _evaluateAndAddMap(List<String> keys, Object? Function(String) lookup) {
    // Maps are stored as:
    //
    // [size, pointer to key 1, pointer to value 1, pointer to key 2,
    // pointer to value 2, ...]
    //
    // The size is immediately known, so reserve space for the map, allowing
    // full keys and values to be appended afterwards in any order.
    final length = keys.length;
    _addInt(_intSize, length);
    var mapBytes = _reserve(length * _intSize * 2);

    // Now iterate computing values. The keys and values are appended to the
    // buffer, and pointers to them written into the space that was reserved.
    var offset = 0;
    for (var i = 0; i != length; ++i) {
      final key = keys[i];
      _writeInt(_intSize, _addString(key), mapBytes, offset: offset);
      offset += _intSize;
      final value = lookup(key);
      _writeInt(_intSize, _addValue(value), mapBytes, offset: offset);
      offset += _intSize;
    }
  }

  /// Adds a value of unknown type.
  ///
  /// So, writes the type then the value.
  ///
  /// Returns a pointer to the front of the value;
  _Pointer _addValue(Object? value) {
    var pointer = _buffer.length;
    if (value is int) {
      _buffer.addByte(Type.int.index);
      _addInt(_intSize, value);
    } else if (value is String) {
      _buffer.addByte(Type.string.index);
      // Must reserve space for the pointer first, before calling `_addString`.
      var pointerBytes = _reserve(_intSize);
      _writeInt(_intSize, _addString(value), pointerBytes);
    } else if (value is bool) {
      _buffer.addByte(Type.bool.index);
      _addBool(value);
    } else if (value is Map<String, Object?>) {
      _buffer.addByte(Type.map.index);
      _addMap(value);
    } else {
      throw UnsupportedError('Unsupported value type: ${value.runtimeType}');
    }
    return pointer;
  }

  /// Adds a `String`, returns a [_Pointer] to it.
  ///
  /// If the `String` has been seen before the previously stored value is
  /// reused and its `_Pointer` returned.
  _Pointer _addString(String value) {
    final maybeResult = _seenStrings[value];
    if (maybeResult != null) return maybeResult;
    final pointer = _buffer.length;
    // TODO(davidmorgan): it might be faster to write directly into the buffer.
    final bytes = utf8.encode(value);
    final length = bytes.length;
    _addInt(_intSize, length);
    _buffer.add(bytes);
    _seenStrings[value] = pointer;
    return pointer;
  }

  /// Adds a `bool`.
  _Pointer _addBool(bool value) {
    final pointer = _buffer.length;
    _buffer.addByte(value ? 1 : 0);
    return pointer;
  }

  /// Adds an integer to [_buffer].
  ///
  /// TODO(davidomorgan): variable size ints don't easily work with the need to
  /// know map sizes in advance. Picking a fixed max size seems like an
  /// unwanted limitation. Do better!
  void _addInt(int intSize, int value) {
    var bytes = _reserve(intSize);
    _writeInt(intSize, value, bytes);
  }

  /// Writes [value] to [bytes], using all the space in [bytes].
  void _writeInt(int intSize, int value, Uint8List bytes, {int offset = 0}) {
    for (var i = 0; i < intSize; i++) {
      bytes[i + offset] = value >> 8 * i;
    }
  }

  /// Adds a new [Uint8List] of [size] to [_buffer] and returns it.
  ///
  /// This list can be filled in later, but must be filled in before any call
  /// to [serialize]. Manipulations after [serialize] have undefined behavior.
  Uint8List _reserve(int size) {
    var bytes = Uint8List(size);
    _buffer.add(bytes);
    return bytes;
  }

  /// Reads the integer at [_Pointer].
  int _readInt(_Pointer pointer, int intSize) {
    var bytes = serialize();
    var value = 0;
    for (var i = 0; i < intSize; i++) {
      value ^= bytes[pointer + i] << (8 * i);
    }
    return value;
  }

  /// Reads the value of unknown type at [_Pointer].
  Object? _readValue(_Pointer pointer) {
    var bytes = serialize();
    final type = Type.values[bytes[pointer]];
    switch (type) {
      case Type.int:
        return _readInt(pointer + _typeSize, _intSize);
      case Type.string:
        return _readString(_readPointer(pointer + _typeSize));
      case Type.bool:
        return _readBool(pointer + _typeSize);
      case Type.map:
        return _JsonBufferMap._(this, pointer + _typeSize);
    }
  }

  /// Reads the `_Pointer` at [_Pointer].
  _Pointer _readPointer(_Pointer pointer) {
    return _readInt(pointer, _intSize);
  }

  /// Reads the `String` at [_Pointer].
  String _readString(_Pointer pointer) {
    final maybeResult = _decodedStrings[pointer];
    if (maybeResult != null) return maybeResult;
    final length = _readInt(pointer, _intSize);
    return _decodedStrings[pointer] ??= utf8.decode(
        serialize().sublist(pointer + _intSize, pointer + _intSize + length));
  }

  /// Reads the `bool` at [_Pointer].
  bool _readBool(_Pointer pointer) {
    final value = serialize()[pointer];
    if (value == 1) return true;
    if (value == 0) return false;
    throw StateError('Unexpected bool value: $value');
  }

  @override
  String toString() => _buffer.toString();
}

/// Immutable `Map` view into a [JsonBuffer].
class _JsonBufferMap
    with MapMixin<String, Object?>
    implements Map<String, Object?> {
  final JsonBuffer _buffer;
  final _Pointer _pointer;

  _JsonBufferMap._(this._buffer, this._pointer);

  @override
  Object? operator [](Object? key) {
    final iterator = entries.iterator as _JsonBufferMapEntryIterator;
    // TODO(davidmorgan): for small maps this is probably already efficient
    // enough. Do something better for large maps, for example sorting keys
    // and binary search?
    while (iterator.moveNext()) {
      if (iterator.current.key == key) return iterator.current.value;
    }
    return null;
  }

  @override
  late Iterable<String> keys =
      _JsonBufferMapEntryIterable(_buffer, _pointer, readValues: false)
          .map((e) => e.key);

  @override
  late Iterable<Object?> values =
      _JsonBufferMapEntryIterable(_buffer, _pointer, readKeys: false)
          .map((e) => e.value);

  @override
  late Iterable<MapEntry<String, Object?>> entries =
      _JsonBufferMapEntryIterable(_buffer, _pointer);

  @override
  void operator []=(String key, Object? value) {
    throw UnsupportedError('JsonBufferMap is readonly.');
  }

  @override
  void clear() {
    throw UnsupportedError('JsonBufferMap is readonly.');
  }

  @override
  Object? remove(Object? key) {
    throw UnsupportedError('JsonBufferMap is readonly.');
  }
}

/// `Iterable` that reads a `Map` in a [JsonBuffer].
class _JsonBufferMapEntryIterable
    with IterableMixin<MapEntry<String, Object?>>
    implements Iterable<MapEntry<String, Object?>> {
  final JsonBuffer _buffer;
  final _Pointer _pointer;
  final bool readKeys;
  final bool readValues;

  _JsonBufferMapEntryIterable(this._buffer, this._pointer,
      {this.readKeys = true, this.readValues = true});

  @override
  Iterator<MapEntry<String, Object?>> get iterator =>
      _JsonBufferMapEntryIterator(_buffer, _pointer,
          readKeys: readKeys, readValues: readValues);
}

/// `Iterator` that reads a `Map` in a [JsonBuffer].
///
/// TODO(davidmorgan): refactor away from the awkward `readKeys`/`readValues`.
class _JsonBufferMapEntryIterator
    implements Iterator<MapEntry<String, Object?>> {
  final JsonBuffer _buffer;
  _Pointer _pointer;
  final _Pointer _last;
  final bool readKeys;
  final bool readValues;

  _JsonBufferMapEntryIterator(this._buffer, _Pointer pointer,
      {this.readKeys = true, this.readValues = true})
      : _last = pointer +
            _intSize +
            _buffer._readInt(pointer, _intSize) * 2 * _intSize,
        _pointer = pointer - _intSize;

  @override
  MapEntry<String, Object?> get current => MapEntry(
      readKeys ? _buffer._readString(_buffer._readPointer(_pointer)) : '',
      readValues
          ? _buffer._readValue(_buffer._readPointer(_pointer + _intSize))
          : null);

  @override
  bool moveNext() {
    if (_pointer == _last) return false;
    if (_pointer > _last) throw StateError('Moved past _last!');
    _pointer += _intSize * 2;
    return _pointer != _last;
  }
}

/// Pointer into a [JsonBuffer].
typedef _Pointer = int;

/// Type of a value in a [JsonBuffer].
enum Type {
  string,
  bool,
  map,
  int,
}

/// Bytes needed by [Type].
final _typeSize = 1;

/// Bytes for each int.
final _intSize = 4;

extension _MapExtensions<K, V> on Map<K, V> {
  V? lookup(Object? key) => this[key];
}
