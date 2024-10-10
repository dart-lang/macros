// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';
import 'package:macro/macro.dart';
import 'package:macro_service/macro_service.dart';

/// A macro that illegally attempts to issue a type query in phase 1.
class AttemptToIssueTypeQueryInPhase1 {
  const AttemptToIssueTypeQueryInPhase1();
}

class AttemptToIssueTypeQueryInPhase1Implementation implements Macro {
  // TODO(davidmorgan): this should be injected by the bootstrap script.
  @override
  MacroDescription get description => MacroDescription(
      annotation: QualifiedName(
          uri: 'package:_test_macros/misbehaving_macro.dart',
          name: 'AttemptToIssueTypeQueryInPhase1'),
      runsInPhases: [1]);

  @override
  Future<AugmentResponse> augment(Host host, AugmentRequest request) async {
    // TODO(davidmorgan): make the host only run in the phases requested so
    // that this is not needed.
    if (request.phase != 1) return AugmentResponse(augmentations: []);

    try {
      await host.query(
          Query.queryStaticType(QueryStaticType(target: request.target)));

      return AugmentResponse(
        augmentations: [
          Augmentation(code: [Code.string('// Should not reach this point')])
        ],
      );
    } catch (e) {
      return AugmentResponse(
        augmentations: [
          Augmentation(code: [Code.string('// Could not query')])
        ],
      );
    }
  }
}
