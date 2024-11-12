// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_analyzer_macros/macro_implementation.dart';
import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart' hide FileResult;
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/src/summary2/macro_injected_impl.dart'
    as injected_analyzer;
import 'package:macro_service/macro_service.dart';

import 'macro_runner.dart';
import 'source_file.dart';

class AnalyzerMacroRunner implements MacroRunner {
  final String workspacePath;
  final String packageConfigPath;

  @override
  final List<SourceFile> sourceFiles;

  late final AnalysisContext analysisContext;
  AnalyzerMacroImplementation? analyzerMacroImplementation;

  AnalyzerMacroRunner({
    required this.workspacePath,
    required this.packageConfigPath,
  }) : sourceFiles = SourceFile.findDartInWorkspace(workspacePath) {
    final contextCollection = AnalysisContextCollection(
      includedPaths: [workspacePath],
    );
    analysisContext = contextCollection.contexts.single;
  }

  void notifyChange(String sourcePath) {
    analysisContext.changeFile(sourcePath);
  }

  @override
  Future<WorkspaceResult> run({bool injectImplementation = true}) async {
    if (injectImplementation) {
      analyzerMacroImplementation ??= await AnalyzerMacroImplementation.start(
        protocol: Protocol(
          encoding: ProtocolEncoding.binary,
          version: ProtocolVersion.macros1,
        ),
        packageConfig: Uri.file(packageConfigPath),
      );
      injected_analyzer.macroImplementation = analyzerMacroImplementation;
    } else {
      injected_analyzer.macroImplementation = null;
    }

    final fileResults = <FileResult>[];
    final stopwatch = Stopwatch()..start();
    await analysisContext.applyPendingFileChanges();

    Duration? firstDuration;
    for (final sourceFile in sourceFiles) {
      ResolvedLibraryResult resolvedLibrary =
          (await analysisContext.currentSession.getResolvedLibrary(sourceFile))
              as ResolvedLibraryResult;

      final errors =
          ((await analysisContext.currentSession.getErrors(sourceFile))
                  as ErrorsResult)
              .errors
              .where((e) => e.severity == Severity.error)
              .map((e) => e.toString())
              .toList();

      final augmentationUnits =
          resolvedLibrary.units.where((u) => u.isMacroPart).toList();
      final output = augmentationUnits.singleOrNull?.content;

      fileResults.add(
        FileResult(sourceFile: sourceFile, output: output, errors: errors),
      );
      firstDuration ??= stopwatch.elapsed;
    }

    return WorkspaceResult(
      fileResults: fileResults,
      firstResultAfter: firstDuration!,
      lastResultAfter: stopwatch.elapsed,
    );
  }
}
