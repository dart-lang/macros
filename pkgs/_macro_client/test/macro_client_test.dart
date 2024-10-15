// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:_macro_client/macro_client.dart';
import 'package:_test_macros/declare_x_macro.dart';
import 'package:_test_macros/query_class.dart';
import 'package:async/async.dart';
import 'package:dart_model/dart_model.dart';
import 'package:macro_service/macro_service.dart';
import 'package:test/test.dart';

void main() {
  final fooTarget = QualifiedName(name: 'Foo', uri: 'package:foo/foo.dart');
  final fooModel = Scope.query.run(() => Model()
    ..uris[fooTarget.uri] = (Library()
      ..scopes['Foo'] = Interface(properties: Properties(isClass: true))));

  for (final protocol in [
    Protocol(encoding: ProtocolEncoding.json, version: ProtocolVersion.macros1),
    Protocol(
        encoding: ProtocolEncoding.binary, version: ProtocolVersion.macros1)
  ]) {
    group('MacroClient using ${protocol.encoding}', () {
      /// Waits for [HandshakRequest] on [socket], sends response choosing
      /// [protocol], returns next responses decoded using [protocol].
      Future<StreamQueue<Map<String, Object?>>> handshake(Socket socket) async {
        final broadcastStream = socket.asBroadcastStream();
        final handshakeRequest =
            await Protocol.handshakeProtocol.decode(broadcastStream).first;
        final result = StreamQueue(protocol.decode(broadcastStream));

        expect(handshakeRequest, {
          'protocols': [
            {'encoding': 'json', 'version': 'macros1'},
            {'encoding': 'binary', 'version': 'macros1'}
          ]
        });
        Protocol.handshakeProtocol
            .send(socket.add, HandshakeResponse(protocol: protocol).node);

        return result;
      }

      test('connects to service', () async {
        final serverSocket = await ServerSocket.bind('localhost', 0);
        addTearDown(serverSocket.close);

        unawaited(MacroClient.run(
            endpoint: HostEndpoint(port: serverSocket.port),
            macros: [DeclareXImplementation()]));

        final socket = await serverSocket.first;
        await handshake(socket);
      });

      test('error response if no such macro', () async {
        final serverSocket = await ServerSocket.bind('localhost', 0);

        unawaited(MacroClient.run(
            endpoint: HostEndpoint(port: serverSocket.port),
            macros: [QueryClassImplementation()]));

        final socket = await serverSocket.first;
        final responses = await handshake(socket);

        // MacroStartedRequest, ignore.
        await responses.next;

        final requestId = nextRequestId;
        protocol.send(
            socket.add,
            HostRequest.augmentRequest(
                    id: requestId,
                    macroAnnotation: QualifiedName(
                        uri: 'package:_test_macros/declare_x_macro.dart',
                        name: 'DeclareX'),
                    AugmentRequest(
                        phase: 2, target: fooTarget, model: fooModel))
                .node);

        final augmentResponse = await responses.next;
        expect(augmentResponse, {
          'requestId': requestId,
          'type': 'ErrorResponse',
          'value': {
            'error': 'No macro for annotation: '
                'package:_test_macros/declare_x_macro.dart#DeclareX'
          }
        });
      });

      test('sends augmentation requests to macros, sends response', () async {
        final serverSocket = await ServerSocket.bind('localhost', 0);

        unawaited(MacroClient.run(
            endpoint: HostEndpoint(port: serverSocket.port),
            macros: [DeclareXImplementation()]));

        final socket = await serverSocket.first;
        final responses = await handshake(socket);

        final descriptionResponse = await responses.next;
        expect(descriptionResponse, {
          'id': descriptionResponse['id'],
          'type': 'MacroStartedRequest',
          'value': {
            'macroDescription': {
              'annotation': {
                'uri': 'package:_test_macros/declare_x_macro.dart',
                'name': 'DeclareX',
              },
              'runsInPhases': [2]
            }
          }
        });

        final requestId = nextRequestId;
        protocol.send(
            socket.add,
            HostRequest.augmentRequest(
                    id: requestId,
                    macroAnnotation: QualifiedName(
                        uri: 'package:_test_macros/declare_x_macro.dart',
                        name: 'DeclareX'),
                    AugmentRequest(
                        phase: 2, target: fooTarget, model: fooModel))
                .node);

        final augmentResponse = await responses.next;
        expect(augmentResponse, {
          'requestId': requestId,
          'type': 'AugmentResponse',
          'value': {
            'augmentations': [
              {
                'code': [
                  {
                    'type': 'String',
                    'value': 'int get x => 3;',
                  }
                ]
              }
            ]
          },
        });
      });

      test('sends query requests to host, sends reponse', () async {
        final serverSocket = await ServerSocket.bind('localhost', 0);

        unawaited(MacroClient.run(
            endpoint: HostEndpoint(port: serverSocket.port),
            macros: [QueryClassImplementation()]));

        final socket = await serverSocket.first;
        final responses = await handshake(socket);

        final descriptionResponse = await responses.next;
        expect(descriptionResponse, {
          'id': descriptionResponse['id'],
          'type': 'MacroStartedRequest',
          'value': {
            'macroDescription': {
              'annotation': {
                'uri': 'package:_test_macros/query_class.dart',
                'name': 'QueryClass',
              },
              'runsInPhases': [3]
            }
          },
        });

        final requestId = nextRequestId;
        protocol.send(
            socket.add,
            HostRequest.augmentRequest(
              id: requestId,
              macroAnnotation: QualifiedName(
                  uri: 'package:_test_macros/query_class.dart',
                  name: 'QueryClass'),
              AugmentRequest(phase: 3, target: fooTarget, model: fooModel),
            ).node);

        final queryRequest = await responses.next;
        final queryRequestId = MacroRequest.fromJson(queryRequest).id;
        expect(
          queryRequest,
          {
            'id': queryRequestId,
            'type': 'QueryRequest',
            'value': {
              'query': {'target': fooTarget}
            },
          },
        );

        Scope.query.run(() => protocol.send(
            socket.add,
            Response.queryResponse(QueryResponse(model: fooModel),
                    requestId: queryRequestId)
                .node));

        final augmentResponse = await responses.next;
        expect(
          augmentResponse,
          {
            'requestId': requestId,
            'type': 'AugmentResponse',
            'value': {
              'augmentations': [
                {
                  'code': [
                    {
                      'type': 'String',
                      'value':
                          '// {"uris":{"${fooTarget.uri}":{"scopes":{"Foo":'
                              '{"members":{},"properties":{"isClass":true}}}}}}'
                    }
                  ]
                }
              ]
            },
          },
        );
      });

      test('handles concurrent queries', () async {
        final serverSocket = await ServerSocket.bind('localhost', 0);

        unawaited(MacroClient.run(
            endpoint: HostEndpoint(port: serverSocket.port),
            macros: [QueryClassImplementation()]));

        final socket = await serverSocket.first;
        final responses = await handshake(socket);

        // MacroStartedRequest, ignore.
        await responses.next;

        final requestId1 = nextRequestId;
        final requestId2 = nextRequestId;
        for (final requestId in [requestId1, requestId2]) {
          protocol.send(
              socket.add,
              HostRequest.augmentRequest(
                id: requestId,
                macroAnnotation: QualifiedName(
                    uri: 'package:_test_macros/query_class.dart',
                    name: 'QueryClass'),
                AugmentRequest(phase: 3, target: fooTarget, model: fooModel),
              ).node);
        }

        final queryRequest1 = await responses.next;
        final queryRequestId1 = MacroRequest.fromJson(queryRequest1).id;
        Scope.query.run(() => protocol.send(
            socket.add,
            Response.queryResponse(
                    QueryResponse(
                        model: Model()
                          ..uris['package:foo/foo1.dart'] = Library()),
                    requestId: queryRequestId1)
                .node));

        final queryRequest2 = await responses.next;
        final queryRequestId2 = MacroRequest.fromJson(queryRequest2).id;
        Scope.query.run(() => protocol.send(
            socket.add,
            Response.queryResponse(
                    QueryResponse(
                        model: Model()
                          ..uris['package:foo/foo2.dart'] = Library()),
                    requestId: queryRequestId2)
                .node));

        final augmentResponse1 = await responses.next;
        final augmentResponse2 = await responses.next;

        expect(
          augmentResponse1,
          {
            'requestId': requestId1,
            'type': 'AugmentResponse',
            'value': {
              'augmentations': [
                {
                  'code': [
                    {
                      'type': 'String',
                      'value':
                          '// {"uris":{"package:foo/foo1.dart":{"scopes":{}}}}'
                    }
                  ]
                }
              ]
            },
          },
        );

        expect(
          augmentResponse2,
          {
            'requestId': requestId2,
            'type': 'AugmentResponse',
            'value': {
              'augmentations': [
                {
                  'code': [
                    {
                      'type': 'String',
                      'value':
                          '// {"uris":{"package:foo/foo2.dart":{"scopes":{}}}}'
                    }
                  ]
                }
              ]
            },
          },
        );
      });
    });
  }
}
