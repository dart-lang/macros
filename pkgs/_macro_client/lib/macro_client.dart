// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:macro/macro.dart';
import 'package:macro_service/macro_service.dart';

/// Runs macros, connecting them to a macro host.
class MacroClient {
  final Iterable<Macro> macros;
  final Socket socket;

  MacroClient._(this.macros, this.socket) {
    // TODO(davidmorgan): negotiation about protocol version goes here.

    // Tell the host which macros are in this bundle.
    for (final macro in macros) {
      _send(MacroStartedRequest(macroDescription: macro.description).node);
    }
  }

  /// Runs [macros] for the host at [endpoint].
  static Future<MacroClient> run(
      {required HostEndpoint endpoint, required Iterable<Macro> macros}) async {
    final socket = await Socket.connect('localhost', endpoint.port);
    return MacroClient._(macros, socket);
  }

  void _send(Map<String, Object?> node) {
    // TODO(davidmorgan): currently this is JSON with one request per line,
    // switch to binary.
    socket.writeln(json.encode(node));
  }
}
