// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:benchmark_generator/json_encodable/input_generator.dart';
import 'package:benchmark_generator/workspace.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.length != 3) {
    print('''
Creates packages to benchmark macro performance. Usage:

  dart run benchmark_generator <workspace name> <macro|manual|none> <# libraries>
''');
    exit(1);
  }

  final workspaceName = arguments[0];
  final strategy = Strategy.values.where((e) => e.name == arguments[1]).single;
  final libraryCount = int.parse(arguments[2]);

  final workspace = Workspace(workspaceName);
  print('Creating under: ${workspace.directory.path}');
  final inputGenerator = JsonEncodableInputGenerator(
    fieldsPerClass: 100,
    classesPerLibrary: 10,
    librariesPerCycle: libraryCount,
    strategy: strategy,
  );
  inputGenerator.generate(workspace);
}
