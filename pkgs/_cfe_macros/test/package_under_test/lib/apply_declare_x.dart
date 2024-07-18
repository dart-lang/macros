// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_test_macros/declare_x_macro.dart';

@DeclareX()
class ClassWithMacroApplied {}

void main() {
  ClassWithMacroApplied().x;
}
