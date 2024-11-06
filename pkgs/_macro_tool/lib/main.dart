// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

import 'analyzer_macro_runner.dart';
import 'cfe_macro_runner.dart';
import 'macro_tool.dart';

final argParser = ArgParser()
  ..addOption('host',
      defaultsTo: 'analyzer', help: 'The macro host: "analyzer" or "cfe".')
  ..addOption('workspace', help: 'Path to workspace.')
  ..addOption('packageConfig', help: 'Path to package config.')
  ..addOption('script', help: 'Path to script.')
  ..addOption('benchmark-iterations',
      defaultsTo: '5', help: 'Benchmark iterations.');

Future<int> main(List<String> arguments) async {
  final args = argParser.parse(arguments);
  final commands = args.rest;

  final host = HostOption.forString(args['host'] as String?);
  final workspace = args['workspace'] as String?;
  final packageConfig = args['packageConfig'] as String?;
  final script = args['script'] as String?;

  if (host == null ||
      workspace == null ||
      packageConfig == null ||
      commands.isEmpty) {
    print('''
Runs a Dart script with `dart_model` macros.

Usage: after the options, pass a list of commands. See `README.md` for
commands and examples.

${argParser.usage}''');
    return 1;
  }

  final canonicalizedPackageConfig = p.canonicalize(packageConfig);
  final canonicalizedWorkspace = p.canonicalize(workspace);

  final tool = MacroTool(
    macroRunner: host == HostOption.analyzer
        ? AnalyzerMacroRunner(
            packageConfigPath: canonicalizedPackageConfig,
            workspacePath: canonicalizedWorkspace,
          )
        : CfeMacroRunner(
            packageConfigPath: canonicalizedPackageConfig,
            workspacePath: canonicalizedWorkspace,
          ),
    packageConfigPath: canonicalizedPackageConfig,
    workspacePath: canonicalizedWorkspace,
    benchmarkIterations: int.parse(args['benchmark-iterations']),
    scriptPath: script == null ? null : p.canonicalize(script),
  );

  var exitCode = 0;
  for (final command in commands) {
    switch (command) {
      case 'apply':
        await tool.apply();
      case 'patch_for_analyzer':
        tool.patchForAnalyzer();
      case 'patch_for_cfe':
        tool.patchForCfe();
      case 'run':
        exitCode = await tool.run();
      case 'revert':
        tool.revert();
      case 'benchmark_apply':
        await tool.benchmarkApply();
      case 'benchmark_analyze':
        await tool.benchmarkAnalyze();
      case 'bust_caches':
        tool.bustCaches();
      case 'watch':
        await tool.watch();
      default:
        print('Unknown command: $command');
        return 1;
    }
  }

  return exitCode;
}

enum HostOption {
  analyzer,
  cfe;

  static HostOption? forString(String? option) => switch (option) {
        'analyzer' => HostOption.analyzer,
        'cfe' => HostOption.cfe,
        _ => throw ArgumentError('Not a valid host: $option'),
      };
}
