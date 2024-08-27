// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/src/json_buffer/json_buffer_builder.dart';
import 'package:test/test.dart';

void main() {
  group(JsonBufferBuilder, () {
    late JsonBufferBuilder builder;

    setUp(() {
      builder = JsonBufferBuilder();
    });

    tearDown(() {
      printOnFailure('Try: dart -Ddebug_json_buffer=true test -c source');
      printOnFailure(builder.toString());
    });

    test('writes and reads supported types', () {
      final growableMap = builder.createGrowableMap<Object?>();
      growableMap['A'] = 'B';
      final value = {
        '1': null,
        '2': Type.stringPointer,
        '3': Type.uint32,
        '4': false,
        '5': true,
        '6': 0,
        '7': 0xffffffff,
        '8': 'a',
        '9': 'abc' * 10,
        '10': {
          'a': {'aa': 'bb'},
          'b': 2
        },
        '11': growableMap,
      };
      builder.map['value'] = value;
      growableMap['C'] = 'D';

      final deserializedValue = builder.map['value'];
      expect(deserializedValue, value);
    });

    test('is serializable and deserializable', () {
      final growableMap = builder.createGrowableMap<Object?>();
      growableMap['A'] = 'B';
      final value = {
        '1': null,
        '2': Type.stringPointer,
        '3': Type.uint32,
        '4': false,
        '5': true,
        '6': 0,
        '7': 0xffffffff,
        '8': 'a',
        '9': 'abc' * 10,
        '10': {
          'a': {'aa': 'bb'},
          'b': 2
        },
        '11': growableMap,
      };
      builder.map['value'] = value;
      growableMap['C'] = 'D';

      final serialized = builder.serialize();
      final deserializedBuilder = JsonBufferBuilder.deserialize(serialized);

      final deserializedValue = deserializedBuilder.map['value'];
      expect(deserializedValue, value);
    });

    test('deserialized does not allow modification', () {
      final deserializedBuilder =
          JsonBufferBuilder.deserialize(JsonBufferBuilder().serialize());
      expect(() => deserializedBuilder.map['a'] = 'b', throwsStateError);
    });
  });
}
