// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'json_buffer_builder.dart';

/// Methods for writing and reading "growable maps".
///
/// A "growable map" is a `Map<String, Object?>` in a byte buffer that is
/// implemented as a linked list of entries, so it can accept new entries.
extension GrowableMaps on JsonBufferBuilder {
  // Layout:
  //
  // Empty map is [null pointer].
  //
  // Map with one entry is [pointer to first node], and that first node is
  // [null pointer, entry].
  //
  // Then each additional entry adds a [pointer, entry] and sets the null
  // pointer in the last entry to the new entry.
  //
  // Each entry is: [key (pointer to string), value type, value].
  //
  // Values are stored with `_writeSmallValueOrPointer`.
  static const _keySize = _pointerSize;
  static const _valueSize = _typeSize + _pointerSize;
  static const _entrySize = _pointerSize + _keySize + _valueSize;

  /// Creates a "growable map".
  ///
  /// It can have new values added to it, hence "growable".
  ///
  /// It is linked to the `JsonBufferBuilder` that creates it: it can be added
  /// to any collection in the same `JsonBufferBuilder` without copying.
  /// Adding to a collection in a different `JsonBufferBuilder` is an error.
  Map<String, V> createGrowableMap<V>() {
    explanations?.push('addGrowableMap');
    final pointer = _nextFree;
    // Initially a "growable map" is just a null pointer; nothing to write.
    _reserve(_pointerSize);
    explanations?.pop();
    return _readGrowableMap<V>(pointer);
  }

  Pointer _pointerToGrowableMap(_GrowableMap<Object?> map) {
    _checkGrowableMapOwnership(map);
    return map._pointer;
  }

  /// Throws if [map is backed by a different buffer to `this`.
  void _checkGrowableMapOwnership(_GrowableMap map) {
    if (map._buffer != this) {
      throw UnsupportedError('Maps created with `addGrowableMap` can only '
          'be added to the JsonBufferBuilder instance that created them.');
    }
  }

  /// Returns the [_GrowableMap] at [pointer].
  Map<String, V> _readGrowableMap<V>(Pointer pointer) {
    return _GrowableMap<V>(this, pointer);
  }
}

class _GrowableMap<V> with MapMixin<String, V>, _EntryMapMixin<String, V> {
  final JsonBufferBuilder _buffer;
  final Pointer _pointer;
  Pointer? _lastPointer;

  _GrowableMap(this._buffer, this._pointer);

  @override
  V? operator [](Object? key) {
    // TODO(davidmorgan): these maps could be large, we probably need a more
    // efficient lookup than linear search.
    final iterator = entries.iterator as _GrowableMapEntryIterator<V>;
    while (iterator.moveNext()) {
      if (iterator.current.key == key) return iterator.current.value;
    }
    return null;
  }

  @override
  late final Iterable<String> keys =
      _GrowableMapEntryIterable<V>(_buffer, _pointer).map((e) => e.key);

  @override
  late final Iterable<V> values =
      _GrowableMapEntryIterable<V>(_buffer, _pointer).map((e) => e.value);

  @override
  late Iterable<MapEntry<String, V>> entries =
      _GrowableMapEntryIterable<V>(_buffer, _pointer);

  @override
  void operator []=(String key, V value) {
    explanations?.push('GrowableMap[]= $key $value');

    // If `_lastPointer` is not set yet, walk the map to find the end of it.
    if (_lastPointer == null) {
      final iterator = _GrowableMapEntryIterator<V>(_buffer, _pointer);
      _lastPointer = _pointer;
      while (iterator.moveNext()) {
        _lastPointer = iterator._pointer;
      }
    }

    // Reserve and write the new node.
    final pointer = _buffer._nextFree;
    _buffer._reserve(GrowableMaps._entrySize);
    final entryPointer = pointer + _pointerSize;
    _buffer._writePointer(entryPointer, _buffer._pointerToString(key));
    _buffer._writeAny(entryPointer + _pointerSize, value);

    // Point to the new node in the previous node.
    _buffer._writePointer(_lastPointer!, pointer);
    // Update `_lastPointer` to the new node.
    _lastPointer = pointer;
    explanations?.pop();
  }

  @override
  V remove(Object? key) {
    throw UnsupportedError('JsonBufferBuilder growable maps are append only.');
  }

  @override
  void clear() {
    throw UnsupportedError('JsonBufferBuilder growable maps are append only.');
  }
}

/// `Iterable` that reads a "growable map" in a [JsonBufferBuilder].
class _GrowableMapEntryIterable<V> extends Iterable<MapEntry<String, V>> {
  final JsonBufferBuilder _buffer;
  final Pointer _pointer;

  _GrowableMapEntryIterable(this._buffer, this._pointer);

  @override
  Iterator<MapEntry<String, V>> get iterator =>
      _GrowableMapEntryIterator<V>(_buffer, _pointer);
}

/// `Iterator` that reads a "growable map" in a [JsonBufferBuilder].
class _GrowableMapEntryIterator<V> implements Iterator<MapEntry<String, V>> {
  final JsonBufferBuilder _buffer;
  Pointer _pointer;

  _GrowableMapEntryIterator(this._buffer, this._pointer);

  @override
  MapEntry<String, V> get current => MapEntry(
      _buffer.readString(_buffer.readPointer(_pointer + _pointerSize)),
      _buffer._readAny(_pointer + _pointerSize + GrowableMaps._keySize) as V);

  @override
  bool moveNext() {
    _pointer = _buffer.readPointer(_pointer);
    return _pointer != 0;
  }
}
