// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
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

    test('discovers macros, runs them, responds to queries', () async {
      final packagesUri = Isolate.packageConfigSync;
      final sourceFile =
          File('test/package_under_test/lib/apply_query_class.dart');
      final outputFile = File('${tempDir.path}/out2.dill');

      final computeKernelResult = await computeKernel([
        '--enable-experiment=macros',
        '--no-summary',
        '--no-summary-only',
        '--target=vm',
        '--dart-sdk-summary=${productPlatformDill.uri}',
        '--output=${outputFile.path}',
        '--source=${sourceFile.uri}',
        '--packages-file=$packagesUri',
        // TODO(davidmorgan): this is so we can pull the generated augmentation
        // source out of incremental compiler state; find a less hacky way.
        '--use-incremental-compiler',
        // For augmentations.
        '--enable-experiment=macros',
      ]);

      // The source has a main method that uses the new declaration, so the
      // compile can only succeed if it was added by the macro.
      expect(computeKernelResult.succeeded, true);

      final sources = computeKernelResult
          .previousState!.incrementalCompiler!.context.uriToSource;
      final macroSource = sources.entries
          .singleWhere((e) => e.key.scheme == 'dart-macro+file')
          .value;

      // The macro outputs an augmentation with the query results in a comment;
      // find it and assert on that.
      final macroOutput = macroSource.text
          .split('\n')
          .singleWhere((l) => l.startsWith('// '))
          .substring('// '.length);
      expect(json.decode(macroOutput), {
        'uris': {
          'package:package_under_test_cfe/apply_query_class.dart': {
            'scopes': {
              'ClassWithMacroApplied': {
                'members': {
                  'x': {
                    'properties': {
                      'isAbstract': true,
                      'isGetter': false,
                      'isField': true,
                      'isMethod': false,
                      'isStatic': false
                    }
                  }
                }
              }
            }
          }
        }
      });
    });
  });
}
