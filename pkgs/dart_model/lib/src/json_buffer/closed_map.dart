// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'json_buffer_builder.dart';

/// Methods for writing and reading "closed maps".
///
/// A "closed map" is a `Map<String, Object?>` in a byte buffer that has all
/// keys and values known at the time of writing.
extension ClosedMaps on JsonBufferBuilder {
  // Layout: [length, ...entries]
  //
  // Each entry is: [key (pointer to string), value type, value].
  //
  // Values are stored with `_writeSmallValueOrPointer`.
  static const _keySize = _pointerSize;
  static const _valueSize = _typeSize + _pointerSize;
  static const _entrySize = _keySize + _valueSize;

  /// Adds a `Map` to the buffer, returns the [Pointer] to it.
  ///
  /// The `Map` should be small and already evaluated, making it fast to
  /// iterate. For large maps see "growable map" methods.
  Pointer _pointerToClosedMap(Map<String, Object?> map) {
    explanations?.push('addClosedMap $map');

    final pointer = _nextFree;
    final length = map.length;
    _reserve(_lengthSize + length * _entrySize);

    _writeLength(pointer, length);

    var entryPointer = pointer + _pointerSize;
    for (final entry in map.entries) {
      final key = entry.key;
      final value = entry.value;
      _writePointer(entryPointer, _pointerToString(key));
      _writeAny(entryPointer + _keySize, value);
      entryPointer += _entrySize;
    }

    explanations?.pop();
    return pointer;
  }

  /// Returns the [_ClosedMap] at [pointer].
  Map<String, Object?> readClosedMap(Pointer pointer) {
    return _ClosedMap(this, pointer);
  }
}

class _ClosedMap
    with MapMixin<String, Object?>, _EntryMapMixin<String, Object?> {
  final JsonBufferBuilder _buffer;
  final Pointer _pointer;

  _ClosedMap(this._buffer, this._pointer);

  @override
  Object? operator [](Object? key) {
    final iterator = entries.iterator as _ClosedMapEntryIterator;
    while (iterator.moveNext()) {
      if (iterator.current.key == key) return iterator.current.value;
    }
    return null;
  }

  @override
  late final Iterable<String> keys =
      _ClosedMapEntryIterable(_buffer, _pointer).map((e) => e.key);

  @override
  late final Iterable<Object?> values =
      _ClosedMapEntryIterable(_buffer, _pointer).map((e) => e.value);

  @override
  late Iterable<MapEntry<String, Object?>> entries =
      _ClosedMapEntryIterable(_buffer, _pointer);

  @override
  void operator []=(String key, Object? value) {
    throw UnsupportedError('ClosedMap is readonly.');
  }

  @override
  Object? remove(Object? key) {
    throw UnsupportedError('ClosedMap is readonly.');
  }

  @override
  void clear() {
    throw UnsupportedError('ClosedMap is readonly.');
  }
}

/// `Iterable` that reads a "closed map" in a [JsonBufferBuilder].
class _ClosedMapEntryIterable extends Iterable<MapEntry<String, Object?>> {
  final JsonBufferBuilder _buffer;
  final Pointer _pointer;

  _ClosedMapEntryIterable(this._buffer, this._pointer);

  @override
  Iterator<MapEntry<String, Object?>> get iterator =>
      _ClosedMapEntryIterator(_buffer, _pointer);
}

/// `Iterator` that reads a "closed map" in a [JsonBufferBuilder].
class _ClosedMapEntryIterator implements Iterator<MapEntry<String, Object?>> {
  final JsonBufferBuilder _buffer;
  final Pointer _last;

  Pointer _pointer;

  _ClosedMapEntryIterator(this._buffer, Pointer pointer)
      : _last = pointer +
            _pointerSize +
            _buffer.readUint32(pointer) * ClosedMaps._entrySize,
        _pointer = pointer + _pointerSize - ClosedMaps._entrySize;

  @override
  MapEntry<String, Object?> get current => MapEntry(
      _buffer.readString(_buffer.readPointer(_pointer)),
      _buffer._readAny(_pointer + _pointerSize));

  @override
  bool moveNext() {
    if (_pointer == _last) return false;
    if (_pointer > _last) throw StateError('Moved past _last!');
    _pointer += ClosedMaps._entrySize;
    return _pointer != _last;
  }
}
