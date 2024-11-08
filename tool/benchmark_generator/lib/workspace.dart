// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:isolate';

class Workspace {
  final String name;

  Directory get directory => Directory.fromUri(
      Isolate.packageConfigSync!.resolve('../goldens/foo/lib/generated/$name'));

  Workspace(this.name) {
    if (directory.existsSync()) directory.deleteSync(recursive: true);
    directory.createSync(recursive: true);
  }

  void write(String path, {required String source}) {
    final file = File.fromUri(directory.uri.resolve('$path'));
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(source);
  }
}
