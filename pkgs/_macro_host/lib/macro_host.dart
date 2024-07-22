// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_macro_builder/macro_builder.dart';
import 'package:_macro_runner/macro_runner.dart';
import 'package:_macro_server/macro_server.dart';
import 'package:macro_service/macro_service.dart';

class MacroHost {
  final MacroServer macroServer;
  final MacroBuilder macroBuilder = MacroBuilder();
  final MacroRunner macroRunner = MacroRunner();
  late final HostEndpoint hostEndpoint;

  MacroHost._(this.macroServer, this.hostEndpoint);

  static Future<MacroHost> serve({required MacroHostService service}) async {
    final server = MacroServer(service: service);
    final endpoint = await server.serve();
    return MacroHost._(server, endpoint);
  }

  // TODO(davidmorgan): methods for integration with analyzer+CFE go here:
  // check if an annotation is linked to a macro, run a macro and ask it to
  // produce augmentations.
}
