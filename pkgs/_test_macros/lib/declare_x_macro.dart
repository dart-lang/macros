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
  void buildDeclarationsForClass(ClassDeclarationsBuilder builder) {
    builder
        .declareInType(Augmentation(code: expandTemplate('int get x => 3;')));
  }
}
