// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/src/json_buffer/json_buffer_builder.dart';
import 'package:test/test.dart';

import 'testing.dart';

void main() {
  group('TypedMap', () {
    late JsonBufferBuilder builder;

    setUp(() {
      builder = JsonBufferBuilder();
    });

    tearDown(() {
      printOnFailure('Try: dart -Ddebug_json_buffer=true test -c source');
      printOnFailure(builder.toString());
    });

    test('equality and hashing is by identity', () {
      final schema = TypedMapSchema({});
      final typedMap1 = builder.createTypedMap(schema);
      final typedMap2 = builder.createTypedMap(schema);

      // Different maps with the same contents are not equal, have different hash codes.
      // Can't use default `expect` equality check as it special-cases `Map`.
      expect(typedMap1 == typedMap2, false);
      expect(typedMap1.hashCode, isNot(typedMap2.hashCode));

      // Map is equal to a reference to itself, has same hash code.
      builder.map['a'] = typedMap1;
      final typedMap1Reference = builder.map['a'] as Map<String, Object?>;
      expect(typedMap1 == typedMap1Reference, true);
      expect(typedMap1.hashCode, typedMap1Reference.hashCode);
    });

    test('with some values missing can be written and read', () {
      final schema = TypedMapSchema({
        'a': Type.stringPointer,
        'b': Type.boolean,
        'missing1': Type.stringPointer,
        'c': Type.uint32,
        'missing2': Type.stringPointer
      });
      final map = builder.createTypedMap(schema, 'aa', true, null, 12345, null);
      expectFullyEquivalentMaps(map, {'a': 'aa', 'b': true, 'c': 12345});
    });

    test('with all bools some values missing can be written and read', () {
      final schema = TypedMapSchema({
        'a': Type.boolean,
        'b': Type.boolean,
        'missing1': Type.boolean,
        'c': Type.boolean,
        'missing2': Type.boolean,
      });
      final map = builder.createTypedMap(schema, true, false, null, true, null);
      expectFullyEquivalentMaps(map, {'a': true, 'b': false, 'c': true});
    });

    test('with all bools all present can be written and read', () {
      final schema = TypedMapSchema({
        'a': Type.boolean,
        'b': Type.boolean,
        'c': Type.boolean,
        'd': Type.boolean,
      });
      final map = builder.createTypedMap(schema, false, true, false, true);
      expectFullyEquivalentMaps(
          map, {'a': false, 'b': true, 'c': false, 'd': true});
    });

    test('schemas are written once per buffer', () {
      final schema =
          TypedMapSchema({'a': Type.stringPointer, 'b': Type.uint32});

      // Write three times, checking how much the buffer grows.
      final length1 = builder.length;
      builder.createTypedMap(schema, 'aa', 12345);
      final length2 = builder.length;
      builder.createTypedMap(schema, 'aa', 12345);
      final length3 = builder.length;
      builder.createTypedMap(schema, 'aa', 12345);
      final length4 = builder.length;

      // Second write takes up less space than first, because the schema is
      // not repeated.
      expect(length3 - length2, lessThan(length2 - length1));

      // Third write takes up as much space as second.
      expect(length4 - length3, length3 - length2);
    });

    test('bools are packed into bytes if types are mixed', () {
      final schema = TypedMapSchema({
        'a': Type.uint32,
        'b': Type.boolean,
        'c': Type.boolean,
        'd': Type.boolean,
        'e': Type.boolean,
      });

      // Write one to write schema, again to check size without schema.
      builder.createTypedMap(schema, 37, false, true, false, true);
      final length1 = builder.length;
      builder.createTypedMap(schema, 37, false, true, false, true);
      final length2 = builder.length;

      // Size should be schema pointer, one four byte int, four one byte bools.
      expect(length2 - length1, 4 + 4 + 4);
    });

    test('if all fields are bools they are packed into bits', () {
      final schema = TypedMapSchema({
        'a': Type.boolean,
        'b': Type.boolean,
        'c': Type.boolean,
        'd': Type.boolean,
        'e': Type.boolean,
        'f': Type.boolean,
        'g': Type.boolean,
        'h': Type.boolean,
      });

      // Write once so schema is written.
      builder.createTypedMap(
          schema, true, false, true, false, true, false, true, false);

      // Check length of write with already-written schema.
      final length1 = builder.length;
      builder.createTypedMap(
          schema, true, false, true, false, true, false, true, false);
      final length2 = builder.length;

      // Size should be schema pointer, one byte for eight bools.
      expect(length2 - length1, 4 + 1);
    });

    test('if all fields are bools or nulls they are packed into bits', () {
      final schema = TypedMapSchema({
        'a': Type.boolean,
        'b': Type.boolean,
        'c': Type.boolean,
        'd': Type.boolean,
        'e': Type.boolean,
        'f': Type.boolean,
        'g': Type.boolean,
        'h': Type.boolean,
      });

      // Write once so schema is written.
      builder.createTypedMap(
          schema, null, false, true, false, true, false, true, false);

      // Check length of write with already-written schema.
      final length1 = builder.length;
      builder.createTypedMap(
          schema, true, null, true, false, true, false, true, false);
      final length2 = builder.length;

      // Size should be schema pointer, one byte field set, one byte for seven
      // bools.
      expect(length2 - length1, 4 + 1 + 1);
    });

    test('if not filled skipped fields save space', () {
      final schema = TypedMapSchema({
        'a': Type.uint32,
        'b': Type.boolean,
        'c': Type.boolean,
        'd': Type.boolean,
        'e': Type.boolean,
      });

      // Write one to write schema, again to check size without schema.
      builder.createTypedMap(schema, 37, null, true, null, false);
      final length1 = builder.length;
      builder.createTypedMap(schema, 37, null, true, null, false);
      final length2 = builder.length;

      // Size should be schema pointer, one four byte int pointer, one byte
      // field set, two one byte bools.
      expect(length2 - length1, 4 + 4 + 1 + 2);
    });

    test('fields of anyPointer can hold any value', () {
      final schema = TypedMapSchema({
        'a': Type.anyPointer,
        'b': Type.anyPointer,
        'c': Type.anyPointer,
        'd': Type.anyPointer,
        'e': Type.anyPointer,
        'f': Type.anyPointer,
        'g': Type.anyPointer,
      });

      final typedMap =
          builder.createTypedMap(TypedMapSchema({'a': Type.boolean}), true);
      final growableMap = builder.createGrowableMap<int>();
      growableMap['foo'] = 3;

      final map = builder.createTypedMap(schema, null, 1, false, {'a': 'b'},
          ['a', 'b', 'c'], typedMap, growableMap);
      expectFullyEquivalentMaps(map, {
        'b': 1,
        'c': false,
        'd': {'a': 'b'},
        'e': ['a', 'b', 'c'],
        'f': typedMap,
        'g': growableMap
      });
    });

    test('value with sixteen booleans', () {
      final schema = TypedMapSchema({
        for (var i = 0; i != 16; ++i) 'k$i': Type.boolean,
      });

      final map = builder.createTypedMap(
        schema,
        true,
        false,
        true,
        false,
        true,
        false,
        true,
        false,
        true,
        false,
        true,
        false,
        true,
        false,
        true,
        false,
      );

      expectFullyEquivalentMaps(map, {
        for (var i = 0; i != 16; ++i) 'k$i': i.isEven,
      });

      final mapWithNulls = builder.createTypedMap(
        schema,
        true,
        false,
        null,
        true,
        false,
        null,
        true,
        false,
        null,
        true,
        false,
        null,
        true,
        false,
        null,
        true,
      );

      expectFullyEquivalentMaps(mapWithNulls, {
        for (var i = 0; i != 16; ++i)
          if (i % 3 != 2) 'k$i': i % 3 == 0,
      });
    });

    test('value with sixteen mixed fields', () {
      final schema = TypedMapSchema({
        for (var i = 0; i != 16; ++i) 'k$i': Type.stringPointer,
      });

      final map = builder.createTypedMap(
        schema,
        '0',
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '10',
        '11',
        '12',
        '13',
        '14',
        '15',
      );

      expectFullyEquivalentMaps(map, {
        for (var i = 0; i != 16; ++i) 'k$i': '$i',
      });

      final mapWithNulls = builder.createTypedMap(
        schema,
        null,
        '1',
        '2',
        '3',
        '4',
        null,
        '6',
        '7',
        '8',
        '9',
        null,
        '11',
        '12',
        '13',
        '14',
        null,
      );

      expectFullyEquivalentMaps(mapWithNulls, {
        for (var i = 0; i != 15; ++i)
          if (i % 5 != 0) 'k$i': '$i',
      });
    });
  });
}
