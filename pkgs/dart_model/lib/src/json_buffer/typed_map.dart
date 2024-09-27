// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'json_buffer_builder.dart';

/// Schema of a "typed map": a map with known keys and their value types.
class TypedMapSchema {
  /// The `String` keys of a "typed map" using this schema.
  final List<String> _keys;

  /// The value types of the fields in a "typed map" using this schema.
  final List<Type> _valueTypes;

  /// Whether all the fields are of type [Type.boolean].
  final bool _isAllBooleans;

  /// The number of bytes needed for a bit vector of which fields are present.
  final int _fieldSetSize;

  /// The byte size of all values if bools are not packed to bit vectors.
  final int _valueSizeAsBytes;

  /// Schema with the specified [fieldTypes].
  ///
  /// Ordering is important: when a "typed map" is instantiated the values are
  /// passed in the same order that the fields are specified here.
  TypedMapSchema(Map<String, Type> fieldTypes)
      : this._(fieldTypes.keys.toList(), fieldTypes.values.toList());

  TypedMapSchema._(this._keys, this._valueTypes)
      : _isAllBooleans = _valueTypes.every((t) => t == Type.boolean),
        _fieldSetSize = (_keys.length + 7) ~/ 8,
        _valueSizeAsBytes =
            _valueTypes.map((t) => t._sizeInBytes).fold(0, (a, b) => a + b);

  /// The schema field names and value types as a `Map`.
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

  /// The number of fields.
  int get length => _keys.length;

  /// The type of the field at index [i].
  Type _typeAtIndex(int i) => _isAllBooleans ? Type.boolean : _valueTypes[i];

  /// The number of bytes needed to store all the values.
  ///
  /// If [_isAllBooleans] then this is the number of bytes needed for a bit
  /// vector, otherwise it is the sum of [Type#_sizeInBytes] for all values.
  int get _filledValueSize =>
      _isAllBooleans ? _fieldSetSize : _valueSizeAsBytes;

  /// The number of bytes needed to store the specified values.
  ///
  /// If [_isAllBooleans] then this is the number of bytes needed for a bit
  /// vector of the present values, otherwise it is the sum of
  /// [Type#_sizeInBytes] for all present values.
  ///
  /// Additionally returns a [bool]: whether the map is filled.
  (int, bool) _valueSizeOf(
      [Object? v0,
      Object? v1,
      Object? v2,
      Object? v3,
      Object? v4,
      Object? v5,
      Object? v6,
      Object? v7]) {
    if (_isAllBooleans) {
      // All fields take up one bit, count then compute how many bytes.
      var bits = 0;
      if (v0 != null) ++bits;
      if (v1 != null) ++bits;
      if (v2 != null) ++bits;
      if (v3 != null) ++bits;
      if (v4 != null) ++bits;
      if (v5 != null) ++bits;
      if (v6 != null) ++bits;
      if (v7 != null) ++bits;
      return ((bits + 7) ~/ 8, bits == length);
    } else {
      // Sum the sizes of present values.
      var result = 0;
      if (v0 != null) result += _valueTypes[0]._sizeInBytes;
      if (v1 != null) result += _valueTypes[1]._sizeInBytes;
      if (v2 != null) result += _valueTypes[2]._sizeInBytes;
      if (v3 != null) result += _valueTypes[3]._sizeInBytes;
      if (v4 != null) result += _valueTypes[4]._sizeInBytes;
      if (v5 != null) result += _valueTypes[5]._sizeInBytes;
      if (v6 != null) result += _valueTypes[6]._sizeInBytes;
      if (v7 != null) result += _valueTypes[7]._sizeInBytes;
      return (result, result == _filledValueSize);
    }
  }

  @override
  String toString() => 'TypedMapSchema${toMap()}';
}

/// Methods for writing and reading "typed maps".
///
/// A "typed map" is a `Map<String, Object?>` in a byte buffer that has a know
/// [TypedMapSchema] specify its keys and value types. In addition, all keys
/// and values are known at the time of writing.
///
/// Values are optional; that is, they can be `null`.
extension TypedMaps on JsonBufferBuilder {
  /// Creates and fills a "typed map" with keys and value types specified in
  /// [schema].
  ///
  /// It is linked to the `JsonBufferBuilder` that creates it: it can be added
  /// to any collection in the same `JsonBufferBuilder` without copying.
  /// Adding to a collection in a different `JsonBufferBuilder` is an error.
  ///
  /// The returned value must be separately added to the buffer. Otherwise,
  /// the buffer contains data that is not reachable from the root [map].
  ///
  /// TODO(davidmorgan): benchmarking suggested that specialized
  /// implementations of this method per schema size (createTypedMap1,
  /// createdTypedMap2, etc) are not faster in the JIT VM but they are about
  /// 5-10% faster in the AOT VM, consider adding specialized methods. This
  /// will presumably matter more when if larger schemas are supported.
  Map<String, Object?> createTypedMap(TypedMapSchema schema,
      [Object? v0,
      Object? v1,
      Object? v2,
      Object? v3,
      Object? v4,
      Object? v5,
      Object? v6,
      Object? v7]) {
    _explanations?.push('addTypedMap $schema');

    // Compute how much space the values need, and whether the map is filled.
    // If the map is filled this is marked with the high bit of the schema
    // pointer, then the field set is omitted.
    final (valuesSize, filled) =
        schema._valueSizeOf(v0, v1, v2, v3, v4, v5, v6, v7);

    // Layout is: pointer to schema, field set (unless filled!), values.
    final pointer = _reserve(
        _pointerSize + (filled ? 0 : schema._fieldSetSize) + valuesSize);

    // Write the pointer to schema, setting the high bit if the map is filled.
    var schemaPointer =
        _pointersBySchema[schema] ??= _addClosedMap(schema.toMap());

    if (filled) schemaPointer |= 0x80000000;
    _writePointer(pointer, schemaPointer);

    // If not filled, write the field set: a bit vector indicating which fields
    // are present.
    if (!filled) {
      _setByte(
          pointer + _pointerSize,
          (v0 == null ? 0 : 0x01) +
              (v1 == null ? 0 : 0x02) +
              (v2 == null ? 0 : 0x04) +
              (v3 == null ? 0 : 0x08) +
              (v4 == null ? 0 : 0x10) +
              (v5 == null ? 0 : 0x20) +
              (v6 == null ? 0 : 0x40) +
              (v7 == null ? 0 : 0x80));
    }

    // Write the values.
    var valuePointer =
        pointer + _pointerSize + (filled ? 0 : schema._fieldSetSize);
    if (schema._isAllBooleans) {
      // If all booleans, pack into a byte bit vector.
      var byte = 0;
      var bitmask = 0x01;
      void addBit(bool bit) {
        if (bit) byte += bitmask;
        bitmask <<= 1;
      }

      if (v0 != null) addBit(v0 == true);
      if (v1 != null) addBit(v1 == true);
      if (v2 != null) addBit(v2 == true);
      if (v3 != null) addBit(v3 == true);
      if (v4 != null) addBit(v4 == true);
      if (v5 != null) addBit(v5 == true);
      if (v6 != null) addBit(v6 == true);
      if (v7 != null) addBit(v7 == true);

      // Only write the byte if at least one bit was written.
      if (bitmask != 0x01) {
        _setByte(valuePointer, byte);
      }
    } else {
      // If not all booleans, write only present values according to their
      // size in bytes.
      void addValue(int index, Object? value) {
        _explanations?.push('addValue $index $value');
        final valueType = schema._typeAtIndex(index);
        _writeAnyOfType(valueType, valuePointer, value);
        valuePointer += valueType._sizeInBytes;
        _explanations?.pop();
      }

      if (v0 != null) addValue(0, v0);
      if (v1 != null) addValue(1, v1);
      if (v2 != null) addValue(2, v2);
      if (v3 != null) addValue(3, v3);
      if (v4 != null) addValue(4, v4);
      if (v5 != null) addValue(5, v5);
      if (v6 != null) addValue(6, v6);
      if (v7 != null) addValue(7, v7);
    }

    _explanations?.pop();
    return _TypedMap(this, pointer);
  }

  /// Returns the [_Pointer] to [map].
  ///
  /// The [map] must have been created in this buffer using [createTypedMap].
  _Pointer _pointerToTypedMap(_TypedMap map) {
    _checkTypedMapOwnership(map);
    return map._pointer;
  }

  /// Throws if [map is backed by a different buffer to `this`.
  void _checkTypedMapOwnership(_TypedMap map) {
    if (map._buffer != this) {
      throw UnsupportedError('Maps created with `createTypedMap` can only '
          'be added to the JsonBufferBuilder instance that created them.');
    }
  }

  /// Returns the [_TypedMap] at [pointer].
  Map<String, Object?> _readTypedMap(_Pointer pointer) {
    return _TypedMap(this, pointer);
  }
}

class _TypedMap
    with MapMixin<String, Object?>, _EntryMapMixin
    implements Map<String, Object?> {
  final JsonBufferBuilder _buffer;
  final _Pointer _pointer;

  // If a `TypedMap` is created then immediately added to another `Map` then
  // these values are never needed, just the `_pointer`. Use `late` so they are
  // only computed if needed.

  late final _Pointer _schemaPointer =
      // The high byte of the schema pointer indicates "filled", omit it.
      _buffer._readPointer(_pointer) & 0x7fffffff;

  /// The schema of this "typed map" giving its field names and types.
  late final TypedMapSchema _schema =
      _buffer._schemasByPointer[_schemaPointer] ??=
          TypedMapSchema(_buffer._readClosedMap(_schemaPointer).cast());

  /// Whether all fields are present, meaning no explicit field set was written.
  late final bool filled = (_buffer._readPointer(_pointer) & 0x80000000) != 0;

  _TypedMap(this._buffer, this._pointer);

  /// Whether the field at [index] is present.
  bool _hasField(int index) {
    if (index < 0 || index >= _schema.length) {
      throw RangeError.value(
          index, 'index', 'Is out of range, length: ${_schema.length}.');
    }
    if (filled) return true;
    final byte = index ~/ 8;
    final bit = index % 8;
    return _buffer._readBit(_pointer + _pointerSize + byte, bit);
  }

  @override
  Object? operator [](Object? key) {
    final iterator = entries.iterator;
    while (iterator.moveNext()) {
      if (iterator.current.key == key) return iterator.current.value;
    }
    return null;
  }

  // For performance, `MapMixin` uses `keys.length`.
  @override
  late final int length = _computeLength();

  /// Computes length from present fields.
  int _computeLength() {
    if (filled) return _schema.length;
    var result = 0;
    for (var i = 0; i != _schema.length; ++i) {
      if (_hasField(i)) ++result;
    }
    return result;
  }

  @override
  late final Iterable<String> keys = _IteratorFunctionIterable<String>(
      _schema._isAllBooleans
          ? () => _AllBoolsTypedMapKeyIterator(this)
          : () => _PartialTypedMapKeyIterator(this),
      length: length);

  @override
  late final Iterable<Object?> values = _IteratorFunctionIterable<Object?>(
      _schema._isAllBooleans
          ? () => _AllBoolsTypedMapValueIterator(this)
          : () => _PartialTypedMapValueIterator(this),
      length: length);

  @override
  late Iterable<MapEntry<String, Object?>> entries =
      _IteratorFunctionIterable<MapEntry<String, Object?>>(
          _schema._isAllBooleans
              ? () => _AllBoolsTypedMapEntryIterator(this)
              : () => _PartialTypedMapEntryIterator(this),
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
}

/// `Iterator` that reads a "typed map" in a [JsonBufferBuilder].
abstract class _PartialTypedMapIterator<T> implements Iterator<T> {
  final _TypedMap _map;
  final JsonBufferBuilder _buffer;
  final TypedMapSchema _schema;
  final _Pointer _valuesPointer;

  /// The current field's index in the schema.
  int _index = -1;

  /// The current byte offset from [_valuesPointer.]
  int _offset = -1;

  _PartialTypedMapIterator(this._map)
      : _buffer = _map._buffer,
        _schema = _map._schema,
        _valuesPointer = _map._pointer +
            _pointerSize +
            (_map.filled ? 0 : _map._schema._fieldSetSize);

  @override
  T get current;

  String get _currentKey => _schema._keys[_index];
  Object? get _currentValue =>
      _buffer._read(_schema._valueTypes[_index], _valuesPointer + _offset);

  @override
  bool moveNext() {
    // Update the offset.
    //
    // If before the first byte, move to it.
    //
    // Otherwise, the iterator is at a present value: advance by its size in bytes.
    _offset += _index == -1 ? 1 : _schema._valueTypes[_index]._sizeInBytes;

    // Update the field index.
    do {
      ++_index;
      // If index is now outside the schema, iteration is finished.
      if (_index == _schema.length) return false;
      // Skip missing fields.
    } while (!_map._hasField(_index));
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

/// `Iterator` that reads a "typed map" in a [JsonBufferBuilder] with all
/// values of type [Type.boolean].
abstract class _AllBoolsTypedMapIterator<T> implements Iterator<T> {
  final _TypedMap _map;
  final JsonBufferBuilder _buffer;
  final TypedMapSchema _schema;
  final _Pointer _valuesPointer;

  /// The current field's index in the schema.
  int _index = -1;

  /// The byte offset from [_valuesPointer].
  int _intOffset = -1;

  /// The number of the current bit in the current byte.
  int _bitOffset = 7;

  _AllBoolsTypedMapIterator(this._map)
      : _buffer = _map._buffer,
        _schema = _map._schema,
        _valuesPointer = _map._pointer +
            _pointerSize +
            (_map.filled ? 0 : _map._schema._fieldSetSize);

  @override
  T get current;

  String get _currentKey => _schema._keys[_index];
  Object? get _currentValue =>
      _buffer._readBit(_valuesPointer + _intOffset, _bitOffset);

  @override
  bool moveNext() {
    // Update the offset: advance by one bit.
    ++_bitOffset;
    if (_bitOffset == 8) {
      _bitOffset = 0;
      ++_intOffset;
    }

    // Update the field index.
    do {
      ++_index;
      // If index is now outside the schema, iteration is finished.
      if (_index == _map._schema.length) return false;
      // Skip missing fields.
    } while (!_map._hasField(_index));
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
