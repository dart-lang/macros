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

  final List<_Connection> _connections = [];

  /// Emits an event whenever a macro connects and sends its description.
  final StreamController<void> _macroDescriptionBecomesKnown =
      StreamController.broadcast();

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

  /// Sends to the macro identified by `request#macroAnnotation`.
  ///
  /// If no such macro is connected, repeatedly waits [timeout] for a new
  /// macro to connect and checks again.
  ///
  /// Throws [TimeoutException] if no such macro connects in the time allowed.
  Future<Response> sendToMacro(HostRequest request,
      {Duration timeout = const Duration(seconds: 5)}) async {
    _Connection? connection;
    while (true) {
      // Look up the connection with the macro corresponding to `annotation`.
      connection = _connections
          .where((c) => c.descriptions.any(
              (d) => d.annotation.string == request.macroAnnotation.string))
          .singleOrNull;
      // If it's found: done.
      if (connection != null) break;
      // Not found, wait [timeout] then recheck. Throws `StateError` on
      // timeout.
      await _macroDescriptionBecomesKnown.stream.first.timeout(timeout);
      continue;
    }
    protocol.send(connection.socket.add, request.node);
    return connection.responses.where((r) => r.requestId == request.id).first;
  }

  void _handleConnection(Socket socket) {
    final connection = _Connection(socket);
    _connections.add(connection);
    protocol.decode(socket).forEach((jsonData) {
      final request = MacroRequest.fromJson(jsonData);
      if (request.type.isKnown) {
        if (request.type == MacroRequestType.macroStartedRequest) {
          connection.descriptions
              .add(request.asMacroStartedRequest.macroDescription);
          _macroDescriptionBecomesKnown.add(null);
        }
        // Each query is handled and responded to in a new query scope.
        Scope.query.runAsync(() async => service
            .handle(request)
            .then((response) => protocol.send(socket.add, response.node)));
      }
      final response = Response.fromJson(jsonData);
      if (response.type.isKnown) {
        connection._responsesController.add(response);
      }
    });
  }
}

/// A connected macro bundle.
class _Connection {
  /// The socket the macro bundle is connect on.
  final Socket socket;

  /// The macros available in the macro bundle; starts empty, filled one amcro
  /// at a time.
  final List<MacroDescription> descriptions = [];

  final StreamController<Response> _responsesController =
      StreamController.broadcast();

  /// Responses to query requests from the macro.
  Stream<Response> get responses => _responsesController.stream;

  _Connection(this.socket);

  @override
  String toString() => '_Connection($descriptions)';
}
