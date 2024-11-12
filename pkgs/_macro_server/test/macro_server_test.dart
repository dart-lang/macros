// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:_macro_client/macro_client.dart';
import 'package:_macro_server/macro_server.dart';
import 'package:_test_macros/declare_x_macro.dart';
import 'package:_test_macros/query_class.dart';
import 'package:dart_model/dart_model.dart';
import 'package:macro_service/macro_service.dart';
import 'package:test/test.dart';

void main() {
  final fooTarget = QualifiedName(name: 'Foo', uri: 'package:foo/foo.dart');
  final fooModel = Scope.query.run(
    () =>
        Model()
          ..uris[fooTarget.uri] =
              (Library()
                ..scopes['Foo'] = Interface(
                  properties: Properties(isClass: true),
                )),
  );

  for (final protocol in [
    Protocol(encoding: ProtocolEncoding.json, version: ProtocolVersion.macros1),
    Protocol(
      encoding: ProtocolEncoding.binary,
      version: ProtocolVersion.macros1,
    ),
  ]) {
    group('MacroServer using ${protocol.encoding}', () {
      test('serves a macro service', () async {
        final service = TestHostService();
        final server = await MacroServer.serve(
          protocol: protocol,
          service: service,
        );

        await MacroClient.run(
          endpoint: server.endpoint,
          macros: [DeclareXImplementation()],
        );

        // Check that the macro sent its description to the host on startup.
        expect(
          (await service.macroStartedRequests.first).macroDescription,
          DeclareXImplementation().description,
        );
      });

      test('throws on send to macro that is not running', () async {
        final service = TestHostService();
        final server = await MacroServer.serve(
          protocol: protocol,
          service: service,
        );
        expect(
          server.sendToMacro(
            HostRequest.augmentRequest(
              AugmentRequest(phase: 1, target: fooTarget, model: fooModel),
              id: 1,
              macroAnnotation: QualifiedName(
                uri: 'package:_test_macros/test_macros.dart',
                name: 'DeclareX',
              ),
            ),
          ),
          throwsException,
        );
      });

      test('send to a macro that is running succeeds', () async {
        final service = TestHostService();
        final server = await MacroServer.serve(
          protocol: protocol,
          service: service,
        );

        unawaited(
          MacroClient.run(
            endpoint: server.endpoint,
            macros: [DeclareXImplementation()],
          ),
        );

        await server.sendToMacro(
          HostRequest.augmentRequest(
            id: 1,
            macroAnnotation: QualifiedName(
              uri: 'package:_test_macros/declare_x_macro.dart',
              name: 'DeclareX',
            ),
            AugmentRequest(phase: 1, target: fooTarget, model: fooModel),
          ),
        );
      });

      test(
        'send to macro succeeds with two connected macro binaries',
        () async {
          final service = TestHostService();
          final server = await MacroServer.serve(
            protocol: protocol,
            service: service,
          );

          unawaited(
            MacroClient.run(
              endpoint: server.endpoint,
              macros: [DeclareXImplementation()],
            ),
          );

          unawaited(
            MacroClient.run(
              endpoint: server.endpoint,
              macros: [QueryClassImplementation()],
            ),
          );

          await Future.wait([
            server.sendToMacro(
              HostRequest.augmentRequest(
                id: 1,
                macroAnnotation: QualifiedName(
                  uri: 'package:_test_macros/declare_x_macro.dart',
                  name: 'DeclareX',
                ),
                AugmentRequest(phase: 1, target: fooTarget, model: fooModel),
              ),
            ),
            server.sendToMacro(
              HostRequest.augmentRequest(
                id: 2,
                macroAnnotation: QualifiedName(
                  uri: 'package:_test_macros/query_class.dart',
                  name: 'QueryClass',
                ),
                AugmentRequest(phase: 1, target: fooTarget, model: fooModel),
              ),
            ),
          ]);
        },
      );

      test('send to macro succeeds with one connected macro binary containing '
          'two macros', () async {
        final service = TestHostService();
        final server = await MacroServer.serve(
          protocol: protocol,
          service: service,
        );

        unawaited(
          MacroClient.run(
            endpoint: server.endpoint,
            macros: [DeclareXImplementation(), QueryClassImplementation()],
          ),
        );

        await Future.wait([
          server.sendToMacro(
            HostRequest.augmentRequest(
              id: 1,
              macroAnnotation: QualifiedName(
                uri: 'package:_test_macros/declare_x_macro.dart',
                name: 'DeclareX',
              ),
              AugmentRequest(phase: 1, target: fooTarget, model: fooModel),
            ),
          ),
          server.sendToMacro(
            HostRequest.augmentRequest(
              id: 2,
              macroAnnotation: QualifiedName(
                uri: 'package:_test_macros/query_class.dart',
                name: 'QueryClass',
              ),
              AugmentRequest(phase: 1, target: fooTarget, model: fooModel),
            ),
          ),
        ]);
      });
    });
  }
}

class TestHostService implements HostService {
  final StreamController<MacroStartedRequest> _macroStartedRequestsController =
      StreamController();
  Stream<MacroStartedRequest> get macroStartedRequests =>
      _macroStartedRequestsController.stream;

  @override
  Future<Response> handle(MacroRequest request) async {
    if (request.type == MacroRequestType.macroStartedRequest) {
      _macroStartedRequestsController.add(request.asMacroStartedRequest);
      return Response.macroStartedResponse(
        MacroStartedResponse(),
        requestId: request.id,
      );
    }
    return Response.errorResponse(
      ErrorResponse(error: 'unimplemented'),
      requestId: request.id,
    );
  }
}
