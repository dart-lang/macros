// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:isolate';

import 'package:_macro_builder/macro_builder.dart';
import 'package:dart_model/dart_model.dart';
import 'package:test/test.dart';

void main() {
  group(MacroBuilder, () {
    test('bootstrap matches golden', () async {
      final script = MacroBuilder.createBootstrap([
        QualifiedName('package:_test_macros/declare_x_macro.dart#DeclareX'),
        QualifiedName('package:_test_macros/declare_y_macro.dart#DeclareY'),
        QualifiedName(
            'package:_more_macros/other_macro.dart#OtherMacroImplementation')
      ]);

      expect(script, '''
import 'package:_test_macros/declare_x_macro.dart' as m0;
import 'package:_test_macros/declare_y_macro.dart' as m1;
import 'package:_more_macros/other_macro.dart' as m2;
import 'dart:convert';

import 'package:_macro_client/macro_client.dart';
import 'package:macro_service/macro_service.dart';

void main(List<String> arguments) {
   MacroClient.run(
      endpoint: HostEndpoint.fromJson(json.decode(arguments[0])),
      macros: [m0.DeclareX(), m1.DeclareY(), m2.OtherMacroImplementation()]);
}
''');
    });

    test('builds macros', () async {
      final builder = MacroBuilder();

      final bundle =
          await builder.build(File.fromUri(Isolate.packageConfigSync!), [
        QualifiedName(
            'package:_test_macros/declare_x_macro.dart#DeclareXImplementation')
      ]);

      expect(File(bundle.executablePath).existsSync(), true);
    });
  });
}
