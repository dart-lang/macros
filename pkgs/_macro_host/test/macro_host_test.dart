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
    test('hosts a macro, receives augmentations', () async {
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

    test('hosts a macro, responds to queries', () async {
      final service = TestMacroHostService();
      final host = await MacroHost.serve(service: service);

      final macroName = QualifiedName(
          'package:_test_macros/query_class.dart#QueryClassImplementation');
      final packageConfig = File.fromUri(Isolate.packageConfigSync!);

      expect(host.isMacro(packageConfig, macroName), true);
      expect(await host.queryMacroPhases(packageConfig, macroName), {3});

      expect(
          await host.augment(macroName, AugmentRequest(phase: 2)),
          AugmentResponse(augmentations: [
            Augmentation(code: '// {uris: {package:foo/foo.dart: {}}}')
          ]));
    });
  });
}

class TestMacroHostService implements HostService {
  @override
  Future<Response?> handle(MacroRequest request) async {
    if (request.type == MacroRequestType.queryRequest) {
      return Response.queryResponse(QueryResponse(
          model: Model(uris: {'package:foo/foo.dart': Library()})));
    }
    return null;
  }
}
