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
  // Values are stored with `_writeAny`.
  static const _keySize = _pointerSize;
  static const _valueSize = _typeSize + _pointerSize;
  static const _entrySize = _keySize + _valueSize;

  /// Adds a `Map` to the buffer, returns the [_Pointer] to it.
  ///
  /// The `Map` should be small and already evaluated, making it fast to
  /// iterate. For large maps see "growable map" methods.
  _Pointer _addClosedMap(Map<String, Object?> map) {
    _explanations?.push('addClosedMap $map');

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

    _explanations?.pop();
    return pointer;
  }

  /// Returns the [_ClosedMap] at [pointer].
  Map<String, Object?> _readClosedMap(
      _Pointer pointer, Map<String, Object?>? parent) {
    return _ClosedMap(this, pointer, parent);
  }
}

class _ClosedMap
    with MapMixin<String, Object?>, _EntryMapMixin<String, Object?>
    implements MapInBuffer {
  @override
  final JsonBufferBuilder buffer;
  final _Pointer _pointer;
  @override
  final Map<String, Object?>? parent;
  @override
  final int length;

  _ClosedMap(this.buffer, this._pointer, this.parent)
      : length = buffer._readLength(_pointer);

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
      () => _ClosedMapKeyIterator(buffer, this, _pointer, length),
      length: length);

  @override
  late final Iterable<Object?> values = _IteratorFunctionIterable(
      () => _ClosedMapValueIterator(buffer, this, _pointer, length),
      length: length);

  @override
  late final Iterable<MapEntry<String, Object?>> entries =
      _IteratorFunctionIterable(
          () => _ClosedMapEntryIterator(buffer, this, _pointer, length),
          length: length);

  @override
  void operator []=(String key, Object? value) {
    throw UnsupportedError(
        'This JsonBufferBuilder map is read-only, see "createGrowableMap".');
  }

  @override
  Object? remove(Object? key) {
    throw UnsupportedError(
        'This JsonBufferBuilder map is read-only, see "createGrowableMap".');
  }

  @override
  void clear() {
    throw UnsupportedError(
        'This JsonBufferBuilder map is read-only, see "createGrowableMap".');
  }

  @override
  bool operator ==(Object other) =>
      other is _ClosedMap &&
      other.buffer == buffer &&
      other._pointer == _pointer;

  @override
  int get hashCode => Object.hash(buffer, _pointer);
}

/// `Iterator` that reads a "closed map" in a [JsonBufferBuilder].
abstract class _ClosedMapIterator<T> implements Iterator<T> {
  final JsonBufferBuilder _buffer;
  final _ClosedMap _parent;
  final _Pointer _last;

  _Pointer _pointer;

  _ClosedMapIterator(this._buffer, this._parent, _Pointer pointer, int length)
      : _last = pointer + _lengthSize + length * ClosedMaps._entrySize,
        // Subtract because `moveNext` is called before reading.
        _pointer = pointer + _lengthSize - ClosedMaps._entrySize;

  @override
  T get current;

  String get _currentKey => _buffer._readString(_buffer._readPointer(_pointer));
  Object? get _currentValue =>
      _buffer._readAny(_pointer + _pointerSize, parent: _parent);

  @override
  bool moveNext() {
    if (_pointer == _last) return false;
    if (_pointer > _last) throw StateError('Moved past _last!');
    _pointer += ClosedMaps._entrySize;
    return _pointer != _last;
  }
}

class _ClosedMapKeyIterator extends _ClosedMapIterator<String> {
  _ClosedMapKeyIterator(
      super._buffer, super._porent, super.pointer, super.length);

  @override
  String get current => _currentKey;
}

class _ClosedMapValueIterator extends _ClosedMapIterator<Object?> {
  _ClosedMapValueIterator(
      super._buffer, super._porent, super.pointer, super.length);

  @override
  Object? get current => _currentValue;
}

class _ClosedMapEntryIterator
    extends _ClosedMapIterator<MapEntry<String, Object?>> {
  _ClosedMapEntryIterator(
      super._buffer, super._porent, super.pointer, super.length);

  @override
  MapEntry<String, Object?> get current => MapEntry(_currentKey, _currentValue);
}
