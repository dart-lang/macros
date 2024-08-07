// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_model/dart_model.dart';
import 'package:macro_service/macro_service.dart';

/// Serves a [MacroService].
class MacroServer {
  final MacroService service;
  final HostEndpoint endpoint;
  final ServerSocket serverSocket;

  // TODO(davidmorgan): track which socket corresponds to which macro(s).
  Socket? _lastSocket;

  MacroServer._(this.service, this.endpoint, this.serverSocket) {
    serverSocket.forEach(_handleConnection);
  }

  /// Serves [service].
  ///
  /// TODO(davidmorgan): other transports besides TCP/IP.
  static Future<MacroServer> serve({required MacroService service}) async {
    final serverSocket = await ServerSocket.bind('localhost', 0);
    return MacroServer._(
        service, HostEndpoint(port: serverSocket.port), serverSocket);
  }

  void sendToMacro(QualifiedName name, AugmentRequest request) async {
    _lastSocket!.writeln(json.encode(request.node));
  }

  void _handleConnection(Socket socket) {
    _lastSocket = socket;
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
