// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:_macros/src/executor.dart';
import 'package:_macros/src/executor/serialization.dart';
import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/src/summary2/macro_injected_impl.dart';
import 'package:macros/macros.dart';
import 'package:macros/src/executor.dart';
import 'package:test/test.dart';

void main() {
  late AnalysisContext analysisContext;
  late TestMacroPackageConfigs packageConfigs;
  late TestMacroRunner runner;

  group('analyzer with injected macro implementation', () {
    setUp(() {
      // Set up analyzer.
      final directory =
          Directory.fromUri(Uri.parse('./test/package_under_test')).absolute;
      final contextCollection =
          AnalysisContextCollection(includedPaths: [directory.path]);
      analysisContext = contextCollection.contexts.first;

      // Inject test macro implementation.
      packageConfigs = TestMacroPackageConfigs();
      runner = TestMacroRunner();
      macroImplementation =
          MacroImplementation(packageConfigs: packageConfigs, runner: runner);
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

      // Macro was found by the analyzer and run.
      expect(packageConfigs.macroWasFound, true);
      expect(runner.macroWasRun, true);

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

class TestMacroPackageConfigs implements MacroPackageConfigs {
  bool macroWasFound = false;

  @override
  bool isMacro(Uri uri, String name) {
    final result =
        uri.toString() == 'package:_test_macros/declare_x_macro.dart' &&
            name == 'DeclareX';
    if (result) {
      macroWasFound = true;
    }
    return result;
  }
}

class TestMacroRunner implements MacroRunner {
  bool macroWasRun = false;

  @override
  RunningMacro run(Uri uri, String name) {
    macroWasRun = true;
    return TestRunningMacro();
  }
}

class TestRunningMacro implements RunningMacro {
  @override
  Future<MacroExecutionResult> executeDeclarationsPhase(MacroTarget target,
      DeclarationPhaseIntrospector declarationsPhaseIntrospector) async {
    return TestMacroExecutionResult(typeAugmentations: {
      (target as Declaration).identifier: [
        DeclarationCode.fromParts(['int get x => 3;'])
      ],
    });
  }

  @override
  Future<MacroExecutionResult> executeDefinitionsPhase(MacroTarget target,
      DefinitionPhaseIntrospector definitionPhaseIntrospector) async {
    return TestMacroExecutionResult();
  }

  @override
  Future<MacroExecutionResult> executeTypesPhase(
      MacroTarget target, TypePhaseIntrospector typePhaseIntrospector) async {
    return TestMacroExecutionResult();
  }
}

class TestMacroExecutionResult implements MacroExecutionResult {
  @override
  List<Diagnostic> get diagnostics => [];

  @override
  Map<Identifier, Iterable<DeclarationCode>> get enumValueAugmentations => {};

  @override
  MacroException? get exception => null;

  @override
  Map<Identifier, NamedTypeAnnotationCode> get extendsTypeAugmentations => {};

  @override
  Map<Identifier, Iterable<TypeAnnotationCode>> get interfaceAugmentations =>
      {};

  @override
  Iterable<DeclarationCode> get libraryAugmentations => {};

  @override
  Map<Identifier, Iterable<TypeAnnotationCode>> get mixinAugmentations => {};

  @override
  Iterable<String> get newTypeNames => [];

  @override
  void serialize(Serializer serializer) {}

  @override
  Map<Identifier, Iterable<DeclarationCode>> typeAugmentations;

  TestMacroExecutionResult(
      {Map<Identifier, Iterable<DeclarationCode>>? typeAugmentations})
      : typeAugmentations = typeAugmentations ?? {};
}
