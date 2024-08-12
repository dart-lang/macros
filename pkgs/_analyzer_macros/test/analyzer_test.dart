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
          packageConfig: Isolate.packageConfigSync!);
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

    test('discovers macros, runs them, responds to queries', () async {
      final path = File.fromUri(
              Uri.parse('./test/package_under_test/lib/apply_query_class.dart'))
          .absolute
          .path;

      // No analysis errors.
      final errors =
          await analysisContext.currentSession.getErrors(path) as ErrorsResult;
      expect(errors.errors, isEmpty);

      // The macro outputs an augmentation with the query results in a comment;
      // find it and assert on that.
      final resolvedLibrary = (await analysisContext.currentSession
          .getResolvedLibrary(path)) as ResolvedLibraryResult;
      final augmentationUnit =
          resolvedLibrary.units.singleWhere((u) => u.isMacroAugmentation);
      final macroOutput = augmentationUnit.content
          .split('\n')
          .singleWhere((l) => l.startsWith('// '))
          .substring('// '.length);
      expect(json.decode(macroOutput), {
        'uris': {
          'package:package_under_test_analyzer/apply_query_class.dart': {
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
