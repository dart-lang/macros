// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:generate_dart_model/definitions.dart';
import 'package:test/test.dart';

void main() {
  for (final generationResult in schemas.generate()) {
    test('${generationResult.path} is up to date', () {
      final expected = generationResult.content;
      final actual = File('../../${generationResult.path}').readAsStringSync();
      // TODO: On windows we get carriage returns, which makes this fail
      // without ignoring white space. In theory this shouldn't happen.
      expect(
        actual,
        equalsIgnoringWhitespace(expected),
        reason: '''
Output is not up to date. Please run

  dart tool/dart_model_generator/bin/main.dart

in repo root.
''',
      );
    });
  }
}
