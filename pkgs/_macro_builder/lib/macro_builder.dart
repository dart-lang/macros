// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:dart_model/dart_model.dart';

import 'src/bootstrap.dart';

/// Builds macros.
///
/// TODO(davidmorgan): add a way to clean up generated files and built output.
class MacroBuilder {
  /// Builds an executable from user-written macro code.
  ///
  /// Each `QualifiedName` in [macroImplementations] must point to a class that
  /// implements `Macro` from `package:macro`.
  ///
  /// The [packageConfig] must include the macros and all their deps.
  ///
  /// TODO(davidmorgan): figure out builder lifecycle: is it one builder per
  /// host, one per workspace, one per build?
  /// TODO(davidmorgan): replace `File` packageConfig with a concept of version
  /// solve and workspace.
  /// TODO(davidmorgan): support for multi-root workspaces.
  /// TODO(davidmorgan): support (or decide not to support) in-memory overlay
  /// filesystems.
  Future<BuiltMacroBundle> build(
      Uri packageConfig, Iterable<QualifiedName> macroImplementations) async {
    final script = createBootstrap(macroImplementations.toList());

    return await MacroBuild(packageConfig, script).build();
  }
}

/// A bundle of one or more macros that's ready to execute.
class BuiltMacroBundle {
  // TODO(davidmorgan): other formats besides executable.
  final String executablePath;

  BuiltMacroBundle(this.executablePath);
}

/// A single build.
///
/// TODO(davidmorgan): split to interface+implementations as we add different
/// ways to build.
class MacroBuild {
  final Uri packageConfig;
  final String script;
  final Directory workspace =
      Directory.systemTemp.createTempSync('macro_builder');

  /// Creates a build for [script] with [packageConfig], which must have all
  /// the needed deps.
  MacroBuild(this.packageConfig, this.script);

  /// Runs the build.
  ///
  /// Throws on failure to build.
  Future<BuiltMacroBundle> build() async {
    final scriptFile = File.fromUri(workspace.uri.resolve('bin/main.dart'));
    await scriptFile.create(recursive: true);
    await scriptFile.writeAsString(script.toString());

    final targetPackageConfig =
        File.fromUri(workspace.uri.resolve('.dart_tool/package_config.json'));
    targetPackageConfig.parent.createSync(recursive: true);
    targetPackageConfig
        .writeAsStringSync(_makePackageConfigAbsolute(packageConfig));

    // See package:analyzer/src/summary2/kernel_compilation_service.dart for an
    // example of compiling macros using the frontend server.
    //
    // For now just use the command line.

    final result = Process.runSync(
        // TODO(davidmorgan): this is wrong if run from an AOT-compiled
        // executable.
        Platform.resolvedExecutable,
        ['compile', 'exe', 'bin/main.dart', '--output=bin/main.exe'],
        workingDirectory: workspace.path);
    if (result.exitCode != 0) {
      throw StateError('Compile failed: ${result.stderr}');
    }

    return BuiltMacroBundle(
        File.fromUri(scriptFile.parent.uri.resolve('main.exe')).path);
  }

  /// Returns the contents of [packageConfig] with relative paths replaced to
  /// absolute paths, so the pubspec will work from any location.
  String _makePackageConfigAbsolute(Uri packageConfig) {
    final file = File.fromUri(packageConfig);
    final root = file.parent.parent.absolute.uri;
    return file
        .readAsStringSync()
        .replaceAll('"rootUri": "../', '"rootUri": "$root');
  }
}
