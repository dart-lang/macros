// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_test_macros/built_value.dart';
import 'package:test/test.dart';

void main() {
  group('Empty class', () {
    test('instantiation, builder, rebuild, comparison', () {
      final empty = Empty();
      final empty2 = empty.rebuild((b) {});
      expect(empty2, empty);

      // analyzer: The function 'EmptyBuilder' isn't defined.
      // final emptyBuilder = EmptyBuilder();
      // final empty3 = emptyBuilder.build();
      // expect(empty3, empty);
    });
  });
}

@BuiltValue()
class Empty {}
