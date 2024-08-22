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
    Protocol(encoding: 'json'),
    Protocol(encoding: 'binary')
  ]) {
    group('MacroHost using ${protocol.encoding}', () {
      test('hosts a macro, receives augmentations', () async {
        final macroName =
            QualifiedName('package:_test_macros/declare_x_macro.dart#DeclareX');
        final macroImplementation = QualifiedName(
            'package:_test_macros/declare_x_macro.dart#DeclareXImplementation');

        final queryService = TestQueryService();
        final host = await MacroHost.serve(
            protocol: protocol,
            packageConfig: Isolate.packageConfigSync!,
            queryService: queryService);

        final packageConfig = Isolate.packageConfigSync!;

        expect(host.isMacro(macroName), true);
        expect(await host.queryMacroPhases(packageConfig, macroImplementation),
            {2});

        expect(
            await host.augment(macroName, AugmentRequest(phase: 2)),
            AugmentResponse(
                augmentations: [Augmentation(code: 'int get x => 3;')]));
      });

      test('hosts a macro, responds to queries', () async {
        final macroName =
            QualifiedName('package:_test_macros/query_class.dart#QueryClass');
        final macroImplementation = QualifiedName(
            'package:_test_macros/query_class.dart#QueryClassImplementation');

        final queryService = TestQueryService();
        final host = await MacroHost.serve(
            protocol: protocol,
            packageConfig: Isolate.packageConfigSync!,
            queryService: queryService);

        final packageConfig = Isolate.packageConfigSync!;

        expect(host.isMacro(macroName), true);
        expect(await host.queryMacroPhases(packageConfig, macroImplementation),
            {3});

        expect(
            await host.augment(
                macroName,
                AugmentRequest(
                    phase: 3,
                    target: QualifiedName('package:foo/foo.dart#Foo'))),
            AugmentResponse(augmentations: [
              Augmentation(code: '// {"uris":{"package:foo/foo.dart":{}}}')
            ]));
      });
    });
  }
}

class TestQueryService implements QueryService {
  @override
  Future<QueryResponse> handle(QueryRequest request) async {
    return QueryResponse(
        model:
            Model(uris: {'package:foo/foo.dart': Library(scopes: const {})}));
  }
}
