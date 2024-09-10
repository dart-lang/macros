// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:_analyzer_macros/macro_implementation.dart';
import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/src/summary2/macro_injected_impl.dart' as injected;
import 'package:macro_service/macro_service.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late AnalysisContext analysisContext;

  group('analyzer with injected macro impl query result matches golden', () {
    final directory = Directory(
        Isolate.resolvePackageUriSync(Uri.parse('package:foo/foo.dart'))!
            .resolve('../../../goldens')
            .toFilePath());

    setUp(() async {
      // Set up analyzer.
      final contextCollection =
          AnalysisContextCollection(includedPaths: [directory.path]);
      analysisContext = contextCollection.contexts.first;
      injected.macroImplementation = await AnalyzerMacroImplementation.start(
          protocol: Protocol(
              encoding: ProtocolEncoding.binary,
              version: ProtocolVersion.macros1),
          packageConfig: Isolate.packageConfigSync!);
    });

    for (final file in directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))) {
      final path = file.path;
      final relativePath = p.relative(path, from: directory.path);

      File? introspectionGoldenFile;
      Map<String, Object?>? introspectionGolden;
      Map<String, Object?>? introspectionMacroOutput;

      File? applicationGoldenFile;
      String? applicationGolden;
      String? applicationMacroOutput;

      final updateGoldens = Platform.environment['UPDATE_GOLDENS'] == 'yes';
      setUp(() {
        introspectionGoldenFile = File(p.setExtension(path, '.analyzer.json'));
        if (introspectionGoldenFile!.existsSync()) {
          introspectionGolden =
              json.decode(introspectionGoldenFile!.readAsStringSync())
                  as Map<String, Object?>;
        } else {
          introspectionGoldenFile = null;
        }

        applicationGoldenFile =
            File(p.setExtension(path, '.analyzer.augmentations'));
        if (applicationGoldenFile!.existsSync()) {
          applicationGolden = applicationGoldenFile!.readAsStringSync();
        } else {
          applicationGoldenFile = null;
        }

        if (introspectionGoldenFile == null && applicationGoldenFile == null) {
          throw StateError('Setup failed, no goldens for $path');
        }
      });

      if (updateGoldens) {
        tearDown(() {
          if (introspectionGoldenFile != null &&
              introspectionMacroOutput != null) {
            final string = (const JsonEncoder.withIndent('  '))
                .convert(introspectionMacroOutput);
            if (introspectionGoldenFile!.readAsStringSync() != string) {
              print('Updating mismatched golden: '
                  '${introspectionGoldenFile!.path}');
              introspectionGoldenFile!.writeAsStringSync(string);
            }
          }
          if (applicationGoldenFile != null && applicationMacroOutput != null) {
            if (applicationGoldenFile!.readAsStringSync() !=
                applicationMacroOutput) {
              print(
                  'Updating mismatched golden: ${applicationGoldenFile!.path}');
              applicationGoldenFile!.writeAsStringSync(applicationMacroOutput!);
            }
          }
        });
      }

      test(relativePath, () async {
        final resolvedLibrary = (await analysisContext.currentSession
            .getResolvedLibrary(path)) as ResolvedLibraryResult;
        final augmentationUnit =
            resolvedLibrary.units.singleWhere((u) => u.isMacroAugmentation);

        if (introspectionGolden != null) {
          // Each `QueryClass` outputs its query result as a comment in an
          // augmentation. Collect them and merge them to compare with the
          // golden.
          final macroOutputs = augmentationUnit.content
              .split('\n')
              .where((l) => l.startsWith('// '))
              .map((l) => json.decode(l.substring('// '.length))
                  as Map<String, Object?>);
          introspectionMacroOutput = _merge(macroOutputs);

          expect(introspectionMacroOutput, introspectionGolden,
              reason: updateGoldens
                  ? '\n--> Goldens updated! Should pass on rerun.'
                  : '\n--> To update goldens, run: '
                      'UPDATE_GOLDENS=yes dart test');
        }

        if (applicationGolden != null) {
          applicationMacroOutput = augmentationUnit.content;
          expect(applicationMacroOutput, applicationGolden,
              reason: updateGoldens
                  ? '\n--> Goldens updated! Should pass on rerun.'
                  : '\n--> To update goldens, run: '
                      'UPDATE_GOLDENS=yes dart test');
        }
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
