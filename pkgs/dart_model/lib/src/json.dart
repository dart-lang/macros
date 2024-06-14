// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';

import 'json_changes.dart';

/// JSON data.
final class Json {
  Map<String, Object?> _root;

  Json.fromJson(Map<String, Object?> json) : _root = json;

  JsonChanges computeChangesFrom(Json previous) {
    final updates = <Update>[];
    final removals = <Removal>[];
    _compute(previous._root, _root, Path([]), updates, removals);
    return JsonChanges(updates: updates, removals: removals);
  }

  static void _compute(
      Map<String, Object?> previous,
      Map<String, Object?> current,
      Path path,
      List<Update> updates,
      List<Removal> removals) {
    for (final key in previous.keys.followedBy(current.keys).toSet()) {
      final keyIsInPrevious = previous.containsKey(key);
      final keyIsInCurrent = current.containsKey(key);

      if (keyIsInPrevious && !keyIsInCurrent) {
        removals.add(Removal(path: path.followedByOne(key)));
      } else if (keyIsInPrevious && keyIsInCurrent) {
        // It's either the same or a change.
        final previousValue = previous[key]!;
        final currentValue = current[key]!;

        if (currentValue is Map<String, Object?>) {
          if (previousValue is Map<String, Object?>) {
            _compute(previousValue, currentValue, path.followedByOne(key),
                updates, removals);
          } else {
            updates.add(
                Update(path: path.followedByOne(key), value: currentValue));
          }
        } else if (currentValue is String) {
          if (previousValue is! String || previousValue != currentValue) {
            updates.add(
                Update(path: path.followedByOne(key), value: currentValue));
          }
        } else if (currentValue is List) {
          if (previousValue is! List ||
              !const DeepCollectionEquality()
                  .equals(previousValue, currentValue)) {
            updates.add(
                Update(path: path.followedByOne(key), value: currentValue));
          }
        } else {
          throw UnsupportedError(
              'Unsupported change: $previousValue to $currentValue');
        }
      } else {
        // It's new.
        updates.add(Update(path: path.followedByOne(key), value: current[key]));
      }
    }
  }

  /// Returns a new [Json] instance with [changes] made.
  ///
  /// TODO(davidmorgan): actually return a new model, copying as needd.
  Json change(JsonChanges changes) {
    for (final update in changes.updates) {
      _updateAtPath(_root, update.path, update.value);
    }
    for (final removal in changes.removals) {
      _removeAtPath(_root, removal.path);
    }
    return this;
  }

  static void _updateAtPath(
      Map<String, Object?> node, Path path, Object? value) {
    if (path.path.length == 1) {
      node[path.path.single] = value;
    } else {
      if (!node.containsKey(path.path.first)) {
        node[path.path.first] = <String, Object?>{};
      }
      _updateAtPath(node[path.path.first]! as Map<String, Object?>,
          path.skipOne(), value);
    }
  }

  static void _removeAtPath(Map<String, Object?> node, Path path) {
    if (path.path.length == 1) {
      node.remove(path.path.single);
    } else {
      final first = path.path.first;
      final rest = path.skipOne();
      _removeAtPath(node[first]! as Map<String, Object?>, rest);
    }
  }

  @override
  bool operator ==(Object other) =>
      other is Json &&
      const DeepCollectionEquality().equals(_root, other._root);

  @override
  int get hashCode => const DeepCollectionEquality().hash(_root);
}
