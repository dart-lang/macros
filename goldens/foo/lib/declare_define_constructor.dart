import augment 'declare_define_constructor.dart.macro_tool_output'; // added by macro_tool
// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_test_macros/declare_define_constructor.dart';

@DeclareDefineConstructor()
class A {}

void main() => print(A.x());
