// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_test_macros/query_class.dart';

@QueryClass()
@Annotation(aBool: true, anInt: 23)
class Foo {}

class Annotation {
  final bool aBool;
  final int anInt;

  const Annotation({required this.aBool, required this.anInt});
}
