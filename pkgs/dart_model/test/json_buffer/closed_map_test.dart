// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/src/json_buffer/json_buffer_builder.dart';
import 'package:test/test.dart';

import 'testing.dart';

void main() {
  group('ClosedMap', () {
    late JsonBufferBuilder builder;

    setUp(() {
      builder = JsonBufferBuilder();
    });

    tearDown(() {
      printOnFailure('Try: dart -Ddebug_json_buffer=true test -c source');
      printOnFailure(builder.toString());
    });

    test('equality and hashing is by identity', () {
      builder.map['a'] = <String, Object?>{};
      final closedMap1 = builder.map['a'] as Map<String, Object?>;
      builder.map['b'] = <String, Object?>{};
      final closedMap2 = builder.map['b'] as Map<String, Object?>;

      // Different maps with the same contents are not equal, have different hash codes.
      // Can't use default `expect` equality check as it special-cases `Map`.
      expect(closedMap1 == closedMap2, false);
      expect(closedMap1.hashCode, isNot(closedMap2.hashCode));

      // Map is equal to a reference to itself, has same hash code.
      builder.map['a'] = closedMap1;
      final closedMap1Reference = builder.map['a'] as Map<String, Object?>;
      expect(closedMap1 == closedMap1Reference, true);
      expect(closedMap1.hashCode, closedMap1Reference.hashCode);
    });

    test('simple write and read', () {
      final value = {'a': 1, 'b': 2};
      builder.map['value'] = value;

      final deserializedValue = builder.map['value'] as Map<String, Object?>;
      expect(deserializedValue.runtimeType.toString(), '_ClosedMap');
      expectFullyEquivalentMaps(deserializedValue, value);
    });

    test('write and read with nested lists and maps', () {
      final value = {
        'a': null,
        'a0': <Object?>[],
        'a00': <String, Object?>{},
        'bb': {
          'ccc': {'a': 3},
        },
        'cc': [
          {'a': 'b'},
          ['a', 'b'],
        ],
      };
      builder.map['value'] = value;
      final deserializedValue = builder.map['value'] as Map<String, Object?>;
      expect(deserializedValue.runtimeType.toString(), '_ClosedMap');
      expectFullyEquivalentMaps(deserializedValue, value);
    });

    test('typed maps created in the same buffer are stored as typed maps', () {
      final typedMap = builder.createTypedMap(TypedMapSchema({}));
      final value = {'a': typedMap};
      builder.map['value'] = value;
      final deserializedValue = builder.map['value'] as Map<String, Object?>;
      expect(deserializedValue['a'].runtimeType.toString(), '_TypedMap');
    });

    test(
      'typed maps created in a different buffer are copied to closed maps',
      () {
        final typedMap = JsonBufferBuilder().createTypedMap(TypedMapSchema({}));
        final value = {'a': typedMap};
        builder.map['value'] = value;
        final deserializedValue = builder.map['value'] as Map<String, Object?>;
        expect(deserializedValue['a'].runtimeType.toString(), '_ClosedMap');
      },
    );

    test('growable maps created in the same buffer are stored as growable '
        'maps', () {
      final growableMap = builder.createGrowableMap<int>();
      final value = {'a': growableMap};
      builder.map['value'] = value;
      final deserializedValue = builder.map['value'] as Map<String, Object?>;
      expect(
        deserializedValue['a'].runtimeType.toString(),
        '_GrowableMap<Object?>',
      );
    });

    test('growable maps created in a different buffer are copied', () {
      final growableMap = JsonBufferBuilder().createGrowableMap<int>();
      final value = {'a': growableMap};
      builder.map['value'] = value;
      final deserializedValue = builder.map['value'] as Map<String, Object?>;
      expect(deserializedValue['a'].runtimeType.toString(), '_ClosedMap');
    });
  });
}
