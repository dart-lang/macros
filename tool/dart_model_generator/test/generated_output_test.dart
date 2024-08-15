// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:generate_dart_model/generate_dart_model.dart'
    as dart_model_generator;
import 'package:test/test.dart';

void main() {
  for (final package in ['dart_model', 'macro_service']) {
    test('$package output is up to date', () {
      final expected = dart_model_generator.generate(
          File('../../schemas/$package.schema.json').readAsStringSync(),
          directives: switch (package) {
            'dart_model' => const ["import 'json_buffer.dart' show LazyMap;"],
            'macro_service' => const [
                "import 'package:dart_model/dart_model.dart';"
              ],
            _ => const [],
          },
          dartModelJson:
              File('../../schemas/dart_model.schema.json').readAsStringSync());
      final actual = File('../../pkgs/$package/lib/src/$package.g.dart')
          .readAsStringSync();
      // TODO: On windows we get carriage returns, which makes this fail
      // without ignoring white space. In theory this shouldn't happen.
      expect(actual, equalsIgnoringWhitespace(expected), reason: '''
Output is not up to date. Please run

  dart tool/dart_model_generator/bin/main.dart

in repo root.
''');
    });
  }
}
