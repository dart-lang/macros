// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:isolate';

import 'package:_macro_host/macro_host.dart';
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
    group('MacroHost using ${protocol.encoding}', () {
      test('hosts a macro, receives augmentations', () async {
        final macroAnnotation = QualifiedName(
          uri: 'package:_test_macros/declare_x_macro.dart',
          name: 'DeclareX',
        );

        final queryService = TestQueryService();
        final host = await MacroHost.serve(
          protocol: protocol,
          packageConfig: Isolate.packageConfigSync!,
          queryService: queryService,
        );

        expect(host.isMacro(macroAnnotation), true);
        expect(await host.queryMacroPhases(macroAnnotation), {2});

        expect(
          await host.augment(
            macroAnnotation,
            AugmentRequest(phase: 2, target: fooTarget, model: fooModel),
          ),
          Scope.macro.run(
            () =>
                AugmentResponse(libraryAugmentations: [], newTypeNames: [])
                  ..typeAugmentations!['Foo'] = [
                    Augmentation(code: [Code.string('int get x => 3;')]),
                  ],
          ),
        );
      });

      test('hosts a macro, responds to queries', () async {
        final macroAnnotation = QualifiedName(
          uri: 'package:_test_macros/query_class.dart',
          name: 'QueryClass',
        );

        final queryService = TestQueryService();
        final host = await MacroHost.serve(
          protocol: protocol,
          packageConfig: Isolate.packageConfigSync!,
          queryService: queryService,
        );

        expect(host.isMacro(macroAnnotation), true);
        expect(await host.queryMacroPhases(macroAnnotation), {3});

        expect(
          await host.augment(
            macroAnnotation,
            AugmentRequest(phase: 3, target: fooTarget, model: fooModel),
          ),
          Scope.macro.run(
            () => AugmentResponse(libraryAugmentations: [], newTypeNames: [])
              ..typeAugmentations!['Foo'] = [
                Augmentation(
                  code: [
                    Code.string(
                      '// {"uris":{"package:foo/foo.dart":{"scopes":{"Foo":{'
                      '"members":{},"properties":{"isClass":true}}}}}}',
                    ),
                  ],
                ),
              ],
          ),
        );
      });

      test('hosts two macros', () async {
        final macroNames = [
          QualifiedName(
            uri: 'package:_test_macros/declare_x_macro.dart',
            name: 'DeclareX',
          ),
          QualifiedName(
            uri: 'package:_test_macros/query_class.dart',
            name: 'QueryClass',
          ),
        ];

        final queryService = TestQueryService();
        final host = await MacroHost.serve(
          protocol: protocol,
          packageConfig: Isolate.packageConfigSync!,
          queryService: queryService,
        );

        for (final macroName in macroNames) {
          await host.augment(
            macroName,
            AugmentRequest(phase: 3, target: fooTarget, model: fooModel),
          );
        }
      });

      group('caching', () {
        final macroAnnotation = QualifiedName(
          uri: 'package:_test_macros/declare_x_macro.dart',
          name: 'DeclareX',
        );

        late AugmentResponse initialResult;
        late MacroHost host;
        late TestQueryService queryService;

        setUp(() async {
          queryService = TestQueryService();
          host = await MacroHost.serve(
            protocol: protocol,
            packageConfig: Isolate.packageConfigSync!,
            queryService: queryService,
          );

          initialResult = await host.augment(
            macroAnnotation,
            AugmentRequest(phase: 2, target: fooTarget, model: fooModel),
          );
        });

        test('re-uses results if queries don\'t change', () async {
          final rerunResult = await host.augment(
            macroAnnotation,
            AugmentRequest(phase: 2, target: fooTarget, model: fooModel),
          );
          expect(identical(initialResult, rerunResult), true);
        });

        test('Invalidates results if queries do change', () async {
          queryService.handleRequest = (QueryRequest request) async {
            return QueryResponse(
              model:
                  Model()
                    ..uris[request.query.target.uri] =
                        (Library()
                          ..scopes[request.query.target.name] = Interface(
                            properties: Properties(isClass: false),
                          )),
            );
          };
          final rerunResult = await host.augment(
            macroAnnotation,
            AugmentRequest(phase: 2, target: fooTarget, model: fooModel),
          );
          expect(identical(initialResult, rerunResult), false);
        });
      });
    });
  }
}

final class TestQueryService extends QueryService {
  /// Actual implementatin of request handling, can be overwritten.
  Future<QueryResponse> Function(QueryRequest request) handleRequest = (
    QueryRequest request,
  ) async {
    return QueryResponse(
      model:
          Model()
            ..uris[request.query.target.uri] =
                (Library()
                  ..scopes[request.query.target.name] = Interface(
                    properties: Properties(isClass: true),
                  )),
    );
  };

  @override
  Future<QueryResponse> handle(QueryRequest request) => handleRequest(request);
}
