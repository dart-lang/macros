// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';
import 'package:macro/macro.dart';
import 'package:macro_service/macro_service.dart';

import 'templating.dart';

/// Adds a getter `int get x` to the class.
class DeclareX {
  const DeclareX();
}

class DeclareXImplementation implements ClassDeclarationsMacro {
  // TODO(davidmorgan): this should be injected by the bootstrap script.
  @override
  MacroDescription get description => MacroDescription(
      annotation: QualifiedName(
          uri: 'package:_test_macros/declare_x_macro.dart', name: 'DeclareX'),
      runsInPhases: [2]);

  @override
  Future<AugmentResponse> buildDeclarationsForClass(
      Host host, AugmentRequest request) async {
    // TODO(davidmorgan): make the host only run in the phases requested so
    // that this is not needed.
    if (request.phase != 2) return AugmentResponse(augmentations: []);

    // TODO(davidmorgan): still need to pass through the augment target.
    return AugmentResponse(
        augmentations: [Augmentation(code: expandTemplate('int get x => 3;'))]);
  }
}
