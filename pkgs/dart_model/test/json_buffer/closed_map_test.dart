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
          'ccc': {'a': 3}
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
  });
}
