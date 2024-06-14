// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';
import 'package:test/test.dart';

void main() {
  group(JsonChanges, () {
    test('describes new data as updates', () {
      final previous = Json.fromJson({'a': 'a', 'c': 'c'});
      final current = Json.fromJson({'a': 'a', 'b': 'b'});
      final changes = current.computeChangesFrom(previous);

      expect(changes.updates, [
        Update(path: Path(['b']), value: 'b')
      ]);
    });

    test('describes deeply nested new data as updates', () {
      final previous = Json.fromJson({
        'a': {
          'b': {'c': 'd'}
        },
      });
      final current = Json.fromJson({
        'a': {
          'b': {
            'c': {
              'd': {'e': 'f'}
            }
          }
        },
      });
      final changes = current.computeChangesFrom(previous);

      expect(changes.updates, [
        Update(path: Path(['a', 'b', 'c']), value: {
          'd': {'e': 'f'}
        })
      ]);
    });

    test('describes changed data as updates', () {
      final previous = Json.fromJson({'a': 'a', 'c': 'c'});
      final current = Json.fromJson({'a': 'a2', 'c': 'c'});
      final changes = current.computeChangesFrom(previous);

      expect(changes.updates, [
        Update(path: Path(['a']), value: 'a2')
      ]);
    });

    test('describes deeply nested changed data as updates', () {
      final previous = Json.fromJson({
        'a': {
          'b': {'c': 'a'}
        },
        'c': 'c'
      });
      final current = Json.fromJson({
        'a': {
          'b': {'c': 'a2'}
        },
        'c': 'c'
      });
      final changes = current.computeChangesFrom(previous);

      expect(changes.updates, [
        Update(path: Path(['a', 'b', 'c']), value: 'a2')
      ]);
    });

    test('describes removed data', () {
      final previous = Json.fromJson({'a': 'a', 'c': 'c'});
      final current = Json.fromJson({'a': 'a'});
      final changes = current.computeChangesFrom(previous);

      expect(changes.removals, [
        Removal(path: Path(['c']))
      ]);
    });

    test('describes deeply nested removed data', () {
      final previous = Json.fromJson({
        'a': 'a',
        'c': {
          'd': {
            'e': {'c': 'c'}
          }
        }
      });
      final current = Json.fromJson({
        'a': 'a',
        'c': {
          'd': {'e': <String, Object?>{}}
        }
      });
      final changes = current.computeChangesFrom(previous);

      expect(changes.removals, [
        Removal(path: Path(['c', 'd', 'e', 'c']))
      ]);
    });

    test('can handle lists', () {
      final previous = Json.fromJson({
        'a': ['a'],
      });
      final current = Json.fromJson({
        'a': ['b'],
      });
      final changes = current.computeChangesFrom(previous);

      expect(changes.updates, [
        Update(path: Path(['a']), value: ['b'])
      ]);
    });

    test('can be applied to a Json instance', () {
      final previous = Json.fromJson({
        'a': 'a',
        'b': 'b',
      });
      final current = Json.fromJson({
        'a': {'b': 'c'},
        'b': {'c': 'a'},
      });
      final changes = current.computeChangesFrom(previous);

      expect(previous, isNot(current));
      final alsoCurrent = previous.change(changes);
      expect(alsoCurrent, current);
    });
  });
}
