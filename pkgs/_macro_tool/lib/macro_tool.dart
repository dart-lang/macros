// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'macro_runner.dart';
import 'source_file.dart';

/// Runs macros.
///
/// Various functionality related to running macros.
class MacroTool {
  final MacroRunner macroRunner;
  final String packageConfigPath;
  final String workspacePath;
  final int benchmarkIterations;
  final String? scriptPath;

  /// The most recent result from running macros.
  WorkspaceResult? _applyResult;

  MacroTool({
    required this.macroRunner,
    required this.packageConfigPath,
    required this.workspacePath,
    required this.benchmarkIterations,
    this.scriptPath,
  });

  /// Runs macros.
  ///
  /// Writes macro augmentations next to each source file with the extension
  /// `.macro_tool_output`.
  ///
  /// Then throws `StateError` if there were any errors.
  Future<void> apply() async {
    _applyResult = await macroRunner.run();

    for (final result in _applyResult!.fileResults) {
      if (result.output != null) {
        result.sourceFile.writeOutput(macroRunner, result.output!);
      }
    }

    if (_applyResult!.allErrors.isNotEmpty) {
      throw StateError('Errors: ${_applyResult!.allErrors}');
    }
  }

  /// Patches source so the analyzer can analyze it without running macros.
  ///
  /// Adds a `part` statement where needed to include augmentation output by
  /// `apply`.
  void patchForAnalyzer() {
    if (_applyResult == null) {
      throw UnsupportedError(
        '"patch_for_analyzer" command requires "apply" first.',
      );
    }

    for (final result in _applyResult!.fileResults) {
      if (result.output != null) {
        result.sourceFile.patchForAnalyzer(macroRunner);
      }
    }
  }

  /// Patches source and augmentations so the CFE can run then without
  /// running macros.
  ///
  /// This means changing augmentations from using parts to library
  /// augmentations and adding `import augment` as needed.
  void patchForCfe() {
    if (_applyResult == null) {
      throw UnsupportedError('"patch_for_cfe" command requires "apply" first.');
    }

    for (final result in _applyResult!.fileResults) {
      if (result.output != null) {
        result.sourceFile.patchForCfe(macroRunner);
      }
    }
  }

  /// Runs the script.
  ///
  /// The process exit code becomes the tool exit code.
  Future<int> run() async {
    if (scriptPath == null) {
      throw UnsupportedError('"run" command requires "--script".');
    }

    final result = Process.runSync(Platform.resolvedExecutable, [
      'run',
      '--enable-experiment=macros',
      '--enable-experiment=enhanced-parts',
      '--packages=$packageConfigPath',
      scriptPath!,
    ], workingDirectory: workspacePath);
    stdout.write(result.stdout);
    stderr.write(result.stderr);
    return result.exitCode;
  }

  /// Reverts changes to source from any of [patchForAnalyzer], [patchForCfe]
  /// and/or [bustCaches].
  void revert() {
    for (final sourceFile in macroRunner.sourceFiles) {
      sourceFile.revert(macroRunner);
    }
  }

  /// Benchmarks [apply].
  ///
  /// Each [apply] returns two timings: the time to first result and the time
  /// to last result. For the analyzer, this corresponds to analysis complete
  /// for one file in the workspace and analysis complete for all files in the
  /// workspace.
  ///
  /// Output is three sets of values separated by double commas:
  ///
  /// 1. Initial apply, first file time then last files time
  /// 2. All non-initial applies first file times
  /// 3. All non-initial applies last file times
  Future<void> benchmarkApply({bool injectImplementation = true}) async {
    // Busts caches, applies, throws if error, returns result.
    Future<WorkspaceResult> measure() async {
      bustCaches();
      _applyResult = await macroRunner.run(
        injectImplementation: injectImplementation,
      );
      if (_applyResult!.allErrors.isNotEmpty) {
        throw StateError('Errors: ${_applyResult!.allErrors}');
      }
      return _applyResult!;
    }

    final initialResult = await measure();
    stdout.write('${initialResult.firstResultAfter.inMilliseconds},');
    stdout.write('${initialResult.lastResultAfter.inMilliseconds},');
    stdout.write(',');

    final subsequentResults = <WorkspaceResult>[];
    for (var i = 0; i != benchmarkIterations; ++i) {
      subsequentResults.add(await measure());
      stdout.write('${subsequentResults[i].firstResultAfter.inMilliseconds},');
    }

    for (var i = 0; i != benchmarkIterations; ++i) {
      stdout.write(',${subsequentResults[i].lastResultAfter.inMilliseconds}');
    }
    print('');
  }

  /// As [benchmarkApply] but without injecting the `data_model` macro
  /// implementation.
  Future<void> benchmarkAnalyze() async {
    await benchmarkApply(injectImplementation: false);
  }

  /// Modifies source to avoid cached results, for benchmarking.
  ///
  /// Modifies files with `CACHEBUSTER`. Throws if not found in any source.
  void bustCaches() {
    var cacheBusterFound = false;
    for (final sourceFile in macroRunner.sourceFiles) {
      if (sourceFile.bustCaches(macroRunner)) {
        cacheBusterFound = true;
      }
    }
    if (!cacheBusterFound) {
      throw StateError(
        'Did not find CACHEBUSTER in any source, no changes were made.',
      );
    }
  }

  /// Loops watching for changes to [scriptPath] and applying after every change.
  Future<void> watch() async {
    if (scriptPath == null) {
      throw UnsupportedError('"watch" command requires "--script".');
    }
    // `asBroadcastStream` so repeated use of `first` below waits for the next
    // change.
    var events = File(scriptPath!).watch().asBroadcastStream();
    print(
      'Caution: timings can be misleading due to JIT warmup, host '
      'caching, and random variation. Check with benchmarks :)',
    );
    print('Watching for changes to: $scriptPath');
    while (true) {
      _applyResult = await macroRunner.run();
      for (final result in _applyResult!.fileResults) {
        if (result.output != null) {
          result.sourceFile.writeOutput(macroRunner, result.output!);
        }
      }
      if (_applyResult!.allErrors.isNotEmpty) {
        print('Errors: ${_applyResult!.allErrors}');
      }

      stdout.write(
        'Macros ran in in ${_applyResult!.firstResultAfter.inMilliseconds}ms,'
        ' watching...',
      );
      await events.first;
      print('changed, rerunning.');
      macroRunner.notifyChange(SourceFile(scriptPath!));
    }
  }
}
