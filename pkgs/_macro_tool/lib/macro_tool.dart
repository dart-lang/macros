// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:_analyzer_macros/macro_implementation.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/src/summary2/macro_injected_impl.dart' as injected;
import 'package:macro_service/macro_service.dart';
import 'package:path/path.dart' as p;

/// Runs a Dart script with `dart_model` macros.
class MacroTool {
  String workspacePath;
  String packageConfigPath;
  String scriptPath;
  bool skipCleanup;

  MacroTool(
      {required this.workspacePath,
      required this.packageConfigPath,
      required this.scriptPath,
      required this.skipCleanup});

  Future<void> run() async {
    print('Running ${p.basename(scriptPath)} with macros.');
    print('~~~');
    print('Package config: $packageConfigPath');
    print('Workspace: $workspacePath');
    print('Script: $scriptPath');

    // TODO(davidmorgan): make it an option to run with the CFE instead.
    if (!await _augmentUsingAnalyzer()) {
      print('No augmentation was generated, nothing to do, exiting.');
      exit(0);
    }

    _addImportAugment();

    try {
      print('~~~ running, output follows');
      final result = Process.runSync(
        Platform.resolvedExecutable,
        [
          'run',
          '--enable-experiment=macros',
          '--enable-experiment=enhanced-parts',
          '--packages=$packageConfigPath',
          scriptPath
        ],
        workingDirectory: workspacePath,
      );
      stdout.write(result.stdout);
      stderr.write(result.stderr);
      exitCode = result.exitCode;
    } finally {
      if (skipCleanup) {
        print('~~~ done running, skipping cleanup because --skip-cleanup');
      } else {
        print('~~~ done running, cleanup follows');
        _removeImportAugment();
        _removeAugmentations();
      }
    }

    // The analyzer seems to prevent exit.
    exit(0);
  }

  /// The path where macro-generated augmentations will be written.
  String get _augmentationFilePath => '$scriptPath.macro_tool_output';

  /// Runs macros in [scriptFile].
  ///
  /// Writes any augmentation to [_augmentationFilePath].
  ///
  /// Returns whether an augmentation file was written.
  Future<bool> _augmentUsingAnalyzer() async {
    final contextCollection =
        AnalysisContextCollection(includedPaths: [workspacePath]);
    final analysisContext = contextCollection.contexts.first;
    injected.macroImplementation = await AnalyzerMacroImplementation.start(
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
        resolvedLibrary.units.where((u) => u.isMacroAugmentation).toList();
    if (augmentationUnits.isEmpty) {
      return false;
    }

    print('Macro output (patched to use augment library): '
        '$_augmentationFilePath');
    File(_augmentationFilePath).writeAsStringSync(augmentationUnits
        .single.content
        // The analyzer produces augmentations in parts, but the CFE still
        // wants them in augmentation libraries. Adjust the output accordingly.
        .replaceAll('part of', 'augment library'));

    return true;
  }

  /// Deletes the augmentation file created by this tool.
  void _removeAugmentations() {
    print('Deleting: $_augmentationFilePath');
    File(_augmentationFilePath).deleteSync();
  }

  /// The path where the script file will be backed up before modification.
  String get _backupScriptPath => '$scriptPath.backup';

  /// Adds `import augment` of the augmentation file.
  ///
  /// When macros run in the analyzer or CFE this inclusion of the augmentation
  /// output is automatic, but for `macro_tool` it has to be patched in.
  void _addImportAugment() {
    print('Patching to import augmentations: $scriptPath');
    // Back up the unmodified file for [_removeImportAugment].
    final file = File(scriptPath);
    file.copySync(_backupScriptPath);

    // Add the `import augment` statement at the start of the file.
    final partName = p.basename(_augmentationFilePath);
    final line = "import augment '$partName'; // added by macro_tool\n";

    file.writeAsStringSync(line + file.readAsStringSync());
  }

  /// Reverts the script file.
  void _removeImportAugment() {
    print('Reverting: $scriptPath');
    File(_backupScriptPath).renameSync(scriptPath);
  }
}
