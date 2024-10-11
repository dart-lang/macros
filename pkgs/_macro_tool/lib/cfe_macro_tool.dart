// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:isolate';

import 'package:_cfe_macros/macro_implementation.dart';
import 'package:front_end/src/macros/macro_injected_impl.dart' as injected_cfe;
import 'package:frontend_server/compute_kernel.dart';
import 'package:macro_service/macro_service.dart';

import 'macro_tool.dart';

class CfeMacroTool extends MacroTool {
  CfeMacroTool(
      {required super.workspacePath,
      required super.packageConfigPath,
      required super.scriptPath,
      required super.skipCleanup,
      required super.watch})
      : super.internal();

  /// Runs macros in [scriptFile] using the CFE.
  ///
  /// Writes any augmentation to [augmentationFilePath].
  ///
  /// Returns whether an augmentation file was written.
  @override
  Future<bool> augment() async {
    if (watch) throw UnimplementedError('--watch not implemented for CFE.');

    // TODO(davidmorgan): this dill comes from the Dart SDK running the test,
    // but `package:frontend_server` and `package:front_end` are used as a
    // library, so we will see version skew breakage. Find a better way.
    final productPlatformDill = File('${Platform.resolvedExecutable}/../../'
        'lib/_internal/vm_platform_strong_product.dill');
    if (!File.fromUri(productPlatformDill.uri).existsSync()) {
      throw StateError('Failed to find platform dill: $productPlatformDill');
    }
    injected_cfe.macroImplementation = await CfeMacroImplementation.start(
        protocol: Protocol(
            encoding: ProtocolEncoding.json, version: ProtocolVersion.macros1),
        packageConfig: Isolate.packageConfigSync!);

    final packagesUri = Isolate.packageConfigSync;

    // Don't directly use the compiler output: for consistency with the analyzer
    // codepath, run from the resulting source.
    // TODO(davidmorgan): maybe offer both as options? Not clear yet.
    final outputFile = File('/dev/null');

    final computeKernelResult = await computeKernel([
      '--enable-experiment=macros',
      '--no-summary',
      '--no-summary-only',
      '--target=vm',
      '--dart-sdk-summary=${productPlatformDill.uri}',
      '--output=${outputFile.path}',
      '--source=$scriptPath',
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
    final applicationMacroOutput = sources.entries
        .where((e) => e.key.scheme == 'dart-macro+file')
        .singleOrNull;
    if (applicationMacroOutput == null) return false;

    print('Macro output: '
        '$augmentationFilePath');
    File(augmentationFilePath)
        .writeAsStringSync(applicationMacroOutput.value.text);

    return true;
  }

  @override
  String toString() => 'CFE';
}
