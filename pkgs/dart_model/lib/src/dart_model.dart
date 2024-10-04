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
  /// Returns the path in the model to [member], or `null` if [member] is not in this `Model`.
  ///
  /// TODO(davidmorgan): this works for any node, but it's not clear yet which types of
  /// node we want this functionality exposed for.
  /// TODO(davidmorgan): a list of path segments is probably more useful than `String`.
  String? pathToMember(Member member) => _pathTo(member.node);

  /// Returns the path in the model to [node], or `null` if [node] is not in this `Model`.
  String? _pathTo(Map<String, Object?> node) {
    if (node == this.node) return '';
    final parent = _getParent(node);
    if (parent == null) return null;
    for (final entry in parent.entries) {
      if (entry.value == node) {
        final parentPath = _pathTo(parent);
        return parentPath == null ? null : '${_pathTo(parent)}/${entry.key}';
      }
    }
    return null;
  }

  /// Gets the `Map` that contains [node], or `null` if there isn't one.
  Map<String, Object?>? _getParent(Map<String, Object?> node) {
    // If both maps are in the same `JsonBufferBuilder` then the parent is
    // immediately available.
    if (this is MapInBuffer && node is MapInBuffer) {
      final thisMapInBuffer = this as MapInBuffer;
      final thatMapInBuffer = node as MapInBuffer;
      if (thisMapInBuffer.buffer == thatMapInBuffer.buffer) {
        return thatMapInBuffer.parent;
      }
    }
    // Otherwise, build a `Map` of references to parents and use that.
    return _parentsMap[node];
  }

  /// Gets a `Map` from values to parent `Map`s.
  Map<Map<String, Object?>, Map<String, Object?>> get _parentsMap {
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
      result[child] = parent;
      _buildParentsMap(child, result);
    }
  }
}

/// Expando storing a `Map` from values to parent `Map`s.
final Expando<Map<Map<String, Object?>, Map<String, Object?>>> _parentsMaps =
    Expando();
