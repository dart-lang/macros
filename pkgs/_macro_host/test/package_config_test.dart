// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:isolate';

import 'package:_macro_host/src/package_config.dart';
import 'package:dart_model/dart_model.dart';
import 'package:test/test.dart';

void main() {
  group(MacroPackageConfig, () {
    test('can look up macro implementations', () async {
      final packageConfig =
          MacroPackageConfig.readUri(Isolate.packageConfigSync!);

      expect(
          packageConfig
              .lookupMacroImplementation(QualifiedName(
                  'package:_test_macros/declare_x_macro.dart#DeclareX'))!
              .string,
          'package:_test_macros/declare_x_macro.dart#DeclareXImplementation');
    });
  });
}
