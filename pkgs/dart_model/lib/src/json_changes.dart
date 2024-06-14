// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'json.dart';

/// The changes between two [Json] instances.
extension type JsonChanges.fromJson(Map<String, Object?> node) {
  JsonChanges({
    required List<Update> updates,
    required List<Removal> removals,
  }) : this.fromJson({
          'updates': updates,
          'removals': removals,
        });

  /// The nodes that were updated by these changes.
  List<Update> get updates => (node['updates']! as List).cast();

  /// The nodes that were removed by these changes.
  List<Removal> get removals => (node['removals']! as List).cast();
}

/// A path into JSON data.
extension type Path.fromJson(List<Object?> node) {
  Path(List<String> path) : this.fromJson(path);

  List<String> get path => (node as List).cast();

  String? get uri => path.isEmpty ? null : path.first;

  /// This path followed by [element].
  Path followedByOne(String element) =>
      Path(path.followedBy([element]).toList());

  /// This path except the first entry.
  Path skipOne() => Path(path.skip(1).toList());
}

/// One update to JSON data: a [Path] and a node.
extension type Update.fromJson(List<Object?> node) {
  Update({
    required Path path,
    required Object? value,
  }) : this.fromJson([path, value]);

  Path get path => node[0] as Path;
  Object? get value => node[1];
}

/// One removal from JSON data: a [Path].
extension type Removal.fromJson(List<Object?> node) {
  Removal({
    required Path path,
  }) : this.fromJson(path.path);

  Path get path => node as Path;
}
