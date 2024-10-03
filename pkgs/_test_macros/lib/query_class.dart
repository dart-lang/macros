// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:dart_model/dart_model.dart';
import 'package:macro/macro.dart';
import 'package:macro_service/macro_service.dart';

/// Applies a macro which sends an empty query, and outputs an augmentation
/// that is the query result as a comment.
class QueryClass {
  const QueryClass();
}

class QueryClassImplementation implements Macro {
  // TODO(davidmorgan): this should be injected by the bootstrap script.
  @override
  MacroDescription get description => MacroDescription(
      annotation: QualifiedName(
          uri: 'package:_test_macros/query_class.dart', name: 'QueryClass'),
      runsInPhases: [3]);

  @override
  Future<AugmentResponse> augment(Host host, AugmentRequest request) async {
    // TODO(davidmorgan): make the host only run in the phases requested so
    // that this is not needed.
    if (request.phase != 3) return AugmentResponse(augmentations: []);

    final model = await host.query(Query.queryName(QueryName(
      target: request.target,
    )));
    return AugmentResponse(
        augmentations: [Augmentation(code: '// ${json.encode(model)}')]);
  }
}
