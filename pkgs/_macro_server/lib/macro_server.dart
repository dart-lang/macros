// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:dart_model/dart_model.dart';
import 'package:macro_service/macro_service.dart';

/// Serves a [MacroService].
class MacroServer {
  final Protocol protocol;
  final HostService service;
  final HostEndpoint endpoint;
  final ServerSocket serverSocket;

  // TODO(davidmorgan): track which socket corresponds to which macro(s).
  Socket? _lastSocket;

  // TODO(davidmorgan): properly track requests and responses.
  Completer<Response>? _responseCompleter;

  MacroServer._(this.protocol, this.service, this.endpoint, this.serverSocket) {
    serverSocket.forEach(_handleConnection);
  }

  /// Serves [service].
  ///
  /// TODO(davidmorgan): other transports besides TCP/IP.
  static Future<MacroServer> serve({
    // TODO(davidmorgan): this should be negotiated per client, not set for
    // each server.
    required Protocol protocol,
    required HostService service,
  }) async {
    final serverSocket = await ServerSocket.bind('localhost', 0);
    return MacroServer._(
        protocol, service, HostEndpoint(port: serverSocket.port), serverSocket);
  }

  Future<Response> sendToMacro(QualifiedName name, HostRequest request) async {
    _responseCompleter = Completer<Response>();
    protocol.send(_lastSocket!.add, request.node);
    return _responseCompleter!.future;
  }

  void _handleConnection(Socket socket) {
    _lastSocket = socket;
    protocol.decode(socket).forEach((jsonData) {
      final request = MacroRequest.fromJson(jsonData);
      if (request.type.isKnown) {
        // Each query is handled and responded to in a new query scope.
        Scope.query.runAsync(() async => service
            .handle(request)
            .then((response) => protocol.send(socket.add, response.node)));
      }
      final response = Response.fromJson(jsonData);
      if (response.type.isKnown) {
        _responseCompleter!.complete(response);
        _responseCompleter = null;
      }
    });
  }
}
