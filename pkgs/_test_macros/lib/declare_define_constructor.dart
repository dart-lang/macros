// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';
import 'package:macro/macro.dart';
import 'package:macro_service/macro_service.dart';

/// Declares a constructor `x` in phase 2, defines it in phase 3.
class DeclareDefineConstructor {
  const DeclareDefineConstructor();
}

class DeclareDefineConstructorImplementation implements Macro {
  // TODO(davidmorgan): this should be injected by the bootstrap script.
  @override
  MacroDescription get description => MacroDescription(
      annotation: QualifiedName(
          uri: 'package:_test_macros/declare_define_constructor.dart',
          name: 'DeclareDefineConstructor'),
      runsInPhases: [2, 3]);

  @override
  Future<AugmentResponse> augment(Host host, AugmentRequest request) async {
    if (request.phase == 2) {
      return AugmentResponse(augmentations: [
        Augmentation(code: 'external ${request.target.name}.x();')
      ]);
    } else if (request.phase == 3) {
      return AugmentResponse(augmentations: [
        Augmentation(code: 'augment ${request.target.name}.x();')
      ]);
    } else {
      return AugmentResponse(augmentations: []);
    }
  }
}
