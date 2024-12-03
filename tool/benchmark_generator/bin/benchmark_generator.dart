// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:benchmark_generator/input_generator.dart';
import 'package:benchmark_generator/workspace.dart';
import 'package:dart_model/dart_model.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.length < 3) {
    print('''
Creates packages to benchmark macro performance.

Available macro names: BuiltValue, JsonCodable

Usage:

  dart run benchmark_generator <workspace name> <# libraries> <macro name> [additional macro names]
''');
    exit(1);
  }

  final workspaceName = arguments[0];
  final libraryCount = int.parse(arguments[1]);

  final macroNames = arguments.skip(2).toList();
  final macros = <QualifiedName>[
    for (final macroName in macroNames)
      switch (macroName) {
        'BuiltValue' => QualifiedName(
          uri: 'package:_test_macros/built_value.dart',
          name: 'BuiltValue',
        ),
        'JsonCodable' => QualifiedName(
          uri: 'package:_test_macros/json_codable.dart',
          name: 'JsonCodable',
        ),
        _ => throw ArgumentError(macroName),
      },
  ];

  final workspace = Workspace(workspaceName);
  print('Creating under: ${workspace.directory.path}');
  final inputGenerator = ClassesAndFieldsInputGenerator(
    macros: macros,
    fieldsPerClass: 100,
    classesPerLibrary: 10,
    librariesPerCycle: libraryCount,
  );
  inputGenerator.generate(workspace);
}
