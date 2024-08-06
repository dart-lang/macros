// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:isolate';

import 'package:_macro_builder/macro_builder.dart';
import 'package:_macro_runner/macro_runner.dart';
import 'package:dart_model/dart_model.dart';
import 'package:macro_service/macro_service.dart';
import 'package:test/test.dart';

void main() {
  group(MacroRunner, () {
    test('runs macros', () async {
      final builder = MacroBuilder();
      final bundle =
          await builder.build(File.fromUri(Isolate.packageConfigSync!), [
        QualifiedName(
            'package:_test_macros/declare_x_macro.dart#DeclareXImplementation')
      ]);

      final serverSocket = await ServerSocket.bind('localhost', 0);

      final runner = MacroRunner();
      runner.run(
          macroBundle: bundle, endpoint: HostEndpoint(port: serverSocket.port));

      expect(
          serverSocket.first.timeout(const Duration(seconds: 10)), completes);
    });
  });
}
