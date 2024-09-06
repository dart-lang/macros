// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';
import 'package:dart_model/src/json_buffer/json_buffer_builder.dart';
import 'package:test/test.dart';

void main() {
  group(Scope, () {
    test('create map throws on no scope', () {
      expect(() => Scope.createMap(TypedMapSchema({})), throwsStateError);
      expect(Scope.createGrowableMap, throwsStateError);
    });

    test('serialize works in no scope', () {
      expect(Scope.serializeToBinary({}), [0, 0, 0, 0, 0, 0, 0, 0]);
    });

    test('serialize throws in evaluating scope', () {
      expect(() => Scope.evaluating.run(() => Scope.serializeToBinary({})),
          throwsStateError);
    });

    for (final scope in [Scope.evaluating, Scope.macro, Scope.query]) {
      test('create maps works in $scope', () {
        expect(scope.run(() => Scope.createMap(TypedMapSchema({}))),
            <String, Object?>{});
        expect(scope.run(Scope.createGrowableMap), <String, Object?>{});
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
      expect(() => Scope.evaluating.run(() => Scope.macro.run(() {})),
          throwsStateError);
      expect(() => Scope.evaluating.run(() => Scope.query.run(() {})),
          throwsStateError);
    });

    test('none and evaluating scopes can be nested in macro or query scopes',
        () {
      Scope.macro.run(() => Scope.evaluating.run(() {}));
      Scope.macro.run(() => Scope.none.run(() {}));
      Scope.query.run(() => Scope.evaluating.run(() {}));
      Scope.query.run(() => Scope.none.run(() {}));
    });
  });
}
