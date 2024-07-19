// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:macro/macro.dart';
import 'package:macro_service/macro_service.dart';

/// Runs macros, connecting them to a macro host.
///
/// TODO(davidmorgan): handle shutdown and dispose.
/// TODO(davidmorgan): split to multpile implementations depending on
/// transport used to connect to host.
class MacroClient {
  final RemoteMacroHost host = RemoteMacroHost();
  final Iterable<Macro> macros;
  final Socket socket;

  MacroClient._(this.macros, this.socket) {
    // TODO(davidmorgan): negotiation about protocol version goes here.

    // Tell the host which macros are in this bundle.
    for (final macro in macros) {
      final request = MacroStartedRequest(macroDescription: macro.description);
      // TODO(davidmorgan): currently this is JSON with one request per line,
      // switch to binary.
      socket.writeln(json.encode(request.node));
    }

    const Utf8Decoder()
        .bind(socket)
        .transform(const LineSplitter())
        .listen(_handleRequest);
  }

  /// Runs [macros] for the host at [endpoint].
  static Future<MacroClient> run(
      {required HostEndpoint endpoint, required Iterable<Macro> macros}) async {
    final socket = await Socket.connect('localhost', endpoint.port);
    return MacroClient._(macros, socket);
  }

  void _handleRequest(String request) async {
    // TODO(davidmorgan): support more than one request type.
    final augmentRequest =
        AugmentRequest.fromJson(json.decode(request) as Map<String, Object?>);
    // TODO(davidmorgan): support multiple macros.
    final response = await macros.single.augment(host, augmentRequest);
    _send(response.node);
  }

  void _send(Map<String, Object?> node) {
    // TODO(davidmorgan): currently this is JSON with one request per line,
    // switch to binary.
    socket.writeln(json.encode(node));
  }
}

/// [Host] that is connected to a remote macro host.
class RemoteMacroHost implements Host {}
