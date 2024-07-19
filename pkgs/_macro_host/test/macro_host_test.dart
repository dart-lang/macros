// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:isolate';

import 'package:_macro_host/macro_host.dart';
import 'package:dart_model/dart_model.dart';
import 'package:macro_service/macro_service.dart';
import 'package:test/test.dart';

void main() {
  group(MacroHost, () {
    test('hosts a macro', () async {
      final service = TestMacroHostService();
      final host = await MacroHost.serve(service: service);

      final macroName = QualifiedName(
          'package:_test_macros/declare_x_macro.dart#DeclareXImplementation');
      final packageConfig = Isolate.packageConfigSync!;

      expect(host.isMacro(packageConfig, macroName), true);
      expect(await host.queryMacroPhases(packageConfig, macroName), {2});

      expect(
          await host.augment(macroName, AugmentRequest(phase: 2)),
          AugmentResponse(
              augmentations: [Augmentation(code: 'int get x => 3;')]));
    });
  });
}

class TestMacroHostService implements MacroService {
  @override
  Future<Object> handle(Object request) async {
    return Object();
  }
}
