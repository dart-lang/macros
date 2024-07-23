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
  final HostService service;
  final HostEndpoint endpoint;
  final ServerSocket serverSocket;

  // TODO(davidmorgan): track which socket corresponds to which macro(s).
  Socket? _lastSocket;

  // TODO(davidmorgan): properly track requests and responses.
  Completer<Response>? _responseCompleter;

  MacroServer._(this.service, this.endpoint, this.serverSocket) {
    serverSocket.forEach(_handleConnection);
  }

  /// Serves [service].
  ///
  /// TODO(davidmorgan): other transports besides TCP/IP.
  static Future<MacroServer> serve({required HostService service}) async {
    final serverSocket = await ServerSocket.bind('localhost', 0);
    return MacroServer._(
        service, HostEndpoint(port: serverSocket.port), serverSocket);
  }
  
  Future<Response> sendToMacro(QualifiedName name, HostRequest request) async {
    _responseCompleter = Completer<Response>();
    _lastSocket!.writeln(json.encode(request.node));
    return _responseCompleter!.future;
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
      final jsonData = json.decode(line) as Map<String, Object?>;
      final request = MacroRequest.fromJson(jsonData);
      if (request.type != MacroRequestType.unknown) {
        service
            .handle(request)
            .then((response) => socket.writeln(json.encode(response!.node)));
      }
      final response = Response.fromJson(jsonData);
      if (response.type != ResponseType.unknown) {
        _responseCompleter!.complete(response);
        _responseCompleter = null;
      }
    });
  }
}
