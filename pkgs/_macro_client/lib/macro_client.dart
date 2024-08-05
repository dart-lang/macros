// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_model/dart_model.dart';
import 'package:macro/macro.dart';
import 'package:macro_service/macro_service.dart';

/// Runs macros, connecting them to a macro host.
///
/// TODO(davidmorgan): handle shutdown and dispose.
/// TODO(davidmorgan): split to multpile implementations depending on
/// transport used to connect to host.
class MacroClient {
  late final RemoteMacroHost host;
  final Iterable<Macro> macros;
  final Socket socket;

  MacroClient._(this.macros, this.socket) {

  MacroClient._(this.macros, this.socket) {
    // TODO(davidmorgan): negotiation about protocol version goes here.

    // Tell the host which macros are in this bundle.
    for (final macro in macros) {
      _responseCompleter = Completer();
      _sendRequest(MacroRequest.macroStartedRequest(
          MacroStartedRequest(macroDescription: macro.description)));
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

  void _sendRequest(MacroRequest request) {
    // TODO(davidmorgan): currently this is JSON with one request per line,
    // switch to binary.
    socket.writeln(json.encode(request.node));
  }

  void _sendResponse(Response response) {
    // TODO(davidmorgan): currently this is JSON with one request per line,
    // switch to binary.
    socket.writeln(json.encode(response.node));
  }

  void _handleRequest(String request) async {
    final jsonData = json.decode(request) as Map<String, Object?>;
    final hostRequest = HostRequest.fromJson(jsonData);
    switch (hostRequest.type) {
      case HostRequestType.augmentRequest:
        _sendResponse(Response.augmentResponse(
            await macros.single.augment(host, hostRequest.asAugmentRequest)));
      default:
      // Ignore unknown request.
    }
    final response = Response.fromJson(jsonData);
    switch (response.type) {
      case ResponseType.unknown:
        // Ignore unknown response.
        break;
      default:
        // TODO(davidmorgan): track requests and responses properly.
        if (_responseCompleter != null) {
          _responseCompleter!.complete(response);
          _responseCompleter = null;
        }
    }
  }
}

/// [Host] that is connected to a remote macro host.
class RemoteMacroHost implements Host {
  final MacroClient _client;

  RemoteMacroHost(this._client);

  @override
  Future<Model> query(Query query) async {
    _client._sendRequest(MacroRequest.queryRequest(QueryRequest(query: query)));
    // TODO(davidmorgan): this is needed because the constructor doesn't wait
    // for responses to `MacroStartedRequest`, so we need to discard the
    // responses. Properly track requests and responses.
    while (true) {
      final nextResponse = await _nextResponse();
      if (nextResponse.type == ResponseType.macroStartedResponse) {
        continue;
      }
      return nextResponse.asQueryResponse.model;
    }
  }

  Future<Response> _nextResponse() async {
    _client._responseCompleter = Completer<Response>();
    return await _client._responseCompleter!.future;
  }
}
