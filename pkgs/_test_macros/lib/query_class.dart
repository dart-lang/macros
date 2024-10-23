// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:dart_model/dart_model.dart';
import 'package:macro/macro.dart';
import 'package:macro_service/macro_service.dart';

import 'templating.dart';

/// Applies a macro which sends an empty query, and outputs an augmentation
/// that is the query result as a comment.
class QueryClass {
  const QueryClass();
}

class QueryClassImplementation implements ClassTypesMacro {
  // TODO(davidmorgan): this should be injected by the bootstrap script.
  @override
  MacroDescription get description => MacroDescription(
      annotation: QualifiedName(
          uri: 'package:_test_macros/query_class.dart', name: 'QueryClass'),
      runsInPhases: [3]);

  @override
  Future<void> buildTypesForClass(ClassTypesBuilder builder) async {
    final qualifiedName = builder.model.qualifiedNameOf(builder.target.node)!;
    final result = await builder.query(Query(target: qualifiedName));
    builder.declareType(
        'A',
        Augmentation(
            code: expandTemplate('// ${json.encode(result)}\nClass A {}')));
  }
}
