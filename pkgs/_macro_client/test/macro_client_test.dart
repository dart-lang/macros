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
    Protocol(encoding: 'json'),
    Protocol(encoding: 'binary')
  ]) {
    group('MacroClient using ${protocol.encoding}', () {
      test('connects to service', () async {
        final serverSocket = await ServerSocket.bind('localhost', 0);
        addTearDown(serverSocket.close);

        unawaited(MacroClient.run(
            protocol: protocol,
            endpoint: HostEndpoint(port: serverSocket.port),
            macros: [DeclareXImplementation()]));

        await serverSocket.first.timeout(const Duration(seconds: 10));
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
              'runsInPhases': [2]
            }
          }
        });

        final requestId = nextRequestId;
        protocol.send(
            socket.add,
            HostRequest.augmentRequest(AugmentRequest(phase: 2), id: requestId)
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
              'runsInPhases': [3]
            }
          },
        });

        final requestId = nextRequestId;
        protocol.send(
            socket.add,
            HostRequest.augmentRequest(
                    AugmentRequest(
                        phase: 3,
                        target: QualifiedName('package:foo/foo.dart#Foo')),
                    id: requestId)
                .node);
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

        protocol.send(
            socket.add,
            Response.queryResponse(
                    QueryResponse(
                        model:
                            Model(uris: {'package:foo/foo.dart': Library()})),
                    requestId: queryRequestId)
                .node);

        final augmentRequest = await responses.next;
        expect(
          augmentRequest,
          {
            'requestId': requestId,
            'type': 'AugmentResponse',
            'value': {
              'augmentations': [
                {
                  'code': '// {"uris":{"package:foo/foo.dart":{}}}',
                }
              ]
            }
          },
        );
      });
    });
  }
}
