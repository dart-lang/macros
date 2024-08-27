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
  Pointer _addClosedMap(Map<String, Object?> map) {
    explanations?.push('addClosedMap $map');

    final length = map.length;
    final pointer = _reserve(_lengthSize + length * _entrySize);

    _writeLength(pointer, length);

    var entryPointer = pointer + _lengthSize;
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
  @override
  final int length;

  _ClosedMap(this._buffer, this._pointer)
      : length = _buffer.readUint32(_pointer);

  @override
  Object? operator [](Object? key) {
    final iterator = entries.iterator as _ClosedMapEntryIterator;
    while (iterator.moveNext()) {
      if (iterator.current.key == key) return iterator.current.value;
    }
    return null;
  }

  @override
  late final Iterable<String> keys = _IteratorFunctionIterable(
      () => _ClosedMapKeyIterator(_buffer, _pointer, length),
      length: length);

  @override
  late final Iterable<Object?> values = _IteratorFunctionIterable(
      () => _ClosedMapValueIterator(_buffer, _pointer, length),
      length: length);

  @override
  late final Iterable<MapEntry<String, Object?>> entries =
      _IteratorFunctionIterable(
          () => _ClosedMapEntryIterator(_buffer, _pointer, length),
          length: length);

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

/// `Iterator` that reads a "closed map" in a [JsonBufferBuilder].
abstract class _ClosedMapIterator<T> implements Iterator<T> {
  final JsonBufferBuilder _buffer;
  final Pointer _last;

  Pointer _pointer;

  _ClosedMapIterator(this._buffer, Pointer pointer, int length)
      : _last = pointer + _lengthSize + length * ClosedMaps._entrySize,
        // Subtract because `moveNext` is called before reading.
        _pointer = pointer + _lengthSize - ClosedMaps._entrySize;

  @override
  T get current;

  String get _currentKey => _buffer.readString(_buffer.readPointer(_pointer));
  Object? get _currentValue => _buffer._readAny(_pointer + _pointerSize);

  @override
  bool moveNext() {
    if (_pointer == _last) return false;
    if (_pointer > _last) throw StateError('Moved past _last!');
    _pointer += ClosedMaps._entrySize;
    return _pointer != _last;
  }
}

class _ClosedMapKeyIterator extends _ClosedMapIterator<String> {
  _ClosedMapKeyIterator(super._buffer, super.pointer, super.length);

  @override
  String get current => _currentKey;
}

class _ClosedMapValueIterator extends _ClosedMapIterator<Object?> {
  _ClosedMapValueIterator(super._buffer, super.pointer, super.length);

  @override
  Object? get current => _currentValue;
}

class _ClosedMapEntryIterator
    extends _ClosedMapIterator<MapEntry<String, Object?>> {
  _ClosedMapEntryIterator(super._buffer, super.pointer, super.length);

  @override
  MapEntry<String, Object?> get current => MapEntry(_currentKey, _currentValue);
}
