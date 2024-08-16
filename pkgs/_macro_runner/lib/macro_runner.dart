// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:_macro_builder/macro_builder.dart';
import 'package:macro_service/macro_service.dart';

/// Runs macros.
///
/// TODO(davidmorgan): support shutdown/cleanup.
class MacroRunner {
  /// Starts [macroBundle] connected to [endpoint].
  void start(
      {required BuiltMacroBundle macroBundle,
      // TODO(davidmorgan): this should be negotiated, not passed here.
      required Protocol protocol,
      required HostEndpoint endpoint}) {
    Process.run(macroBundle.executablePath,
        [json.encode(protocol), json.encode(endpoint)]).then((result) {
      if (result.exitCode != 0) {
        print('Macro process exited with error: ${result.stderr}');
      }
    });
  }
}
