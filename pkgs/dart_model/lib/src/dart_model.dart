// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart_model.g.dart';
import 'json_buffer/json_buffer_builder.dart';

export 'dart_model.g.dart';

extension QualifiedNameExtension on QualifiedName {
  String get asString => '$uri#$name';

  bool equals(QualifiedName other) => other.uri == uri && other.name == name;
}

extension ModelExtension on Model {
  /// Returns the path in the model to [member], or `null` if [member] is not
  /// in this [Model].
  ///
  /// Comparison is by identity, not by value, so the exact instance must be in
  /// this [Model].
  ///
  /// TODO(davidmorgan): this works for any node, but it's not clear yet which
  /// types of node we want this functionality exposed for.
  /// TODO(davidmorgan): a list of path segments is probably more useful than
  /// `String`.
  QualifiedName? qualifiedNameOfMember(Member member) =>
      _qualifiedNameOf(member.node);

  /// Returns the [QualifiedName] in the model to [node], or `null` if [node] is not in this [Model].
  QualifiedName? _qualifiedNameOf(Map<String, Object?> node) {
    final members = _getParent(node);
    if (members == null) return null;
    final interface = _getParent(members);
    if (interface == null) return null;
    final scopes = _getParent(interface);
    if (scopes == null) return null;
    final library = _getParent(scopes);
    if (library == null) return null;
    final libraries = _getParent(library);
    if (libraries == null) return null;

    final uri = _keyOf(library, libraries);
    final name = _keyOf(interface, scopes);

    return QualifiedName(uri: uri, name: name);
  }

  /// Returns the key of [value] in [map].
  ///
  /// Throws if [value] is not in [map].
  String _keyOf(Object value, Map<String, Object?> map) {
    for (final entry in map.entries) {
      if (entry.value == value) return entry.key;
    }
    throw ArgumentError('Value not in map: $value, $map');
  }

  /// Gets the `Map` that contains [node], or `null` if there isn't one.
  Map<String, Object?>? _getParent(Map<String, Object?> node) {
    // If both maps are in the same `JsonBufferBuilder` then the parent is
    // immediately available.
    if (this case MapInBuffer thisMapInBuffer) {
      if (node case MapInBuffer thatMapInBuffer) {
        if (thisMapInBuffer.buffer == thatMapInBuffer.buffer) {
          return thatMapInBuffer.parent;
        }
      }
    }
    // Otherwise, build a `Map` of references to parents and use that.
    return _lazyParentsMap[node];
  }

  /// Gets a `Map` from values to parent `Map`s.
  Map<Map<String, Object?>, Map<String, Object?>> get _lazyParentsMap {
    var result = _parentsMaps[this];
    if (result == null) {
      result =
          _parentsMaps[this] = <Map<String, Object?>, Map<String, Object?>>{};
      _buildParentsMap(node, result);
    }
    return result;
  }

  /// Builds a `Map` from values to parent `Map`s.
  static void _buildParentsMap(Map<String, Object?> parent,
      Map<Map<String, Object?>, Map<String, Object?>> result) {
    for (final child in parent.values.whereType<Map<String, Object?>>()) {
      if (result.containsKey(child)) {
        throw StateError(
            'Same node found twice.\n\nChild:\n$child\n\nParent:\n$parent');
      } else {
        result[child] = parent;
        _buildParentsMap(child, result);
      }
    }
  }
}

extension QueryExtension on Query {
  /// Recursively replaces [BatchQuery] queries with their inner queries.
  Iterable<Query> expandBatches() sync* {
    if (type == QueryType.batchQuery) {
      for (final entry in asBatchQuery.queries) {
        yield* entry.expandBatches();
      }
    } else {
      yield this;
    }
  }
}

/// Expando storing a `Map` from values to parent `Map`s.
final _parentsMaps = Expando<Map<Map<String, Object?>, Map<String, Object?>>>();
