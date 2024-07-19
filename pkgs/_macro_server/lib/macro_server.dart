// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:macro_service/macro_service.dart';

/// Serves a [MacroService].
class MacroServer {
  final MacroService service;
  final HostEndpoint endpoint;
  final ServerSocket serverSocket;

  MacroServer._(this.service, this.endpoint, this.serverSocket) {
    _handleConnections();
  }

  /// Serves [service].
  ///
  /// TODO(davidmorgan): other transports besides TCP/IP.
  static Future<MacroServer> serve({required MacroService service}) async {
    final serverSocket = await ServerSocket.bind('localhost', 0);
    return MacroServer._(
        service, HostEndpoint(port: serverSocket.port), serverSocket);
  }

  void _handleConnections() {
    serverSocket.forEach(_handleConnection);
  }

  void _handleConnection(Socket socket) {
    // TODO(davidmorgan): currently this is JSON with one request per line,
    // switch to binary.
    socket
        .cast<List<int>>()
        .transform(const Utf8Decoder())
        .transform(const LineSplitter())
        .forEach((line) {
      // TODO(davidmorgan): this only works because there is just one request
      // type! Add the request type on the wire to differentiate.
      final message = MacroStartedRequest.fromJson(
          json.decode(line) as Map<String, Object?>);
      service.handle(message as Object);
    });
  }
}
