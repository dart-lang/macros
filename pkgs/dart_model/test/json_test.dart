// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';
import 'package:test/test.dart';

void main() {
  group(JsonData, () {
    test('is immutable', () {
      final map = JsonData.deepCopyAndCheck({}).asMap;
      expect(() => map['a'] = 'b', throwsUnsupportedError);
      expect(() => map.clear(), throwsUnsupportedError);
      expect(() => map.remove('a'), throwsUnsupportedError);
    });

    test('deep copies maps', () {
      final map = {
        'a': {'b': 'c'}
      };
      final copy = JsonData.deepCopyAndCheck(map);

      // Delete a nested node from the original.
      (map['a']! as Map<String, Object?>).remove('b');

      // Check the copy is intact.
      expect(copy.asMap, {
        'a': {'b': 'c'}
      });
    });

    test('deep copies lists', () {
      final map = {
        'a': ['b', 'c']
      };
      final copy = JsonData.deepCopyAndCheck(map);

      // Clear a list in the original.
      (map['a']! as List<Object?>).clear();

      // Check the copy is intact.
      expect(copy.asMap, {
        'a': ['b', 'c']
      });
    });
  });
}
