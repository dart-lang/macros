// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart_model.g.dart';
import 'json_buffer/json_buffer_builder.dart';
import 'lazy_merged_map.dart';
import 'scopes.dart';

export 'dart_model.g.dart';

extension QualifiedNameExtension on QualifiedName {
  String get asString =>
      '$uri#${scope == null ? '' : '$scope${isStatic! ? '::' : '.'}'}$name';

  bool equals(QualifiedName other) =>
      other.uri == uri &&
      other.name == name &&
      other.scope == scope &&
      other.isStatic == isStatic;
}

extension ParentInterface on Member {
  QualifiedName get parentInterface {
    final self = MacroScope.current.model.qualifiedNameOf(node)!;
    return QualifiedName(uri: self.uri, name: self.scope);
  }
}

extension ModelExtension on Model {
  /// Looks up [name] in `this`.
  ///
  /// It is on the user to cast this to a proper extension type.
  ///
  /// Returns null if it is not present.
  // TODO: return a `Declaration` interface?
  Map<String, Object?>? lookup(QualifiedName name) {
    final library = uris[name.uri];
    if (library == null) return null;
    if (name.scope == null) {
      throw UnsupportedError(
          'Can only look up names in nested scopes for now.');
    }
    final scope = library.scopes[name.scope!];
    if (scope == null) return null;
    return scope.members[name.name]?.node;
  }

  /// Returns the path in the model to [node], or `null` if
  /// [node] is not in this [Model].
  ///
  /// Comparison is by identity, not by value, so the exact instance must be in
  /// this [Model].
  ///
  /// TODO: Should we create a base type called `Declaration` which is
  /// implemented by the types which are valid to pass here?
  QualifiedName? qualifiedNameOf(Map<String, Object?> node) =>
      _qualifiedNameOf(node);

  /// Returns the [QualifiedName] in the model to [node], or `null` if [node]
  /// is not in this [Model].
  QualifiedName? _qualifiedNameOf(Map<String, Object?> model) {
    var parent = _getParent(model);
    if (parent == null) return null;
    final path = <String>[];
    path.add(_keyOf(model, parent));
    var previousParent = parent;

    // Checks if any merged map of `left` == any merged map of `right.
    bool isEqualNested(Map<String, Object?> left, Map<String, Object?> right) {
      if (left == right) return true;
      return left.expand.any((l) => right.expand.contains(l));
    }

    while (true) {
      parent = _getParent(previousParent);
      if (parent == null) return null;

      /// We reached this models node, stop searching higher.
      if (isEqualNested(parent, node)) break;

      path.insert(0, _keyOf(previousParent, parent));
      previousParent = parent;
    }

    if (path case [final uri, 'scopes', final name]) {
      return QualifiedName(uri: uri, name: name);
    } else if (path
        case [final uri, 'scopes', final scope, 'members', final name]) {
      return QualifiedName(
          uri: uri,
          scope: scope,
          name: name,
          isStatic: Member.fromJson(model).properties.isStatic);
    }
    throw UnsupportedError(
        'Unsupported node type for `qualifiedNameOf`, only top level members '
        'are supported for now. $path');
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

  /// Gets the `Map` that contains [child], or `null` if there isn't one.
  Map<String, Object?>? _getParent(Map<String, Object?> child) {
    // If both maps are in the same `JsonBufferBuilder` then the parent is
    // immediately available.
    final childMaps = child.expand;
    final childBufferMaps = childMaps.whereType<MapInBuffer>();
    for (final thisMapInBuffer in node.expand.whereType<MapInBuffer>()) {
      for (final thatMapInBuffer in childBufferMaps) {
        if (thisMapInBuffer.buffer == thatMapInBuffer.buffer) {
          return thatMapInBuffer.parent;
        }
      }
    }
    // Otherwise, build a `Map` of references to parents and use that.
    return _lazyParentsMap[child];
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

/// Expando storing a `Map` from values to parent `Map`s.
final _parentsMaps = Expando<Map<Map<String, Object?>, Map<String, Object?>>>();
