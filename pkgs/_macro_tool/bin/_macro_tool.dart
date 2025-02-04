// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:_macro_tool/main.dart' as macro_tool;

Future<void> main(List<String> arguments) async {
  exit(await macro_tool.main(arguments));
}
