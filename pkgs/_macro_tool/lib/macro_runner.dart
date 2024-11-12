// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'source_file.dart';

/// Runs macros.
abstract interface class MacroRunner {
  /// Source files in the workspace.
  List<SourceFile> get sourceFiles;

  /// Runs macros in all files in the workspace, [sourceFiles].
  ///
  /// Returns augmentations and errors for each file.
  ///
  /// [injectImplementation] controls whether the `dart_model` macro
  /// implementation is injected. Otherwise, the v1 implementation is used.
  Future<WorkspaceResult> run({bool injectImplementation = true});

  /// Notifies the host that a file changed.
  ///
  /// Call this on changed files then call [run] again for an incremental run.
  void notifyChange(String sourcePath);
}

/// [MacroRunner] result for the whole workspace.
class WorkspaceResult {
  /// Results per file.
  List<FileResult> fileResults;

  /// Time taken to produce the first file result.
  Duration firstResultAfter;

  /// Time taken to produce all results.
  Duration lastResultAfter;

  WorkspaceResult({
    required this.fileResults,
    required this.firstResultAfter,
    required this.lastResultAfter,
  });

  /// Errors from all [FileResult]s.
  List<String> get allErrors => [
    for (final result in fileResults) ...result.errors,
  ];
}

/// [MacroRunner] result for one file.
class FileResult {
  /// The file.
  final SourceFile sourceFile;

  /// Macro augmentation output, or `null` if there was no output.
  final String? output;

  /// Errors for this file.
  final List<String> errors;

  FileResult({
    required this.sourceFile,
    required this.output,
    required this.errors,
  });
}
