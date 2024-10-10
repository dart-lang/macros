// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:_macro_tool/macro_tool.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;

final argParser = ArgParser()
  ..addOption('host',
      defaultsTo: 'analyzer', help: 'The macro host: "analyzer" or "cfe".')
  ..addOption('workspace', help: 'Path to workspace.')
  ..addOption('packageConfig', help: 'Path to package config.')
  ..addOption('script', help: 'Path to script.')
  ..addFlag('skip-cleanup');

Future<void> main(List<String> arguments) async {
  final args = argParser.parse(arguments);

  final host = HostOption.forString(args['host'] as String?);
  final workspace = args['workspace'] as String?;
  final packageConfig = args['packageConfig'] as String?;
  final script = args['script'] as String?;

  if (host == null ||
      workspace == null ||
      packageConfig == null ||
      script == null) {
    print('''
Runs a Dart script with `dart_model` macros.

${argParser.usage}''');
    exit(1);
  }

  final tool = MacroTool(
      host: host,
      workspacePath: p.canonicalize(workspace),
      packageConfigPath: p.canonicalize(packageConfig),
      scriptPath: p.canonicalize(script),
      skipCleanup: args['skip-cleanup'] as bool);
  await tool.run();
}
