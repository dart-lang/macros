// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:dart_model/dart_model.dart';
import 'package:macro/macro.dart';
import 'package:macro_service/macro_service.dart';

/// Local macro client which runs macros as directed by requests from a remote
/// macro host.
///
/// TODO(davidmorgan): handle shutdown and dispose.
/// TODO(davidmorgan): split to multpile implementations depending on
/// transport used to connect to host.
class MacroClient {
  final Protocol protocol;
  final Iterable<Macro> macros;
  final Socket socket;
  late final RemoteMacroHost _host;

  /// A completer for each pending request to the host, by request ID.
  final Map<int, Completer<Response>> _responseCompleters = {};

  MacroClient._(this.protocol, this.macros, this.socket) {
    _host = RemoteMacroHost(this);

    // TODO(davidmorgan): negotiation about protocol version goes here.

    // Tell the host which macros are in this bundle.
    for (final macro in macros) {
      _sendRequest(MacroRequest.macroStartedRequest(
          MacroStartedRequest(macroDescription: macro.description),
          id: nextRequestId));
    }

    protocol.decode(socket).listen(_handleRequest);
  }

  /// Runs [macros] for the host at [endpoint].
  static Future<MacroClient> run({
    // TODO(davidmorgan): this should be negotiated, not just passed in.
    required Protocol protocol,
    required HostEndpoint endpoint,
    required Iterable<Macro> macros,
  }) async {
    final socket = await Socket.connect('localhost', endpoint.port);
    return MacroClient._(protocol, macros, socket);
  }

  Future<Response> _sendRequest(MacroRequest request) async {
    if (_responseCompleters.containsKey(request.id)) {
      throw StateError('Request already pending with ID ${request.id}.');
    }
    final completer = _responseCompleters[request.id] = Completer<Response>();
    protocol.send(socket.add, request.node);
    return completer.future;
  }

  void _sendResponse(Response response) {
    protocol.send(socket.add, response.node);
  }

  void _handleRequest(Map<String, Object?> jsonData) async {
    final hostRequest = HostRequest.fromJson(jsonData);
    switch (hostRequest.type) {
      case HostRequestType.augmentRequest:
        final macro = macros
            .where((m) =>
                m.description.annotation.string ==
                hostRequest.macroAnnotation.string)
            .singleOrNull;

        if (macro == null) {
          _sendResponse(Response.errorResponse(
              requestId: hostRequest.id,
              ErrorResponse(
                  error: 'No macro for annotation: '
                      '${hostRequest.macroAnnotation}')));
        } else {
          await Scope.macro.runAsync(() async => _sendResponse(
              Response.augmentResponse(
                  await macro.augment(_host, hostRequest.asAugmentRequest),
                  requestId: hostRequest.id)));
        }
      default:
      // Ignore unknown request.
      // TODO(davidmorgan): make handling of unknown request types a designed
      // part of the protocol+code, update implementation here and below.
    }
    final response = Response.fromJson(jsonData);
    if (response.type.isKnown) {
      final completer = _responseCompleters.remove(response.requestId);
      if (completer == null) {
        throw StateError('Unknown requestId: ${response.requestId}.');
      } else {
        completer.complete(response);
      }
    }
  }
}

/// [Host] that is connected to a remote macro host.
///
/// Wraps `MacroClient` exposing just what should be available to the macro.
///
/// This gets passed into user-written macro code, so fields and methods here
/// can be accessed by the macro code if they are public, even if they are not
/// on `Host`, via dynamic dispatch.
///
/// TODO(language/issues/3951): follow up on security implications.
///
class RemoteMacroHost implements Host {
  final MacroClient _client;

  RemoteMacroHost(this._client);

  @override
  Future<Model> query(Query query) async {
    // The macro scope is used to accumulate augment results, drop into
    // "none" scope to avoid clashing with those when sending the query.
    return (await Scope.none.runAsync(() async => _client._sendRequest(
            MacroRequest.queryRequest(QueryRequest(query: query),
                id: nextRequestId))))
        .asQueryResponse
        .model;
  }
}
