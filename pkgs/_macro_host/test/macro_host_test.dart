// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:isolate';

import 'package:_macro_host/macro_host.dart';
import 'package:dart_model/dart_model.dart';
import 'package:macro_service/macro_service.dart';
import 'package:test/test.dart';

void main() {
  for (final protocol in [
    Protocol(encoding: ProtocolEncoding.json, version: ProtocolVersion.macros1),
    Protocol(
        encoding: ProtocolEncoding.binary, version: ProtocolVersion.macros1)
  ]) {
    group('MacroHost using ${protocol.encoding}', () {
      test('hosts a macro, receives augmentations', () async {
        final macroAnnotation = QualifiedName(
            uri: 'package:_test_macros/declare_x_macro.dart', name: 'DeclareX');

        final queryService = TestQueryService();
        final host = await MacroHost.serve(
            protocol: protocol,
            packageConfig: Isolate.packageConfigSync!,
            queryService: queryService);

        final packageConfig = Isolate.packageConfigSync!;

        expect(host.isMacro(macroAnnotation), true);
        expect(
            await host.queryMacroPhases(packageConfig, macroAnnotation), {2});

        expect(
            await host.augment(macroAnnotation, AugmentRequest(phase: 2)),
            Scope.macro.run(() => AugmentResponse(augmentations: [
                  Augmentation(code: [Code.string('int get x => 3;')])
                ])));
      });

      test('hosts a macro, responds to queries', () async {
        final macroAnnotation = QualifiedName(
            uri: 'package:_test_macros/query_class.dart', name: 'QueryClass');

        final queryService = TestQueryService();
        final host = await MacroHost.serve(
            protocol: protocol,
            packageConfig: Isolate.packageConfigSync!,
            queryService: queryService);

        final packageConfig = Isolate.packageConfigSync!;

        expect(host.isMacro(macroAnnotation), true);
        expect(
            await host.queryMacroPhases(packageConfig, macroAnnotation), {3});

        expect(
            await host.augment(
                macroAnnotation,
                AugmentRequest(
                    phase: 3,
                    target: QualifiedName(
                        uri: 'package:foo/foo.dart', name: 'Foo'))),
            Scope.macro.run(() => AugmentResponse(augmentations: [
                  Augmentation(code: [
                    Code.string(
                        '// {"uris":{"package:foo/foo.dart":{"scopes":{}}}}')
                  ])
                ])));
      });

      test('hosts two macros', () async {
        final macroNames = [
          QualifiedName(
              uri: 'package:_test_macros/declare_x_macro.dart',
              name: 'DeclareX'),
          QualifiedName(
              uri: 'package:_test_macros/query_class.dart', name: 'QueryClass'),
        ];

        final queryService = TestQueryService();
        final host = await MacroHost.serve(
            protocol: protocol,
            packageConfig: Isolate.packageConfigSync!,
            queryService: queryService);

        for (final macroName in macroNames) {
          await host.augment(
              macroName,
              AugmentRequest(
                  phase: 3,
                  target:
                      QualifiedName(uri: 'package:foo/foo.dart', name: 'Foo')));
        }
      });

      test('validates queries against the current phase', () async {
        final macroAnnotation = QualifiedName(
            uri: 'package:_test_macros/misbehaving_macro.dart',
            name: 'AttemptToIssueTypeQueryInPhase1');

        final queryService = TestQueryService();
        final host = await MacroHost.serve(
            protocol: protocol,
            packageConfig: Isolate.packageConfigSync!,
            queryService: queryService);

        final packageConfig = Isolate.packageConfigSync!;

        expect(host.isMacro(macroAnnotation), true);
        expect(
            await host.queryMacroPhases(packageConfig, macroAnnotation), {1});

        expect(
            await host.augment(
                macroAnnotation,
                AugmentRequest(
                    phase: 1,
                    target: QualifiedName(
                        uri: 'package:foo/foo.dart', name: 'Foo'))),
            Scope.macro.run(() => AugmentResponse(augmentations: [
                  Augmentation(code: [Code.string('// Could not query')])
                ])));
      });
    });
  }
}

class TestQueryService implements QueryService {
  @override
  Future<QueryResponse> handle(List<Query> request) async {
    return QueryResponse(
        model: Model()..uris['package:foo/foo.dart'] = Library());
  }
}
