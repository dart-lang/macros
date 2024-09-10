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
  for (final protocol in [
    Protocol(encoding: ProtocolEncoding.json),
    Protocol(encoding: ProtocolEncoding.binary)
  ]) {
    group('MacroClient using ${protocol.encoding}', () {
      test('connects to service', () async {
        final serverSocket = await ServerSocket.bind('localhost', 0);
        addTearDown(serverSocket.close);

        unawaited(MacroClient.run(
            protocol: protocol,
            endpoint: HostEndpoint(port: serverSocket.port),
            macros: [DeclareXImplementation()]));

        await (await serverSocket.first.timeout(const Duration(seconds: 10)))
            .close();
      });

      test('error response if no such macro', () async {
        final serverSocket = await ServerSocket.bind('localhost', 0);

        unawaited(MacroClient.run(
            protocol: protocol,
            endpoint: HostEndpoint(port: serverSocket.port),
            macros: []));

        final socket = await serverSocket.first;
        final responses = StreamQueue(protocol.decode(socket));

        final requestId = nextRequestId;
        protocol.send(
            socket.add,
            HostRequest.augmentRequest(
                    id: requestId,
                    macroAnnotation: QualifiedName(
                        'package:_test_macros/declare_x_macro.dart#DeclareX'),
                    AugmentRequest(phase: 2))
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

      test('sends augmentation requests to macros, sends reponse', () async {
        final serverSocket = await ServerSocket.bind('localhost', 0);

        unawaited(MacroClient.run(
            protocol: protocol,
            endpoint: HostEndpoint(port: serverSocket.port),
            macros: [DeclareXImplementation()]));

        final socket = await serverSocket.first;

        final responses = StreamQueue(protocol.decode(socket));
        final descriptionResponse = await responses.next;
        expect(descriptionResponse, {
          'id': descriptionResponse['id'],
          'type': 'MacroStartedRequest',
          'value': {
            'macroDescription': {
              'annotation':
                  'package:_test_macros/declare_x_macro.dart#DeclareX',
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
                        'package:_test_macros/declare_x_macro.dart#DeclareX'),
                    AugmentRequest(phase: 2))
                .node);
        final augmentResponse = await responses.next;
        expect(augmentResponse, {
          'requestId': requestId,
          'type': 'AugmentResponse',
          'value': {
            'augmentations': [
              {'code': 'int get x => 3;'}
            ]
          }
        });
      });

      test('sends query requests to host, sends reponse', () async {
        final serverSocket = await ServerSocket.bind('localhost', 0);

        unawaited(MacroClient.run(
            protocol: protocol,
            endpoint: HostEndpoint(port: serverSocket.port),
            macros: [QueryClassImplementation()]));

        final socket = await serverSocket.first;

        final responses = StreamQueue(protocol.decode(socket));
        final descriptionResponse = await responses.next;
        expect(descriptionResponse, {
          'id': descriptionResponse['id'],
          'type': 'MacroStartedRequest',
          'value': {
            'macroDescription': {
              'annotation': 'package:_test_macros/query_class.dart#QueryClass',
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
                  'package:_test_macros/query_class.dart#QueryClass'),
              AugmentRequest(
                  phase: 3, target: QualifiedName('package:foo/foo.dart#Foo')),
            ).node);
        final queryRequest = await responses.next;
        final queryRequestId = MacroRequest.fromJson(queryRequest).id;
        expect(
          queryRequest,
          {
            'id': queryRequestId,
            'type': 'QueryRequest',
            'value': {
              'query': {'target': 'package:foo/foo.dart#Foo'}
            },
          },
        );

        Scope.query.run(() => protocol.send(
            socket.add,
            Response.queryResponse(
                    QueryResponse(
                        model: Model()
                          ..uris['package:foo/foo.dart'] = Library()),
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
                  'code': '// {"uris":{"package:foo/foo.dart":{"scopes":{}}}}',
                }
              ]
            }
          },
        );
      });

      test('handles concurrent queries', () async {
        final serverSocket = await ServerSocket.bind('localhost', 0);

        unawaited(MacroClient.run(
            protocol: protocol,
            endpoint: HostEndpoint(port: serverSocket.port),
            macros: [QueryClassImplementation()]));

        final socket = await serverSocket.first;

        final responses = StreamQueue(protocol.decode(socket));
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
                    'package:_test_macros/query_class.dart#QueryClass'),
                AugmentRequest(
                    phase: 3,
                    target: QualifiedName('package:foo/foo.dart#Foo')),
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
                  'code': '// {"uris":{"package:foo/foo1.dart":{"scopes":{}}}}',
                }
              ]
            }
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
                  'code': '// {"uris":{"package:foo/foo2.dart":{"scopes":{}}}}',
                }
              ]
            }
          },
        );
      });
    });
  }
}
