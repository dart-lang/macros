// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:_cfe_macros/macro_implementation.dart';
import 'package:front_end/src/macros/macro_injected_impl.dart' as injected;
import 'package:frontend_server/compute_kernel.dart';
import 'package:macro_service/macro_service.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('CFE with injected macro impl query result matches golden', () {
    late File productPlatformDill;
    late Directory tempDir;

    final directory = Directory(
        Isolate.resolvePackageUriSync(Uri.parse('package:foo/foo.dart'))!
            .resolve('../../../introspection_goldens')
            .toFilePath());

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
          protocol: Protocol(encoding: ProtocolEncoding.json),
          packageConfig: Isolate.packageConfigSync!);
    });

    for (final file in directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))) {
      final path = file.path;
      final relativePath = p.relative(path, from: directory.path);

      late File goldenFile;
      late Map<String, Object?> golden;
      Map<String, Object?>? macroOutput;
      final updateGoldens = Platform.environment['UPDATE_GOLDENS'] == 'yes';
      setUp(() {
        goldenFile = File(p.setExtension(path, '.cfe.json'));
        golden =
            json.decode(goldenFile.readAsStringSync()) as Map<String, Object?>;
      });
      if (updateGoldens) {
        tearDown(() {
          if (macroOutput != null) {
            final string =
                (const JsonEncoder.withIndent('  ')).convert(macroOutput);
            if (goldenFile.readAsStringSync() != string) {
              print('Updating mismatched golden: ${goldenFile.path}');
              goldenFile.writeAsStringSync(string);
            }
          }
        });
      }

      test(relativePath, () async {
        final packagesUri = Isolate.packageConfigSync;
        final outputFile = File('${tempDir.path}/$relativePath.dill');

        final computeKernelResult = await computeKernel([
          '--enable-experiment=macros',
          '--no-summary',
          '--no-summary-only',
          '--target=vm',
          '--dart-sdk-summary=${productPlatformDill.uri}',
          '--output=${outputFile.path}',
          '--source=${file.uri}',
          '--packages-file=$packagesUri',
          // TODO(davidmorgan): this is so we can pull the generated
          // augmentation source out of incremental compiler state; find a less
          // hacky way.
          '--use-incremental-compiler',
          // For augmentations.
          '--enable-experiment=macros',
        ]);

        final sources = computeKernelResult
            .previousState!.incrementalCompiler!.context.uriToSource;
        final macroSource = sources.entries
            .singleWhere((e) => e.key.scheme == 'dart-macro+file')
            .value
            .text;

        // Each `QueryClass` outputs its query result as a comment in an
        // augmentation. Collect them and merge them to compare with the
        // golden.
        final macroOutputs = macroSource
            .split('\n')
            .where((l) => l.startsWith('// '))
            .map((l) =>
                json.decode(l.substring('// '.length)) as Map<String, Object?>);
        macroOutput = _merge(macroOutputs);

        expect(macroOutput, golden,
            reason: updateGoldens
                ? null
                : '\n--> To update goldens, run: UPDATE_GOLDENS=yes dart test');
      });
    }
  });
}

Map<String, Object?> _merge(Iterable<Map<String, Object?>> maps) {
  final result = <String, Object?>{};
  for (final map in maps) {
    for (final entry in map.entries) {
      if (result[entry.key] case final Map<String, Object?> nested) {
        result[entry.key] =
            _merge([nested, entry.value as Map<String, Object?>]);
      } else {
        result[entry.key] = entry.value;
      }
    }
  }
  return result;
}
