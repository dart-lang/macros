// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';

class MacroBuilder {
  /// Builds an executable from user-written macro code.
  ///
  /// Each `QualifiedName` in [macroImplementations] must point to a class that
  /// implements `Macro` from `package:macro`.
  Future<BuiltMacroBundle> build(
      Iterable<QualifiedName> macroImplementations) async {
    // TODO(davidmorgan): implement.
    // Generated entrypoint will instantiate all the `Macro` instances pointed
    // to by `macroImplementations` then pass them to `MacroClient.run` in
    // `package:_macro_client`.
    return BuiltMacroBundle();
  }
}

/// A bundle of one or more macros that's ready to execute.
class BuiltMacroBundle {}
