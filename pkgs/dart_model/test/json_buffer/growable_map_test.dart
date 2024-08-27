// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/src/json_buffer/json_buffer_builder.dart';
import 'package:test/test.dart';

import 'testing.dart';

void main() {
  group('GrowableMap', () {
    late JsonBufferBuilder builder;

    setUp(() {
      builder = JsonBufferBuilder();
    });

    tearDown(() {
      printOnFailure('Try: dart -Ddebug_json_buffer=true test -c source');
      printOnFailure(builder.toString());
    });

    test('can be written and read if empty', () {
      final value = builder.createGrowableMap<int>();
      builder.map['value'] = value;

      final deserializedValue = builder.map['value'] as Map<String, Object?>;
      expect(deserializedValue.runtimeType.toString(), '_GrowableMap<Object?>');
      expectFullyEquivalentMaps(deserializedValue, value);
    });

    test('can be written and read with one value', () {
      final value = builder.createGrowableMap<int>();
      value['a'] = 1;
      builder.map['value'] = value;

      final deserializedValue = builder.map['value'] as Map<String, Object?>;
      expect(deserializedValue.runtimeType.toString(), '_GrowableMap<Object?>');
      expectFullyEquivalentMaps(deserializedValue, value);
    });

    test('can be written and read', () {
      final value = builder.createGrowableMap<int>();
      value['a'] = 1;
      value['b'] = 2;
      builder.map['value'] = value;

      final deserializedValue = builder.map['value'] as Map<String, Object?>;
      expect(deserializedValue.runtimeType.toString(), '_GrowableMap<Object?>');
      expectFullyEquivalentMaps(deserializedValue, value);
    });

    test('can be written and read with nested maps', () {
      final map1 = builder.createGrowableMap<Object?>();
      final map2 = builder.createGrowableMap<Object?>();
      map2['A'] = 1;
      map1['a'] = 1;
      map1['b'] = 2;
      map1['c'] = map2;
      // Add to map2 after it was added to map1, checks that what is added
      // is a reference not a copy.
      map2['B'] = 2;
      map2['C'] = {'x': 1, 'y': 2};

      builder.map['value'] = map1;

      final deserializedValue = builder.map['value'] as Map<String, Object?>;
      expect(deserializedValue.runtimeType.toString(), '_GrowableMap<Object?>');
      expectFullyEquivalentMaps(deserializedValue, {
        'a': 1,
        'b': 2,
        'c': {
          'A': 1,
          'B': 2,
          'C': {'x': 1, 'y': 2}
        }
      });
    });
  });
}
