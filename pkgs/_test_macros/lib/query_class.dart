// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';
import 'package:macro/macro.dart';
import 'package:macro_service/macro_service.dart';

/// Applies a macro which sends an empty query, and outputs an augmentation
/// that is the query result as a comment.
class QueryClass {
  const QueryClass();
}

class QueryClassImplementation implements Macro {
  @override
  MacroDescription get description => MacroDescription(runsInPhases: [3]);

  @override
  Future<AugmentResponse> augment(Host host, AugmentRequest request) async {
    final model = await host.query(Query());
    return AugmentResponse(augmentations: [Augmentation(code: '// $model')]);
  }
}
