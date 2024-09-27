// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:isolate';

import 'package:_macro_builder/macro_builder.dart';
import 'package:_macro_builder/src/bootstrap.dart';
import 'package:dart_model/dart_model.dart';
import 'package:test/test.dart';

void main() {
  group(MacroBuilder, () {
    test('bootstrap matches golden', () async {
      final script = createBootstrap([
        QualifiedName(
            uri: 'package:_test_macros/declare_x_macro.dart', name: 'DeclareX'),
        QualifiedName(
            uri: 'package:_test_macros/declare_y_macro.dart', name: 'DeclareY'),
        QualifiedName(
            uri: 'package:_more_macros/other_macro.dart',
            name: 'OtherMacroImplementation')
      ]);

      expect(script, '''
import 'package:_test_macros/declare_x_macro.dart' as m0;
import 'package:_test_macros/declare_y_macro.dart' as m1;
import 'package:_more_macros/other_macro.dart' as m2;
import 'dart:convert' as convert;

import 'package:_macro_client/macro_client.dart' as macro_client;
import 'package:macro_service/macro_service.dart' as macro_service;

void main(List<String> arguments) {
   macro_client.MacroClient.run(
      endpoint: macro_service.HostEndpoint.fromJson(
        convert.json.decode(arguments[0])),
      macros: [m0.DeclareX(), m1.DeclareY(), m2.OtherMacroImplementation()]);
}
''');
    });

    test('builds macros', () async {
      final builder = MacroBuilder();

      final bundle = await builder.build(Isolate.packageConfigSync!, [
        QualifiedName(
            uri: 'package:_test_macros/declare_x_macro.dart',
            name: 'DeclareXImplementation')
      ]);

      expect(File(bundle.executablePath).existsSync(), true);
    });
  });
}
