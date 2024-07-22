// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:isolate';

import 'package:front_end/src/macros/macro_injected_impl.dart' as injected;
import 'package:frontend_server/compute_kernel.dart';
import 'package:macros/macros.dart';
import 'package:macros/src/executor.dart';
import 'package:test/test.dart';

void main() {
  group('CFE with injected macro implementation', () {
    late File productPlatformDill;
    late Directory tempDir;
    late TestMacroPackageConfigs packageConfigs;
    late TestMacroRunner runner;

    setUp(() {
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
      packageConfigs = TestMacroPackageConfigs();
      runner = TestMacroRunner();
      injected.macroImplementation = injected.MacroImplementation(
        packageConfigs: packageConfigs,
        macroRunner: runner,
      );
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

      expect(packageConfigs.macroWasFound, true);
      expect(runner.macroWasRun, true);

      // The source has a main method that uses the new declaration, so the
      // compile can only succeed if it was added by the macro.
      expect(computeKernelResult.succeeded, true);
    });
  });
}

class TestMacroPackageConfigs implements injected.MacroPackageConfigs {
  bool macroWasFound = false;

  @override
  bool isMacro(Uri uri, String name) {
    final result =
        uri.toString().endsWith('_test_macros/lib/declare_x_macro.dart') &&
            name == 'DeclareX';
    if (result == true) {
      macroWasFound = true;
    }
    return macroWasFound;
  }
}

class TestMacroRunner implements injected.MacroRunner {
  bool macroWasRun = false;

  @override
  injected.RunningMacro run(Uri uri, String name) {
    macroWasRun = true;
    return TestRunningMacro();
  }
}

class TestRunningMacro implements injected.RunningMacro {
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
  void serialize(Object serializer) => throw UnimplementedError();

  @override
  Map<Identifier, Iterable<DeclarationCode>> typeAugmentations;

  TestMacroExecutionResult(
      {Map<Identifier, Iterable<DeclarationCode>>? typeAugmentations})
      : typeAugmentations = typeAugmentations ?? {};
}
