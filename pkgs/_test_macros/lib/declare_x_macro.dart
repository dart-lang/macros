// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:macro/macro.dart';
import 'package:macro_service/macro_service.dart';

class DeclareX {
  const DeclareX();
}

// TODO(davidmorgan): this is a placeholder; make it do something, test it.
class DeclareXImplementation implements Macro {
  @override
  MacroDescription get description => MacroDescription(
        runsInPhaseThree: true,
      );

  @override
  Future<AugmentResponse> augment(Host host, AugmentRequest request) async {
    // TODO(davidmorgan): add an implementation.
    return AugmentResponse();
  }
}
