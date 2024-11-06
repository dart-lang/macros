// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_macro_tool/main.dart' as macro_tool;
import 'package:test/test.dart';

void main() {
  tearDown(() async {
    await macro_tool.main([
      '--workspace=test/package_under_test',
      '--packageConfig=../../.dart_tool/package_config.json',
      'revert',
    ]);
  });

  test('apply macros with analyzer then run', () async {
    expect(
        await macro_tool.main([
          '--workspace=test/package_under_test',
          '--packageConfig=../../.dart_tool/package_config.json',
          '--script=test/package_under_test/lib/apply_declare_x.dart',
          'apply',
          'patch_for_cfe',
          'run',
        ]),
        // The script exit code is the macro-generated value: 3.
        3);
  });

  test('apply macros with CFE then run', () async {
    expect(
        await macro_tool.main([
          '--workspace=test/package_under_test',
          '--packageConfig=../../.dart_tool/package_config.json',
          '--script=test/package_under_test/lib/apply_declare_x.dart',
          '--host=cfe',
          'apply',
          'patch_for_cfe',
          'run',
        ]),
        // The script exit code is the macro-generated value: 3.
        3);
  });
}
