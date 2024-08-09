// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:isolate';

import 'package:_analyzer_macros/macro_implementation.dart';
import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/src/summary2/macro_injected_impl.dart' as injected;
import 'package:test/test.dart';

void main() {
  late AnalysisContext analysisContext;

  group('analyzer with injected macro implementation', () {
    setUp(() async {
      // Set up analyzer.
      final directory =
          Directory.fromUri(Uri.parse('./test/package_under_test')).absolute;
      final contextCollection =
          AnalysisContextCollection(includedPaths: [directory.path]);
      analysisContext = contextCollection.contexts.first;
      injected.macroImplementation = await AnalyzerMacroImplementation.start(
          packageConfig: Isolate.packageConfigSync!,
          macroImplByName: {
            'package:_test_macros/declare_x_macro.dart#DeclareX':
                'package:_test_macros/declare_x_macro.dart'
                    '#DeclareXImplementation'
          });
    });

    test('discovers macros, runs them, applies augmentations', () async {
      final path = File.fromUri(
              Uri.parse('./test/package_under_test/lib/apply_declare_x.dart'))
          .absolute
          .path;

      // No analysis errors.
      final errors =
          await analysisContext.currentSession.getErrors(path) as ErrorsResult;
      expect(errors.errors, isEmpty);

      // The expected new declaration augmentation was applied.
      final resolvedLibrary = (await analysisContext.currentSession
          .getResolvedLibrary(path)) as ResolvedLibraryResult;
      final clazz = resolvedLibrary.element.getClass('ClassWithMacroApplied')!;
      expect(clazz.fields, isEmpty);
      expect(clazz.augmented.fields, isNotEmpty);
      expect(clazz.augmented.fields.single.name, 'x');
    });
  });
}
