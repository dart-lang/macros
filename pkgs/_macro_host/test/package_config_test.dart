// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:isolate';

import 'package:_macro_host/src/package_config.dart';
import 'package:dart_model/dart_model.dart';
import 'package:test/test.dart';

void main() {
  group(MacroPackageConfig, () {
    test('can look up macro implementations from package URIs', () async {
      final packageConfig =
          MacroPackageConfig.readFromUri(Isolate.packageConfigSync!);

      expect(
          packageConfig
              .lookupMacroImplementation(QualifiedName(
                  uri: 'package:_test_macros/declare_x_macro.dart',
                  name: 'DeclareX'))!
              .asString,
          'package:_test_macros/declare_x_macro.dart#DeclareXImplementation');
    });

    test('can look up macro implementations from file URIs', () async {
      final packageConfig =
          MacroPackageConfig.readFromUri(Isolate.packageConfigSync!);

      final sourceFileUri = Directory.current.uri
          .resolve('../_test_macros/lib/declare_x_macro.dart');

      expect(
          packageConfig
              .lookupMacroImplementation(
                  QualifiedName(uri: '$sourceFileUri', name: 'DeclareX'))!
              .asString,
          'package:_test_macros/declare_x_macro.dart#DeclareXImplementation');
    });
  });
}
