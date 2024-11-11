// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:_cfe_macros/macro_implementation.dart';
import 'package:front_end/src/macros/macro_injected_impl.dart' as injected_cfe;
import 'package:frontend_server/compute_kernel.dart';
import 'package:macro_service/macro_service.dart';
import 'package:path/path.dart' as p;

import 'macro_runner.dart';
import 'source_file.dart';

class CfeMacroRunner implements MacroRunner {
  final String workspacePath;
  final String packageConfigPath;

  @override
  final List<SourceFile> sourceFiles;

  CfeMacroImplementation? cfeMacroImplementation;

  CfeMacroRunner({required this.workspacePath, required this.packageConfigPath})
      : sourceFiles = SourceFile.findDartInWorkspace(workspacePath);

  void notifyChange(String sourcePath) {
    // No incremental compile.
  }

  File get _productPlatformDill {
    // TODO(davidmorgan): this dill comes from the Dart SDK running the test,
    // but `package:frontend_server` and `package:front_end` are used as a
    // library, so we will see version skew breakage. Find a better way.
    final result = File(p.canonicalize('${Platform.resolvedExecutable}/../../'
        'lib/_internal/vm_platform_strong_product.dill'));
    if (!result.existsSync()) {
      throw StateError('Failed to find platform dill: $result');
    }
    return result;
  }

  @override
  Future<WorkspaceResult> run({bool injectImplementation = true}) async {
    if (injectImplementation) {
      cfeMacroImplementation ??= await CfeMacroImplementation.start(
          protocol: Protocol(
              encoding: ProtocolEncoding.json,
              version: ProtocolVersion.macros1),
          packageConfig: Uri.file(packageConfigPath));
      injected_cfe.macroImplementation = cfeMacroImplementation;
    } else {
      injected_cfe.macroImplementation = null;
    }

    final fileResults = <FileResult>[];
    final stopwatch = Stopwatch()..start();

    // Don't directly use the compiler output: for consistency with the analyzer
    // codepath, run from the resulting source.
    // TODO(davidmorgan): maybe offer both as options? Not clear yet.
    final outputFile = File('/dev/null');

    final packagesUri = Uri.file(packageConfigPath);

    final computeKernelResult = await computeKernel([
      '--enable-experiment=macros',
      '--no-summary',
      '--no-summary-only',
      '--target=vm',
      '--dart-sdk-summary=${_productPlatformDill.uri}',
      '--output=${outputFile.path}',
      for (final sourceFile in sourceFiles) '--source=${Uri.file(sourceFile)}',
      '--packages-file=$packagesUri',
      // TODO(davidmorgan): this is so we can pull the generated
      // augmentation source out of incremental compiler state; find a less
      // hacky way.
      '--use-incremental-compiler',
    ]);

    final sources = computeKernelResult
        .previousState!.incrementalCompiler!.context.uriToSource;

    for (final sourceFile in sourceFiles) {
      final macroSource =
          sources[Uri.file(sourceFile.path).replace(scheme: 'dart-macro+file')];
      if (macroSource != null) {
        fileResults.add(FileResult(
            sourceFile: sourceFile,
            output: macroSource.text,
            errors: computeKernelResult.succeeded ? [] : ['compile failed']));
      }
    }

    return WorkspaceResult(
        fileResults: fileResults,
        firstResultAfter: stopwatch.elapsed,
        lastResultAfter: stopwatch.elapsed);
  }
}
