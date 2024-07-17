// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:macro_service/macro_service.dart';

class MacroServer {
  final MacroHostService service;

  MacroServer({required this.service});

  Future<HostEndpoint> serve() async {
    // TODO(davidmorgan): actually serve something.
    return HostEndpoint(port: 12345);
  }
}
