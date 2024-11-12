// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/src/json_buffer/json_buffer_builder.dart';
import 'package:test/test.dart';

void main() {
  group('ClosedList', () {
    late JsonBufferBuilder builder;

    setUp(() {
      builder = JsonBufferBuilder();
    });

    tearDown(() {
      printOnFailure('Try: dart -Ddebug_json_buffer=true test -c source');
      printOnFailure(builder.toString());
    });

    test('simple write and read', () {
      final value = ['a', 1, 'b', 2];
      builder.map['value'] = value;

      final deserializedValue = builder.map['value'] as List<Object?>;
      expect(deserializedValue.runtimeType.toString(), '_ClosedList');
      expect(deserializedValue, value);
    });

    test('write and read with nested maps and lists', () {
      final value = [
        'a',
        null,
        'bb',
        <Object?>[],
        <String, Object?>{},
        [
          'ccc',
          {'a': 3},
        ],
      ];
      builder.map['value'] = value;
      final deserializedValue = builder.map['value'] as List<Object?>;
      expect(deserializedValue.runtimeType.toString(), '_ClosedList');
      expect(deserializedValue, value);
    });
  });
}
