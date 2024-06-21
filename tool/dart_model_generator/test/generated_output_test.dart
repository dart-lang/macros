// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:generate_dart_model/generate_dart_model.dart'
    as dart_model_generator;
import 'package:test/test.dart';

void main() {
  test('output is up to date', () {
    final expected = dart_model_generator.generate(
        File('../../schemas/dart_model.schema.json').readAsStringSync());
    final actual = File('../../pkgs/dart_model/lib/src/dart_model.g.dart')
        .readAsStringSync();
    expect(actual, expected, reason: '''
Output is not up to date. Please run

  dart tool/dart_model_generator/bin/main.dart

in repo root.
''');
  });
}
