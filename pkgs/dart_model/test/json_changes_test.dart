// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';
import 'package:test/test.dart';

void main() {
  group(JsonChanges, () {
    test('describes new data as updates', () {
      final previous = JsonData.deepCopyAndCheck({'a': 'a', 'c': 'c'});
      final current = JsonData.deepCopyAndCheck({'a': 'a', 'b': 'b'});
      final changes = current.computeChangesFrom(previous);

      expect(changes.updates, {'b': 'b'});
    });

    test('describes deeply nested new data as updates', () {
      final previous = JsonData.deepCopyAndCheck({
        'a': {
          'b': {'c': 'd'}
        },
      });
      final current = JsonData.deepCopyAndCheck({
        'a': {
          'b': {
            'c': {
              'd': {'e': 'f'}
            }
          }
        },
      });
      final changes = current.computeChangesFrom(previous);

      expect(changes.updates, {
        'a': {
          'b': {
            'c': {
              'd': {'e': 'f'}
            }
          }
        }
      });
    });

    test('describes changed data as updates', () {
      final previous = JsonData.deepCopyAndCheck({'a': 'a', 'c': 'c'});
      final current = JsonData.deepCopyAndCheck({'a': 'a2', 'c': 'c'});
      final changes = current.computeChangesFrom(previous);

      expect(changes.updates, {'a': 'a2'});
    });

    test('describes deeply nested changed data as updates', () {
      final previous = JsonData.deepCopyAndCheck({
        'a': {
          'b': {'c': 'a'}
        },
        'c': 'c'
      });
      final current = JsonData.deepCopyAndCheck({
        'a': {
          'b': {'c': 'a2'}
        },
        'c': 'c'
      });
      final changes = current.computeChangesFrom(previous);

      expect(changes.updates, {
        'a': {
          'b': {'c': 'a2'}
        }
      });
    });

    test('describes removed data', () {
      final previous = JsonData.deepCopyAndCheck({'a': 'a', 'c': 'c'});
      final current = JsonData.deepCopyAndCheck({'a': 'a'});
      final changes = current.computeChangesFrom(previous);

      expect(changes.removals, {'c': null});
    });

    test('describes deeply nested removed data', () {
      final previous = JsonData.deepCopyAndCheck({
        'a': 'a',
        'c': {
          'd': {
            'e': {'c': 'c'}
          }
        }
      });
      final current = JsonData.deepCopyAndCheck({
        'a': 'a',
        'c': {
          'd': {'e': <String, Object?>{}}
        }
      });
      final changes = current.computeChangesFrom(previous);

      expect(changes.removals, {
        'c': {
          'd': {
            'e': {'c': null}
          }
        }
      });
    });

    test('can handle lists', () {
      final previous = JsonData.deepCopyAndCheck({
        'a': ['a'],
      });
      final current = JsonData.deepCopyAndCheck({
        'a': ['b'],
      });
      final changes = current.computeChangesFrom(previous);

      expect(changes.updates, {
        'a': ['b']
      });
    });

    test('can be applied on top of a JsonData instance', () {
      final previous = JsonData.deepCopyAndCheck({
        'a': 'a',
        'b': 'b',
        'c': 'c',
      });
      final current = JsonData.deepCopyAndCheck({
        'a': {'b': 'c'},
        'b': {'c': 'a'},
      });
      final changes = current.computeChangesFrom(previous);

      expect(previous.asMap, isNot(current.asMap));
      final alsoCurrent = previous.change(changes);
      expect(alsoCurrent.asMap, current.asMap);
    });

    test('does not mutate the JsonData applied to ', () {
      final previous = JsonData.deepCopyAndCheck({
        'a': 'a',
        'b': 'b',
        'c': 'c',
      });
      final current = JsonData.deepCopyAndCheck({
        'a': {'b': 'c'},
        'b': {'c': 'a'},
      });
      final changes = current.computeChangesFrom(previous);
      previous.change(changes);
      expect(previous.asMap, {
        'a': 'a',
        'b': 'b',
        'c': 'c',
      });
    });
  });
}
