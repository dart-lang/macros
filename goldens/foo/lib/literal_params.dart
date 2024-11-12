// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_test_macros/literal_params.dart';

@LiteralParams(
  anInt: 7,
  aNum: 8.0,
  aDouble: 9.0,
  aString: '10',
  anObject: Bar(a: true, b: false),
  ints: [11, 12],
  nums: [13.0, 14],
  doubles: [15.0, 16],
  strings: ['17', 'eighteen'],
  objects: [19, Bar(a: true, b: false)],
)
class Foo {}

class Bar {
  final bool? a;
  final bool? b;

  const Bar({this.a, this.b});
}

void main() {}
