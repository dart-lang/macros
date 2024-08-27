// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'json_buffer_builder.dart';

class TypedMapSchema {
  final List<String> _keys;
  final List<Type> _valueTypes;
  final List<int> _offsets;
  final bool isAllBooleans;

  TypedMapSchema(Map<String, Type> fieldTypes)
      : this._(fieldTypes.keys.toList(), fieldTypes.values.toList());

  TypedMapSchema._(this._keys, this._valueTypes)
      : _offsets = List<int>.filled(_keys.length + 1, 0),
        isAllBooleans = _valueTypes.every((t) => t == Type.boolean) {
    for (var i = 1; i != _valueTypes.length + 1; ++i) {
      _offsets[i] = _offsets[i - 1] + _valueTypes[i - 1].sizeInBytes;
    }
  }

  Map<String, Type> toMap() => {
        for (var i = 0; i != _keys.length; ++i) _keys[i]: _valueTypes[i],
      };

  // Schemas should be instantiated once per type in generated code, so looking
  // up by identity is sufficient. It's also the fastest way to do it.
  //
  // Adding deep equality and hashCode to make testing easier is tempting, so
  // add throwing implementations to prevent that.
  @override
  bool operator ==(Object other) =>
      throw UnsupportedError('TypedMapSchema should be compared by identity.');
  @override
  int get hashCode =>
      throw UnsupportedError('TypedMapSchema should be compared by identity.');

  int get length => _keys.length;

  int offsetAtIndex(int i) =>
      isAllBooleans ? throw StateError('TypedMap is all bools!') : _offsets[i];

  Type typeAtIndex(int i) => isAllBooleans ? Type.boolean : _valueTypes[i];

  int get fieldSetSize => (length + 7) ~/ 8;

  int get valueSize => isAllBooleans ? fieldSetSize : _offsets.last;

  @override
  String toString() => 'TypedMapSchema$_keys$_valueTypes';
}

extension TypedMaps on JsonBufferBuilder {
  /// Creates and fills a "typed map".
  ///
  /// It is linked to the `JsonBufferBuilder` that creates it: it can be added
  /// to any collection in the same `JsonBufferBuilder` without copying.
  /// Adding to a collection in a different `JsonBufferBuilder` is an error.
  ///
  /// The returned value must be separately added to the buffer. Otherwise,
  /// the buffer contains data that is not reachable from the root [map].
  Map<String, Object?> createTypedMap(TypedMapSchema schema,
      [Object? v0,
      Object? v1,
      Object? v2,
      Object? v3,
      Object? v4,
      Object? v5,
      Object? v6,
      Object? v7]) {
    explanations?.push('addTypedMap $schema');

    final filled = switch (schema.length) {
      0 => true,
      1 => v0 != null,
      2 => v0 != null && v1 != null,
      3 => v0 != null && v1 != null && v2 != null,
      4 => v0 != null && v1 != null && v2 != null && v3 != null,
      5 => v0 != null && v1 != null && v2 != null && v3 != null && v4 != null,
      6 => v0 != null &&
          v1 != null &&
          v2 != null &&
          v3 != null &&
          v4 != null &&
          v5 != null,
      7 => v0 != null &&
          v1 != null &&
          v2 != null &&
          v3 != null &&
          v4 != null &&
          v5 != null &&
          v6 != null,
      8 => v0 != null &&
          v1 != null &&
          v2 != null &&
          v3 != null &&
          v4 != null &&
          v5 != null &&
          v6 != null &&
          v7 != null,
      _ => throw UnsupportedError('Too long: ${schema.length}')
    };

    var schemaPointer = _pointersBySchema[schema] ??=
        _addPointerTo(_addClosedMap(schema.toMap()));
    if (filled) schemaPointer |= 0x80000000;

    final size = filled
        ? schema.valueSize
        : (v0 == null ? 0 : schema.typeAtIndex(0).sizeInBytes) +
            (v1 == null ? 0 : schema.typeAtIndex(1).sizeInBytes) +
            (v2 == null ? 0 : schema.typeAtIndex(2).sizeInBytes) +
            (v3 == null ? 0 : schema.typeAtIndex(3).sizeInBytes) +
            (v4 == null ? 0 : schema.typeAtIndex(4).sizeInBytes) +
            (v5 == null ? 0 : schema.typeAtIndex(5).sizeInBytes) +
            (v6 == null ? 0 : schema.typeAtIndex(6).sizeInBytes) +
            (v7 == null ? 0 : schema.typeAtIndex(7).sizeInBytes);

    final pointer =
        _reserve(_pointerSize + (filled ? 0 : schema.fieldSetSize) + size);
    _writePointer(pointer, schemaPointer);

    if (!filled) {
      _setByte(
          pointer + _pointerSize,
          (v0 == null ? 0 : 1) +
              (v1 == null ? 0 : 2) +
              (v2 == null ? 0 : 4) +
              (v3 == null ? 0 : 8) +
              (v4 == null ? 0 : 16) +
              (v5 == null ? 0 : 32) +
              (v6 == null ? 0 : 64) +
              (v7 == null ? 0 : 128));
    }

    var offset = 0;

    void addValue(int index, Object? value) {
      explanations?.push('addValue $index $value');

      if (schema.isAllBooleans) {
        final valuePointer = pointer +
            _pointerSize +
            (filled ? 0 : schema.fieldSetSize) +
            (offset ~/ 8);
        final bitIndex = offset % 8;
        _setBit(valuePointer, bitIndex, value as bool);
        offset++;
      } else {
        final valuePointer = pointer +
            _pointerSize +
            (filled ? 0 : schema.fieldSetSize) +
            offset;
        final valueType = schema.typeAtIndex(index);
        _writeAnyOfType(valueType, valuePointer, value);
        offset += valueType.sizeInBytes;
      }
      explanations?.pop();
    }

    if (v0 != null) addValue(0, v0);
    if (v1 != null) addValue(1, v1);
    if (v2 != null) addValue(2, v2);
    if (v3 != null) addValue(3, v3);
    if (v4 != null) addValue(4, v4);
    if (v5 != null) addValue(5, v5);
    if (v6 != null) addValue(6, v6);
    if (v7 != null) addValue(7, v7);

    explanations?.pop();
    return _TypedMap(this, pointer);
  }

  /// Returns the [Pointer] to [map].
  ///
  /// The [map] must have been created in this buffer using
  /// [createTypedMap].
  Pointer _pointerToTypedMap(_TypedMap map) {
    _checkTypedMapOwnership(map);
    return map._pointer;
  }

  /// Throws if [map is backed by a different buffer to `this`.
  void _checkTypedMapOwnership(_TypedMap map) {
    if (map._buffer != this) {
      throw UnsupportedError('Maps created with `addGrowableMap` can only '
          'be added to the JsonBufferBuilder instance that created them.');
    }
  }

  Map<String, Object?> readTypedMap(Pointer pointer) {
    return _TypedMap(this, pointer);
  }
}

class _TypedMap
    with MapMixin<String, Object?>, _EntryMapMixin
    implements Map<String, Object?> {
  final JsonBufferBuilder _buffer;
  final Pointer _pointer;

  // If a `TypedMap` is created then immediately added to another `Map` then
  // these values are never needed, just the `_pointer`. Use `late` so they are
  // only computed if needed.
  late final Pointer _schemaPointer =
      _buffer.readPointer(_pointer) & 0x7fffffff;
  late final TypedMapSchema _schema =
      _buffer._schemasByPointer[_schemaPointer] ??= TypedMapSchema(
          _buffer.readClosedMap(_buffer.readPointer(_schemaPointer)).cast());
  late final bool filled = (_buffer.readPointer(_pointer) & 0x80000000) != 0;

  _TypedMap(this._buffer, this._pointer);

  bool hasField(int index) {
    if (index < 0 || index >= _schema.length) {
      throw RangeError.value(
          index, 'index', 'Is out of range, length: ${_schema.length}.');
    }
    if (filled) return true;
    final byte = index ~/ 8;
    final bit = index % 8;
    return _buffer.readBit(_pointer + _pointerSize + byte, bit);
  }

  @override
  Object? operator [](Object? key) {
    final iterator = entries.iterator;
    // TODO(davidmorgan): for small maps this is probably already efficient
    // enough. Do something better for large maps, for example sorting keys
    // and binary search?
    while (iterator.moveNext()) {
      if (iterator.current.key == key) return iterator.current.value;
    }
    return null;
  }

  // For performance, `MapMixin` uses `keys.length`.
  @override
  late final int length = _computeLength();

  int _computeLength() {
    if (filled) return _schema.length;
    var result = 0;
    for (var i = 0; i != _schema.length; ++i) {
      if (hasField(i)) ++result;
    }
    return result;
  }

  // For performance, `MapMixin` uses `keys.isEmpty`.
  @override
  bool get isEmpty => filled ? _schema.length == 0 : length == 0;

// For performance, `MapMixin` uses `keys.isNotEmpty`.
  @override
  bool get isNotEmpty => !isEmpty;

  @override
  late final Iterable<String> keys = _IteratorFunctionIterable<String>(
      _schema.isAllBooleans
          ? () => _AllBoolsTypedMapKeyIterator(this)
          : () => _PartialTypedMapKeyIterator(this),
      length: length);

  @override
  late final Iterable<Object?> values = _IteratorFunctionIterable<Object?>(
      _schema.isAllBooleans
          ? () => _AllBoolsTypedMapValueIterator(this)
          : () => _PartialTypedMapValueIterator(this),
      length: length);

  @override
  late Iterable<MapEntry<String, Object?>> entries =
      _IteratorFunctionIterable<MapEntry<String, Object?>>(
          _schema.isAllBooleans
              ? () => _AllBoolsTypedMapEntryIterator(this)
              : () => _PartialTypedMapEntryIterator(this),
          length: length);

  @override
  void operator []=(String key, Object? value) {
    throw UnsupportedError('JsonBuffer is readonly.');
  }

  @override
  Object? remove(Object? key) {
    throw UnsupportedError('JsonBuffer is readonly.');
  }

  @override
  void clear() {
    throw UnsupportedError('JsonBuffer is readonly.');
  }
}

/// `Iterator` that reads a `Map` in a [JsonBufferBuilder].
abstract class _PartialTypedMapIterator<T> implements Iterator<T> {
  final _TypedMap _map;
  final JsonBufferBuilder _buffer;
  final TypedMapSchema _schema;
  final Pointer _valuesPointer;
  int _offset = -1;
  int _index = -1;

  _PartialTypedMapIterator(this._map)
      : _buffer = _map._buffer,
        _schema = _map._schema,
        _valuesPointer = _map._pointer +
            _pointerSize +
            (_map.filled ? 0 : _map._schema.fieldSetSize);

  @override
  T get current;

  String get _currentKey => _schema._keys[_index];
  Object? get _currentValue =>
      _buffer._read(_schema._valueTypes[_index], _valuesPointer + _offset);

  @override
  bool moveNext() {
    _offset += _index == -1 ? 1 : _schema._valueTypes[_index].sizeInBytes;
    do {
      ++_index;
      if (_index == _schema.length) return false;
    } while (!_map.hasField(_index));
    return true;
  }
}

class _PartialTypedMapKeyIterator extends _PartialTypedMapIterator<String> {
  _PartialTypedMapKeyIterator(super._map);

  @override
  String get current => _currentKey;
}

class _PartialTypedMapValueIterator extends _PartialTypedMapIterator<Object?> {
  _PartialTypedMapValueIterator(super._map);

  @override
  Object? get current => _currentValue;
}

class _PartialTypedMapEntryIterator
    extends _PartialTypedMapIterator<MapEntry<String, Object?>> {
  _PartialTypedMapEntryIterator(super._map);

  @override
  MapEntry<String, Object?> get current => MapEntry(_currentKey, _currentValue);
}

/// `Iterator` that reads a `Map` in a [JsonBufferBuilder].
abstract class _AllBoolsTypedMapIterator<T> implements Iterator<T> {
  final _TypedMap _map;
  final JsonBufferBuilder _buffer;
  final TypedMapSchema _schema;
  final Pointer _valuesPointer;
  int _index = -1;
  int _intOffset = -1;
  int _bitOffset = 7;

  _AllBoolsTypedMapIterator(this._map)
      : _buffer = _map._buffer,
        _schema = _map._schema,
        _valuesPointer = _map._pointer +
            _pointerSize +
            (_map.filled ? 0 : _map._schema.fieldSetSize);

  @override
  T get current;

  String get _currentKey => _schema._keys[_index];
  Object? get _currentValue =>
      _buffer.readBit(_valuesPointer + _intOffset, _bitOffset);

  @override
  bool moveNext() {
    ++_bitOffset;
    if (_bitOffset == 8) {
      _bitOffset = 0;
      ++_intOffset;
    }
    do {
      ++_index;
      if (_index == _map._schema.length) return false;
    } while (!_map.hasField(_index));
    return true;
  }
}

class _AllBoolsTypedMapKeyIterator extends _AllBoolsTypedMapIterator<String> {
  _AllBoolsTypedMapKeyIterator(super._map);

  @override
  String get current => _currentKey;
}

class _AllBoolsTypedMapValueIterator
    extends _AllBoolsTypedMapIterator<Object?> {
  _AllBoolsTypedMapValueIterator(super._map);

  @override
  Object? get current => _currentValue;
}

class _AllBoolsTypedMapEntryIterator
    extends _AllBoolsTypedMapIterator<MapEntry<String, Object?>> {
  _AllBoolsTypedMapEntryIterator(super._map);

  @override
  MapEntry<String, Object?> get current => MapEntry(_currentKey, _currentValue);
}
