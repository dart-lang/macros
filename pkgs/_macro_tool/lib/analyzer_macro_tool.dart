// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:_analyzer_macros/macro_implementation.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/src/summary2/macro_injected_impl.dart'
    as injected_analyzer;
import 'package:macro_service/macro_service.dart';

import 'macro_tool.dart';

class AnalyzerMacroTool extends MacroTool {
  AnalyzerMacroTool(
      {required super.workspacePath,
      required super.packageConfigPath,
      required super.scriptPath,
      required super.skipCleanup})
      : super.internal();

  /// Runs macros in [scriptFile] on the analyzer.
  ///
  /// Writes any augmentation to [_augmentationFilePath].
  ///
  /// Returns whether an augmentation file was written.
  @override
  Future<bool> augment() async {
    final contextCollection =
        AnalysisContextCollection(includedPaths: [workspacePath]);
    final analysisContext = contextCollection.contexts.first;
    injected_analyzer.macroImplementation =
        await AnalyzerMacroImplementation.start(
            protocol: Protocol(
                encoding: ProtocolEncoding.binary,
                version: ProtocolVersion.macros1),
            packageConfig: Uri.file(packageConfigPath));

    final resolvedLibrary = (await analysisContext.currentSession
        .getResolvedLibrary(scriptPath)) as ResolvedLibraryResult;

    final errors = (await analysisContext.currentSession.getErrors(scriptPath))
        as ErrorsResult;
    if (errors.errors.isNotEmpty) {
      print('Errors: ${errors.errors}');
    }

    final augmentationUnits =
        resolvedLibrary.units.where((u) => u.isMacroPart).toList();
    if (augmentationUnits.isEmpty) {
      return false;
    }

    print('Macro output (patched to use augment library): '
        '$augmentationFilePath');
    File(augmentationFilePath).writeAsStringSync(augmentationUnits
        .single.content
        // The analyzer produces augmentations in parts, but the CFE still
        // wants them in augmentation libraries. Adjust the output accordingly.
        .replaceAll('part of', 'augment library'));

    return true;
  }

  @override
  String toString() => 'analyzer';
}
