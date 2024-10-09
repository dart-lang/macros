// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:path/path.dart' as p;

import 'analyzer_macro_tool.dart';
import 'cfe_macro_tool.dart';

/// Runs a Dart script with `dart_model` macros.
abstract class MacroTool {
  String workspacePath;
  String packageConfigPath;
  String scriptPath;
  bool skipCleanup;

  MacroTool.internal(
      {required this.workspacePath,
      required this.packageConfigPath,
      required this.scriptPath,
      required this.skipCleanup});

  factory MacroTool(
          {required HostOption host,
          required String workspacePath,
          required String packageConfigPath,
          required String scriptPath,
          required bool skipCleanup}) =>
      host == HostOption.analyzer
          ? AnalyzerMacroTool(
              workspacePath: workspacePath,
              packageConfigPath: packageConfigPath,
              scriptPath: scriptPath,
              skipCleanup: skipCleanup)
          : CfeMacroTool(
              workspacePath: workspacePath,
              packageConfigPath: packageConfigPath,
              scriptPath: scriptPath,
              skipCleanup: skipCleanup);

  Future<void> run() async {
    print('Running ${p.basename(scriptPath)} with macros on $this.');
    print('~~~');
    print('Package config: $packageConfigPath');
    print('Workspace: $workspacePath');
    print('Script: $scriptPath');

    // TODO(davidmorgan): make it an option to run with the CFE instead.
    if (!await augment()) {
      print('No augmentation was generated, nothing to do, exiting.');
      exit(1);
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
        print(
            '~~~ exit code $exitCode, skipping cleanup because --skip-cleanup');
      } else {
        print('~~~ exit code $exitCode, cleanup follows');
        _removeImportAugment();
        _removeAugmentations();
      }
    }

    // The analyzer seems to prevent exit.
    exit(exitCode);
  }

  /// The path where macro-generated augmentations will be written.
  String get augmentationFilePath => '$scriptPath.macro_tool_output';

  /// Runs macros in [scriptFile] on the analyzer.
  ///
  /// Writes any augmentation to [augmentationFilePath].
  ///
  /// Returns whether an augmentation file was written.
  Future<bool> augment();

  /// Deletes the augmentation file created by this tool.
  void _removeAugmentations() {
    print('Deleting: $augmentationFilePath');
    File(augmentationFilePath).deleteSync();
  }

  /// Adds `import augment` of the augmentation file.
  ///
  /// When macros run in the analyzer or CFE this inclusion of the augmentation
  /// output is automatic, but for `macro_tool` it has to be patched in.
  void _addImportAugment() {
    print('Patching to import augmentations: $scriptPath');

    // Add the `import augment` statement at the start of the file.
    final partName = p.basename(augmentationFilePath);
    final line = "import augment '$partName'; $_addedMarker\n";

    final file = File(scriptPath);
    file.writeAsStringSync(
        line + _removeToolAddedLinesFromSource(file.readAsStringSync()));
  }

  /// Reverts the script file.
  void _removeImportAugment() {
    print('Reverting: $scriptPath');
    final file = File(scriptPath);
    file.writeAsStringSync(
        _removeToolAddedLinesFromSource(file.readAsStringSync()));
  }

  /// Returns [source] with lines added by [_addImportAugment] removed.
  String _removeToolAddedLinesFromSource(String source) => source
      .split('\n')
      .where((l) => !l.endsWith(_addedMarker))
      .map((l) => '$l\n')
      .join();
}

final String _addedMarker = '// added by macro_tool';

enum HostOption {
  analyzer,
  cfe;

  static HostOption? forString(String? option) => switch (option) {
        'analyzer' => HostOption.analyzer,
        'cfe' => HostOption.cfe,
        _ => null,
      };
}
