// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';
import 'package:dart_model/src/json_buffer/json_buffer_builder.dart';
import 'package:test/test.dart';

void main() {
  group(Scope, () {
    for (final scope in [Scope.none, Scope.macro, Scope.query]) {
      test('create maps and serialize work in $scope', () {
        expect(scope.run(() => Scope.createMap(TypedMapSchema({}))),
            <String, Object?>{});
        expect(scope.run(Scope.createGrowableMap), <String, Object?>{});
        expect(scope.run(() => Scope.serializeToBinary(<String, Object>{})),
            JsonBufferBuilder().serialize());
      });
    }

    test('macro and query scopes cannot be nested', () {
      expect(() => Scope.macro.run(() => Scope.macro.run(() {})),
          throwsStateError);
      expect(() => Scope.macro.run(() => Scope.query.run(() {})),
          throwsStateError);
      expect(() => Scope.query.run(() => Scope.macro.run(() {})),
          throwsStateError);
      expect(() => Scope.query.run(() => Scope.query.run(() {})),
          throwsStateError);
    });

    test('none scope can be nested in macro or query scopes', () {
      Scope.macro.run(() => Scope.none.run(() {}));
      Scope.query.run(() => Scope.none.run(() {}));
    });
  });
}
