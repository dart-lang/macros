// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import 'dart_model.dart';

/// An implementation of a lazy merged json [Map] view over two [Map]s.
///
/// The intended use case is for merging JSON payloads together into a single
/// payload, where their structure is the same.
///
/// If both maps have the same key present, the logic for the values of those
/// shared keys goes as follows:
///
///   - If both values are `Map<String, Object?>`, a nested [LazyMergedMapView]
///     is returned.
///   - Else if they are equal values, the value from [left] is returned.
///   - Else a [StateError] is thrown.
///
/// Nested [List]s are not specifically handled at this time and must be equal.
///
/// The [keys] getter will de-duplicate the keys.
class LazyMergedMapView extends MapBase<String, Object?> {
  final Map<String, Object?> left;
  final Map<String, Object?> right;

  LazyMergedMapView(this.left, this.right);

  @override
  Object? operator [](Object? key) {
    // TODO: Can we do better? These lookups can each be linear for buffer maps.
    var leftValue = left[key];
    var rightValue = right[key];
    if (leftValue != null) {
      if (rightValue != null) {
        if (leftValue is Map<String, Object?> &&
            rightValue is Map<String, Object?>) {
          return LazyMergedMapView(leftValue, rightValue);
        }
        if (leftValue is List<Object?> && rightValue is List<Object?>) {
          if (leftValue.length != rightValue.length) {
            throw StateError(
              'Cannot merge lists of different lengths, '
              'got $leftValue and $rightValue',
            );
          }
          // TODO: Something better for lists, it isn't clear how to merge them.
          return leftValue;
        } else if (leftValue != rightValue) {
          throw StateError(
            'Cannot merge maps with different values, and '
            '$leftValue != $rightValue',
          );
        }
        return leftValue;
      }
      return leftValue;
    } else if (rightValue != null) {
      return rightValue;
    }
    return null;
  }

  @override
  void operator []=(String key, Object? value) =>
      throw UnsupportedError('Merged maps are read only');

  @override
  bool operator ==(Object other) =>
      other is LazyMergedMapView && other.left == left && other.right == right;

  @override
  int get hashCode => Object.hash(left, right);

  @override
  void clear() => throw UnsupportedError('Merged maps are read only');

  @override
  Iterable<String> get keys sync* {
    var seen = <String>{};
    for (var key in left.keys.followedBy(right.keys)) {
      if (seen.add(key)) yield key;
    }
  }

  @override
  Object? remove(Object? key) =>
      throw UnsupportedError('Merged maps are read only');
}

extension AllMaps on Map<String, Object?> {
  /// All the maps merged into this map, recursively expanded.
  Iterable<Map<String, Object?>> get expand sync* {
    if (this case final LazyMergedMapView self) {
      yield* self.left.expand;
      yield* self.right.expand;
    } else {
      yield this;
    }
  }

  /// All the maps merged into this map, recursively expanded, including the
  /// merged map objects themselves.
  Iterable<Map<String, Object?>> get expandWithMerged sync* {
    if (this case final LazyMergedMapView self) {
      yield self;
      yield* self.left.expand;
      yield* self.right.expand;
    } else {
      yield this;
    }
  }
}

extension MergeModels on Model {
  /// Creates a lazy merged view of `this` with [other].
  Model mergeWith(Model other) =>
      Model.fromJson(LazyMergedMapView(node, other.node));
}
