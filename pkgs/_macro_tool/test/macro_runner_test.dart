// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:isolate';

import 'package:_macro_tool/analyzer_macro_runner.dart';
import 'package:_macro_tool/cfe_macro_runner.dart';
import 'package:test/test.dart';

void main() {
  final packageConfigPath = Isolate.packageConfigSync!.toFilePath();
  final workspacePath =
      Directory.fromUri(Uri.parse('./test/package_under_test')).absolute.path;

  group('AnalyzerMacroRunner', () {
    test('runs macros', () async {
      final macroRunner = AnalyzerMacroRunner(
        packageConfigPath: packageConfigPath,
        workspacePath: workspacePath,
      );
      final result = await macroRunner.run();

      // Two files that produce macro output, no errors.
      expect(result.fileResults.length, 2);
      expect(result.allErrors, isEmpty);
      expect(result.fileResults.map((r) => r.output), everyElement(isNotNull));
    });
  });

  group('CfeMacroRunner', () {
    test('runs macros', () async {
      final macroRunner = CfeMacroRunner(
        packageConfigPath: packageConfigPath,
        workspacePath: workspacePath,
      );
      final result = await macroRunner.run();

      // Two files that produce macro output, no errors.
      expect(result.fileResults.length, 2);
      expect(result.allErrors, isEmpty);
      expect(result.fileResults.map((r) => r.output), everyElement(isNotNull));
    });
  });
}
