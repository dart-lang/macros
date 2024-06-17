// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import 'package:collection/collection.dart';

import 'json_changes.dart';

/// Immutable, serializable JSON data.
///
/// Views onto the data are provided as [Map] instances, see [asMap].
final class JsonData {
  Map<String, Object?> _root = {};

  /// Instantiates with a deep copy of [json].
  ///
  /// Throws if any values not allowed in JSON data are present.
  ///
  /// TODO(davidmorgan): add a way to build without copying.
  JsonData.deepCopyAndCheck(Map<String, Object?> json) {
    _deepCopyAndCheckMap(json, _root);
  }

  /// A `Map` view onto the root of this JSON data.
  Map<String, Object?> get asMap => JsonMap._(_root);

  static void _deepCopyAndCheckMap(
      Map<String, Object?> from, Map<String, Object?> to) {
    from.forEach((key, value) {
      to[key] = _deepCopyAndCheckValue(value);
    });
  }

  static void _deepCopyAndCheckList(List<Object?> from, List<Object?> to) {
    for (final value in from) {
      to.add(_deepCopyAndCheckValue(value));
    }
  }

  static Object? _deepCopyAndCheckValue(Object? value) {
    if (value is Map<String, Object?>) {
      final copy = <String, Object?>{};
      _deepCopyAndCheckMap(value, copy);
      return copy;
    } else if (value is String ||
        value is bool ||
        value is num ||
        value == null) {
      return value;
    } else if (value is List<Object?>) {
      final copy = <Object?>[];
      _deepCopyAndCheckList(value, copy);
      return copy;
    } else {
      throw UnsupportedError(
          'JsonData cannot hold value of type ${value.runtimeType}: $value');
    }
  }

  /// Computes [JsonChanges] that is this data minus [previous].
  ///
  /// The result of `previous.change(changes)` is equal to `this`.
  JsonChanges computeChangesFrom(JsonData previous) {
    Map<String, Object?>? updates;
    Map<String, Object?>? removals;
    _computeChanges(
        previous: previous.asMap,
        current: this.asMap,
        updatesFactory: () => updates ??= {},
        removalsFactory: () => removals ??= {});
    return JsonChanges.fromJson(JsonData.deepCopyAndCheck({
      if (updates != null) 'updates': updates,
      if (removals != null) 'removals': removals,
    }).asMap);
  }

  /// Outputs changes between [previous] and [current] into `updates` and
  /// `removals` maps.
  ///
  /// Because there might be no updates, or no removals, the updates and
  /// removals maps are passed in as functions that create the maps,
  /// [updatesFactory] and [removalsFactory].
  static void _computeChanges(
      {required Map<String, Object?> previous,
      required Map<String, Object?> current,
      required Map<String, Object?> Function() updatesFactory,
      required Map<String, Object?> Function() removalsFactory}) {
    for (final key in previous.keys.followedBy(current.keys).toSet()) {
      final keyIsInPrevious = previous.containsKey(key);
      final keyIsInCurrent = current.containsKey(key);

      if (keyIsInPrevious && !keyIsInCurrent) {
        // It's a removal.
        removalsFactory()[key] = null;
      } else if (keyIsInPrevious && keyIsInCurrent) {
        // It's either the same or a change.
        final previousValue = previous[key]!;
        final currentValue = current[key]!;

        if (currentValue is Map<String, Object?>) {
          if (previousValue is Map<String, Object?>) {
            _computeChanges(
                previous: previousValue,
                current: currentValue,
                updatesFactory: () => (updatesFactory()[key] ??=
                    <String, Object?>{}) as Map<String, Object?>,
                removalsFactory: () => (removalsFactory()[key] ??=
                    <String, Object?>{}) as Map<String, Object?>);
          } else {
            updatesFactory()[key] = currentValue;
          }
        } else if (currentValue is String) {
          if (previousValue is! String || previousValue != currentValue) {
            updatesFactory()[key] = currentValue;
          }
        } else if (currentValue is List) {
          if (previousValue is! List ||
              !const DeepCollectionEquality()
                  .equals(previousValue, currentValue)) {
            updatesFactory()[key] = currentValue;
          }
        } else {
          // TODO(davidmorgan): support all JSON primitive types.
          throw UnsupportedError(
              'Unsupported change: $previousValue to $currentValue');
        }
      } else if (!keyIsInPrevious && keyIsInCurrent) {
        // It's new.
        updatesFactory()[key] = current[key];
      }
    }
  }

  /// Returns a new [JsonData] instance with [changes] made.
  JsonData change(JsonChanges changes) {
    // TODO(davidmorgan): implement a faster way.
    final result = JsonData.deepCopyAndCheck(_root);
    if (changes.updates != null) {
      _applyUpdates(root: result._root, updates: changes.updates!);
    }
    if (changes.removals != null) {
      _applyRemovals(root: result._root, removals: changes.removals!);
    }
    return result;
  }

  /// Applies [updates] to [root] in place.
  ///
  /// Take care not to call this on public data.
  static void _applyUpdates(
      {required Map<String, Object?> root,
      required Map<String, Object?> updates}) {
    updates.forEach((key, value) {
      if (value is Map<String, Object?>) {
        if (root[key] is! Map<String, Object?>) {
          root[key] = <String, Object?>{};
        }
        _applyUpdates(
            root: (root[key] ??= <String, Object?>{}) as Map<String, Object?>,
            updates: value);
      } else {
        root[key] = value;
      }
    });
  }

  /// Applies [removals] to [root] in place.
  ///
  /// Take care not to call this on public data.
  static void _applyRemovals(
      {required Map<String, Object?> root,
      required Map<String, Object?> removals}) {
    removals.forEach((key, value) {
      if (value is Map<String, Object?>) {
        _applyRemovals(
            root: root[key]! as Map<String, Object?>, removals: value);
      } else {
        root.remove(key);
      }
    });
  }
}

/// An immutable `Map` view onto part of [JsonData].
final class JsonMap
    with MapMixin<String, Object?>
    implements Map<String, Object?> {
  final Map<String, Object?> _map;

  JsonMap._(this._map);

  @override
  Iterable<String> get keys => _map.keys;

  @override
  Object? operator [](Object? key) => _map[key];

  @override
  void operator []=(String key, Object? value) =>
      throw UnsupportedError('JsonData is immutable.');

  @override
  void clear() => throw UnsupportedError('JsonData is immutable.');

  @override
  Object? remove(Object? key) =>
      throw UnsupportedError('JsonData is immutable.');
}
