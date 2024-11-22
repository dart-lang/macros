// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:crypto/crypto.dart';
import 'package:dart_model/src/json_buffer/json_buffer_builder.dart';
import 'package:test/test.dart';

void main() {
  group('JsonBufferBuilder', () {
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
          'b': 2,
          'c': ['a', 'b'],
        },
        '11': growableMap,
        '12': [
          '1',
          null,
          Type.stringPointer,
          false,
          0,
          {'a': 'aa'},
        ],
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
          'b': 2,
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
      final deserializedBuilder = JsonBufferBuilder.deserialize(
        JsonBufferBuilder().serialize(),
      );
      expect(() => deserializedBuilder.map['a'] = 'b', throwsStateError);
    });

    group('digest', () {
      /// Re-usable digest tests, [a] and [b] should be different values,
      /// possibly of different types.
      void testDigest(Object? a, Object? b) {
        assert(a != b);
        expect(digest({'a': a}), equals(digest({'a': a})));
        expect(
          digest({
            'a': {'b': b},
          }),
          equals(
            digest({
              'a': {'b': b},
            }),
          ),
        );
        expect(digest({'a': a}), isNot(equals(digest({'a': b}))));
        expect(digest({'a': a}), isNot(equals(digest({'b': a}))));
        expect(
          digest({'a': a, 'b': b}),
          isNot(equals(digest({'a': b, 'b': a}))),
        );
      }

      test('boolean fields', () {
        testDigest(true, false);
      });

      test('String fields', () {
        testDigest('a', 'b');
      });

      test('int fields', () {
        testDigest(1, 2);
      });

      test('null fields', () {
        testDigest(null, 0);
        testDigest(null, true);
        testDigest(null, false);
        testDigest(null, <String, Object?>{});
      });

      test('closed list fields', () {
        testDigest([], [1]);
        testDigest([1, 2], [2, 1]);
      });

      test('closed map fields', () {
        testDigest(<String, Object?>{}, {'a': 1});
        testDigest({'a': 'b'}, {'b': 'a'});
      });

      test('growable map fields', () {
        final builderA = JsonBufferBuilder();
        final builderB = JsonBufferBuilder();
        testDigest(
          builderA.createGrowableMap<Object?>()..['a'] = 1,
          builderB.createGrowableMap<Object?>()..['a'] = 2,
        );
      });

      test('typed maps with same schema', () {
        final builderA = JsonBufferBuilder();
        final builderB = JsonBufferBuilder();
        final schema = TypedMapSchema({'a': Type.stringPointer});
        testDigest(
          builderA.createTypedMap(schema, 'a'),
          builderB.createTypedMap(schema, 'b'),
        );
      });
    });
  });
}

Digest digest(Map<String, Object?> map) {
  final builder =
      map is MapInBuffer ? (map as MapInBuffer).buffer : JsonBufferBuilder()
        ..map.deepCopy(map);
  return builder.digest(
    (builder.map as MapInBuffer).pointer,
    type: Type.growableMapPointer,
    alreadyDereferenced: true,
  );
}

extension on Map<String, Object?> {
  void deepCopy(Map from) {
    for (var entry in from.entries) {
      this[entry.key as String] = entry.value;
    }
  }
}
