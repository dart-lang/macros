// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:dart_model/dart_model.dart';
import 'package:macro/macro.dart';
import 'package:macro_service/macro_service.dart';

import 'src/execute_macro.dart';

/// Local macro client which runs macros as directed by requests from a remote
/// macro host.
///
/// TODO(davidmorgan): handle shutdown and dispose.
/// TODO(davidmorgan): split to multpile implementations depending on
/// transport used to connect to host.
class MacroClient {
  /// The protocol, once the handshake is complete.
  late final Protocol protocol;
  final Iterable<Macro> macros;
  final Socket socket;
  late final RemoteMacroHost _host;

  /// A completer for each pending request to the host, by request ID.
  final Map<int, Completer<Response>> _responseCompleters = {};

  MacroClient._(this.macros, this.socket) {
    // Nagle's algorithm slows us down >100x, disable it.
    socket.setOption(SocketOption.tcpNoDelay, true);
    _host = RemoteMacroHost(this);
    _start();
  }

  /// Does the protocol handshake then sends [MacroStartedRequest] for each
  /// macro.
  void _start() async {
    // The incoming data starts as JSON strings, `handshakeProtocol`, then
    // switches to the agreed-upon protocol. So use a broadcast stream to
    // allow processing the stream in two different ways.
    final broadcastStream = socket.asBroadcastStream();
    // Prepare to receive the handshake response, but it won't be sent until
    // after `HandshakeRequest` is sent below.
    final firstResponse =
        Protocol.handshakeProtocol.decode(broadcastStream).first;
    // Send `HandshakeRequest` telling the host what protocols this macro
    // bundle supports.
    Protocol.handshakeProtocol.send(
        socket.add,
        HandshakeRequest(protocols: [
          Protocol(
              encoding: ProtocolEncoding.json,
              version: ProtocolVersion.macros1),
          Protocol(
              encoding: ProtocolEncoding.binary,
              version: ProtocolVersion.macros1),
        ]).node);
    // Read `HandshakeResponse`, get from it the protocol to use for the rest of
    // the stream, and decode+handle using that protocol.
    final handshakeResponse = HandshakeResponse.fromJson(await firstResponse);
    protocol = handshakeResponse.protocol!;
    protocol.decode(broadcastStream).listen(_handleRequest);

    // Note that reading `HandshakeResponse` then switching protocol relies on
    // no other messages arriving in the same chunk as `HandshakeResponse`. This
    // is guaranteed because the host won't send anything else until it receives
    // a `MacroStartedRequest` that is sent next.

    for (final macro in macros) {
      unawaited(_sendRequest(MacroRequest.macroStartedRequest(
          MacroStartedRequest(macroDescription: macro.description),
          id: nextRequestId)));
    }
  }

  /// Runs [macros] for the host at [endpoint].
  static Future<MacroClient> run({
    required HostEndpoint endpoint,
    required Iterable<Macro> macros,
  }) async {
    final socket = await Socket.connect('localhost', endpoint.port);
    return MacroClient._(macros, socket);
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
                m.description.annotation.equals(hostRequest.macroAnnotation))
            .singleOrNull;

        if (macro == null) {
          _sendResponse(Response.errorResponse(
              requestId: hostRequest.id,
              ErrorResponse(
                  error: 'No macro for annotation: '
                      '${hostRequest.macroAnnotation.asString}')));
        } else {
          final augmentRequest = hostRequest.asAugmentRequest;
          await Scope.macro
              .runAsync(() async => _sendResponse(Response.augmentResponse(
                  switch (augmentRequest.phase) {
                        1 => macro.description.runsInPhases.contains(1)
                            ? await executeTypesMacro(
                                macro, _host, augmentRequest)
                            : null,
                        2 => macro.description.runsInPhases.contains(2)
                            ? await executeDeclarationsMacro(
                                macro, _host, augmentRequest)
                            : null,
                        3 => macro.description.runsInPhases.contains(3)
                            ? await executeDefinitionsMacro(
                                macro, _host, augmentRequest)
                            : null,
                        _ => throw StateError(
                            'Unexpected phase ${augmentRequest.phase}, '
                            'expected 1, 2, or 3.')
                      } ??
                      AugmentResponse(augmentations: []),
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
    final model = (await Scope.none.runAsync(() async => _client._sendRequest(
            MacroRequest.queryRequest(QueryRequest(query: query),
                id: nextRequestId))))
        .asQueryResponse
        .model;
    MacroScope.current.addModel(model);
    return model;
  }
}
