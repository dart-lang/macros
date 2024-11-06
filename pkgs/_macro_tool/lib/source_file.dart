// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as p;

final _random = Random.secure();

extension type SourceFile(String path) implements String {
  static const _addedMarker = '// added by macro_tool';
  static final _cacheBusterString = 'CACHEBUSTER';
  static final _cacheBusterRegexp = RegExp('$_cacheBusterString[a-z0-9]*');

  /// The source file path plus `.macro_tool_output`.
  String get toolOutputPath => '$path.macro_tool_output';

  /// Writes [output] to [toolOutputPath].
  void writeOutput(String output) {
    File(toolOutputPath).writeAsStringSync(output);
  }

  void patchForAnalyzer() {
    final partName = p.basename(toolOutputPath);
    final line = "part '$partName'; $_addedMarker\n";

    final file = File(path);
    file.writeAsStringSync(_insertAfterLastImport(
        line, _removeToolAddedLinesFromSource(file.readAsStringSync())));
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

  void patchForCfe() {
    final partName = p.basename(toolOutputPath);
    final line = "import augment '$partName'; $_addedMarker\n";

    final file = File(path);
    file.writeAsStringSync(
        line + _removeToolAddedLinesFromSource(file.readAsStringSync()));

    final toolOutputFile = File(toolOutputPath);
    toolOutputFile.writeAsStringSync(toolOutputFile
        .readAsStringSync()
        .replaceAll('part of ', 'augment library '));
  }

  void revert() {
    final file = File(path);
    file.writeAsStringSync(_resetCacheBusters(
        _removeToolAddedLinesFromSource(file.readAsStringSync())));
    final toolOutputFile = File(toolOutputPath);
    if (toolOutputFile.existsSync()) toolOutputFile.deleteSync();
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
  bool bustCaches() {
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
      }
    }
    return cacheBusterFound;
  }

  String _resetCacheBusters(String source) =>
      source.replaceAll(_cacheBusterRegexp, _cacheBusterString);
}
