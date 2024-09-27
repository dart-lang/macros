// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';

/// Creates the entrypoint script for [macros].
String createBootstrap(List<QualifiedName> macros) {
  final script = StringBuffer();
  for (var i = 0; i != macros.length; ++i) {
    final macro = macros[i];
    // TODO(davidmorgan): pick non-clashing prefixes.
    script.writeln("import '${macro.uri}' as m$i;");
  }
  script.write('''
import 'dart:convert' as convert;

import 'package:_macro_client/macro_client.dart' as macro_client;
import 'package:macro_service/macro_service.dart' as macro_service;

void main(List<String> arguments) {
   macro_client.MacroClient.run(
      endpoint: macro_service.HostEndpoint.fromJson(
        convert.json.decode(arguments[0])),
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
