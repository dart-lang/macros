// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:_test_macros/declare_x_macro.dart';

@DeclareX()
class ClassWithMacroApplied {
  int CACHEBUSTER = 1;
}

void main() {
  final code = ((ClassWithMacroApplied() as dynamic).x);
  print(code);
  exit(code);
}
