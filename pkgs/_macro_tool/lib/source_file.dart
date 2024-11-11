// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as p;

import 'macro_runner.dart';

final _random = Random.secure();

/// Dart source file manipulation for `_macro_tool`.
extension type SourceFile(String path) implements String {
  static const _addedMarker = '// added by macro_tool';
  static final _cacheBusterString = 'CACHEBUSTER';
  static final _cacheBusterRegexp = RegExp('$_cacheBusterString[a-z0-9]*');

  /// Returns all `*.dart` files under `workspacePath`, including in
  /// subdirectories.s
  static List<SourceFile> findDartInWorkspace(String workspacePath) =>
      Directory(workspacePath)
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .map((f) => SourceFile(f.path))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  /// The source file path plus `.macro_tool_output`.
  String get toolOutputPath => '$path.macro_tool_output';

  /// Writes [output] to [toolOutputPath].
  ///
  /// [macroRunner] is notified of the change.
  void writeOutput(MacroRunner macroRunner, String output) {
    File(toolOutputPath).writeAsStringSync(output);
    macroRunner.notifyChange(toolOutputPath);
  }

  /// Patches [path] so the analyzer can analyze it without running macros.
  ///
  /// Adds a `part` statement referencing [toolOutputPath].
  ///
  /// [macroRunner] is notified of the change.
  void patchForAnalyzer(MacroRunner macroRunner) {
    final partName = p.basename(toolOutputPath);
    final line = "part '$partName'; $_addedMarker\n";

    final file = File(path);
    file.writeAsStringSync(_insertAfterLastImport(
        line, _removeToolAddedLinesFromSource(file.readAsStringSync())));
    macroRunner.notifyChange(path);
  }

  String _insertAfterLastImport(String line, String source) {
    final importRegexp = RegExp(r'^import .*;$', multiLine: true);
    final index = source.lastIndexOf(importRegexp);
    if (index == -1) return line + source;
    final nextLineIndex = index + source.substring(index).indexOf('\n') + 1;
    return source.substring(0, nextLineIndex) +
        line +
        source.substring(nextLineIndex);
  }

  /// Patches [path] and [toolOutputPath] so the CFE can run then without
  /// running macros.
  ///
  /// This means changing [toolOutputPath] from using parts to library
  /// augmentations and adding `import augment` to [path].
  ///
  /// [macroRunner] is notified of the change.
  void patchForCfe(MacroRunner macroRunner) {
    final partName = p.basename(toolOutputPath);
    final line = "import augment '$partName'; $_addedMarker\n";

    final file = File(path);
    file.writeAsStringSync(
        line + _removeToolAddedLinesFromSource(file.readAsStringSync()));
    macroRunner.notifyChange(path);

    final toolOutputFile = File(toolOutputPath);
    toolOutputFile.writeAsStringSync(toolOutputFile
        .readAsStringSync()
        .replaceAll('part of ', 'augment library '));
    macroRunner.notifyChange(toolOutputPath);
  }

  /// Reverts changes to source from any of [patchForAnalyzer], [patchForCfe]
  /// and/or [bustCaches].
  ///
  /// [macroRunner] is notified of the change.
  void revert(MacroRunner macroRunner) {
    final file = File(path);
    file.writeAsStringSync(_resetCacheBusters(
        _removeToolAddedLinesFromSource(file.readAsStringSync())));
    macroRunner.notifyChange(path);
    final toolOutputFile = File(toolOutputPath);
    if (toolOutputFile.existsSync()) {
      toolOutputFile.deleteSync();
      macroRunner.notifyChange(toolOutputPath);
    }
  }

  /// Returns [source] with lines added by [_addImportAugment] removed.
  String _removeToolAddedLinesFromSource(String source) =>
      source.split('\n').where((l) => !l.endsWith(_addedMarker)).join('\n');

  /// Updates the file to trigger macro rerun.
  ///
  /// The file must contain the string `CACHEBUSTER` in a place that triggers
  /// recomputation, for example in a field name.
  ///
  /// If there is an augmentation output file, updates that too.
  ///
  /// Returns whether any change was made to a file.
  ///
  /// [macroRunner] is notified of the change.
  bool bustCaches(MacroRunner macroRunner) {
    final token = _random.nextInt(1 << 32).toRadixString(16) +
        _random.nextInt(1 << 32).toRadixString(16);
    var cacheBusterFound = false;
    for (final path in [
      path,
      toolOutputPath,
    ]) {
      final file = File(path);
      if (!file.existsSync()) continue;
      final source = file.readAsStringSync();
      if (source.contains(_cacheBusterRegexp)) {
        cacheBusterFound = true;
        file.writeAsStringSync(
            source.replaceAll(_cacheBusterRegexp, '$_cacheBusterString$token'));
        macroRunner.notifyChange(path);
      }
    }
    return cacheBusterFound;
  }

  String _resetCacheBusters(String source) =>
      source.replaceAll(_cacheBusterRegexp, _cacheBusterString);
}
