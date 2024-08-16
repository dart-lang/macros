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
            .resolve('../../../introspection_goldens')
            .toFilePath());

    setUp(() async {
      // Set up analyzer.
      final contextCollection =
          AnalysisContextCollection(includedPaths: [directory.path]);
      analysisContext = contextCollection.contexts.first;
      injected.macroImplementation = await AnalyzerMacroImplementation.start(
          protocol: Protocol(encoding: 'binary'),
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
        goldenFile = File(p.setExtension(path, '.json'));
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
        final resolvedLibrary = (await analysisContext.currentSession
            .getResolvedLibrary(path)) as ResolvedLibraryResult;
        final augmentationUnit =
            resolvedLibrary.units.singleWhere((u) => u.isMacroAugmentation);

        // Each `QueryClass` outputs its query result as a comment in an
        // augmentation. Collect them and merge them to compare with the
        // golden.
        final macroOutputs = augmentationUnit.content
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
      if (result.containsKey(entry.key)) {
        result[entry.key] = _merge([
          result[entry.key]! as Map<String, Object?>,
          entry.value as Map<String, Object?>
        ]);
      } else {
        result[entry.key] = entry.value;
      }
    }
  }
  return result;
}
