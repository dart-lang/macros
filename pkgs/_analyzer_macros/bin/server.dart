// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:_analyzer_macros/macro_implementation.dart';
import 'package:analysis_server/starter.dart';
import 'package:analyzer/src/summary2/macro_injected_impl.dart' as injected;
import 'package:macro_service/macro_service.dart';

/// Analysis server with `dart_model` implementation injected.
///
/// Run with your IDE by compiling and placing in the SDK your IDE is using,
/// for example:
///
/// dart compile kernel bin/server.dart
/// cp bin/server.dill ~/opt/dart-sdk-be/bin/snapshots/analysis_server.dart.snapshot
///
/// Then restart, VSCode: Ctrl+Shift+P, Restart Analysis Server.
///
/// Only works for one path, see `packageConfig` path hardcoded below.
void main(List<String> args) async {
  final home = Platform.environment['HOME']!;
  injected.macroImplementation = await AnalyzerMacroImplementation.start(
      protocol: Protocol(
          encoding: ProtocolEncoding.binary, version: ProtocolVersion.macros1),
      // TODO(davidmorgan): this needs to come from the analyzer, not be
      // hardcoded.
      packageConfig:
          Uri.file('$home/git/macros/.dart_tool/package_config.json'));

  var starter = ServerStarter();
  starter.start(args);
}
