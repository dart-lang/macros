// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:dart_model/dart_model.dart';

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
  Future<BuiltMacroBundle> build(
      File packageConfig, Iterable<QualifiedName> macroImplementations) async {
    final script = createBootstrap(macroImplementations.toList());

    return await MacroBuild(packageConfig, script).build();
  }

  /// Creates the entrypoint script for [macros].
  static String createBootstrap(List<QualifiedName> macros) {
    final script = StringBuffer();
    for (var i = 0; i != macros.length; ++i) {
      final macro = macros[i];
      // TODO(davidmorgan): pick non-clashing prefixes.
      script.writeln("import '${macro.uri}' as m$i;");
    }
    script.write('''
import 'dart:convert';

import 'package:_macro_client/macro_client.dart';
import 'package:macro_service/macro_service.dart';

void main(List<String> arguments) {
   MacroClient.run(
      endpoint: HostEndpoint.fromJson(json.decode(arguments[0])),
      macros: [''');
    for (var i = 0; i != macros.length; ++i) {
      final macro = macros[i];
      script.write('m$i.${macro.name}()');
      if (i != macros.length - 1) script.write(', ');
    }
    script.writeln(']);');
    script.writeln('}');
    return script.toString();
  }
}

/// A bundle of one or more macros that's ready to execute.
class BuiltMacroBundle {
  // TODO(davidmorgan): other formats besides executable.
  final String executablePath;

  BuiltMacroBundle(this.executablePath);
}

/// A single build.
class MacroBuild {
  final File packageConfig;
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
    scriptFile.parent.createSync(recursive: true);
    scriptFile.writeAsStringSync(script.toString());

    final targetPackageConfig =
        File.fromUri(workspace.uri.resolve('.dart_tool/package_config.json'));
    targetPackageConfig.parent.createSync(recursive: true);
    targetPackageConfig
        .writeAsStringSync(_makePackageConfigAbsolute(packageConfig));

    // See package:analyzer/src/summary2/kernel_compilation_service.dart for an
    // example of compiling macros using the frontend server.
    //
    // For now just use the command line.

    final result = Process.runSync('dart', ['compile', 'exe', 'bin/main.dart'],
        workingDirectory: workspace.path);
    if (result.exitCode != 0) {
      throw StateError('Compile failed: ${result.stderr}');
    }

    return BuiltMacroBundle(
        File.fromUri(scriptFile.parent.uri.resolve('main.exe')).path);
  }

  /// Returns the contents of [pubspec] with relative paths replaced to
  /// absolute paths, so the pubspec will work from any location.
  String _makePackageConfigAbsolute(File pubspec) {
    final root = pubspec.parent.parent.absolute.uri;
    return pubspec
        .readAsStringSync()
        .replaceAll('"rootUri": "../', '"rootUri": "$root');
  }
}
