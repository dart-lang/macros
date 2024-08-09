// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:isolate';

import 'package:_cfe_macros/macro_implementation.dart';
import 'package:front_end/src/macros/macro_injected_impl.dart' as injected;
import 'package:frontend_server/compute_kernel.dart';
import 'package:test/test.dart';

void main() {
  group('CFE with injected macro implementation', () {
    late File productPlatformDill;
    late Directory tempDir;

    setUp(() async {
      // Set up CFE.

      // TODO(davidmorgan): this dill comes from the Dart SDK running the test,
      // but `package:frontend_server` and `package:front_end` are used as a
      // library, so we will see version skew breakage. Find a better way.
      productPlatformDill = File('${Platform.resolvedExecutable}/../../'
          'lib/_internal/vm_platform_strong_product.dill');
      if (!File.fromUri(productPlatformDill.uri).existsSync()) {
        throw StateError('Failed to find platform dill: $productPlatformDill');
      }
      tempDir = Directory.systemTemp.createTempSync('cfe_test');

      // Inject test macro implementation.
      injected.macroImplementation = await CfeMacroImplementation.start(
          packageConfig: Isolate.packageConfigSync!);
    });

    test('discovers macros, runs them, applies augmentations', () async {
      final packagesUri = Isolate.packageConfigSync;
      final sourceFile =
          File('test/package_under_test/lib/apply_declare_x.dart');
      final outputFile = File('${tempDir.path}/out.dill');

      final computeKernelResult = await computeKernel([
        '--enable-experiment=macros',
        '--no-summary',
        '--no-summary-only',
        '--target=vm',
        '--dart-sdk-summary=${productPlatformDill.uri}',
        '--output=${outputFile.path}',
        '--source=${sourceFile.uri}',
        '--packages-file=$packagesUri',
        // For augmentations.
        '--enable-experiment=macros',
      ]);

      // The source has a main method that uses the new declaration, so the
      // compile can only succeed if it was added by the macro.
      expect(computeKernelResult.succeeded, true);
    });
  });
}
