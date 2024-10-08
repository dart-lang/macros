// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_test_macros/query_class.dart';

@QueryClass()
class Foo {
  final int bar = 3;

  Foo.construct(int x, {required int y});
  Foo.construct2(int x, [String? y]);

  void method(int x, {int? y}) {}
  Bar? method2(int x, [String? y]) {
    return null;
  }
}

@QueryClass()
class Bar {
  final int bar = 4;
}
