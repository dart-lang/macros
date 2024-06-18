// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'json.dart';

/// The changes between two [JsonData] instances.
///
/// To apply changes, the tree of [updates] should be "copied in" to the
/// target tree.
///
/// To apply removals, the [removals] tree should be traversed like the target
/// tree, removing any node where the [removals] tree has a `null` value.
///
/// TODO(davidmorgan): finalize the changes format. Should it include changes
/// to lists? Should updates and removals be merged in one tree?
extension type JsonChanges.fromJson(Map<String, Object?> node) {
  JsonChanges({
    required JsonData updates,
    required JsonData removals,
  }) : this.fromJson({
          'updates': updates,
          'removals': removals,
        });

  /// The nodes that were updated by these changes, or `null` for none.
  Map<String, Object?>? get updates => node['updates'] as Map<String, Object?>?;

  /// The nodes that were removed by these changes, or `null` for none.
  Map<String, Object?>? get removals =>
      node['removals'] as Map<String, Object?>?;
}
