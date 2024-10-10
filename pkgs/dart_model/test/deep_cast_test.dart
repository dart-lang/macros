// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/src/deep_cast_map.dart';
import 'package:test/test.dart';

void main() {
  test('can perform deep casts on maps', () {
    final initial = <dynamic, dynamic>{
      'x': <dynamic>[1, 2, 3]
    };
    expect(initial, isNot(isA<Map<String, List<int>>>()));
    final typed =
        initial.deepCast<String, List<int>>((v) => (v as List).cast<int>());
    expect(typed, isA<Map<String, List<int>>>());
    expect(typed['x']!, isA<List<int>>());
    expect(typed['x']!, [1, 2, 3]);
  });

  test('can perform really deep casts on maps', () {
    final initial = <dynamic, dynamic>{
      'x': <dynamic, dynamic>{
        'y': <dynamic>[1, 2, 3]
      },
    };
    expect(initial, isNot(isA<Map<String, Map<String, List<int>>>>()));

    final typed = initial.deepCast<String, Map<String, List<int>>>((v) =>
        (v as Map).deepCast<String, List<int>>((v) => (v as List).cast()));
    expect(typed, isA<Map<String, Map<String, List<int>>>>());

    expect(initial['x'], isNot(isA<Map<String, List<int>>>()));
    final x = typed['x']!;
    expect(x, isA<Map<String, List<int>>>());

    expect((initial['x'] as Map)['y'], isNot(isA<List<int>>()));
    final y = x['y']!;
    expect(y, isA<List<int>>());
    expect(y, [1, 2, 3]);
  });
}
