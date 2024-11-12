// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';

/// Expects that [map] and [expected] are equal.
///
/// Does not assume that `map` correctly implements `Map`, instead compares via
/// all methods.
///
/// Does additional checks on `map`.
void expectFullyEquivalentMaps(
  Map<String, Object?> map,
  Map<String, Object?> expected,
) {
  expect(map.entries.map((e) => e.key), expected.entries.map((e) => e.key));
  expect(map.entries.map((e) => e.value), expected.entries.map((e) => e.value));
  expect(map.isEmpty, expected.isEmpty);
  expect(map.isNotEmpty, expected.isNotEmpty);
  expect(map.keys, expected.keys);
  expect(map.length, expected.length);
  expect(map.values, expected.values);

  for (final key in map.keys) {
    expect(map.containsKey(key), isTrue);
  }
  expect(map.containsKey(Object()), isFalse);

  for (final value in map.values) {
    if (value is Map || value is Iterable) {
      // Collections do not implement deep `operator==`, so this is expected to
      // fail.
      continue;
    }
    expect(map.containsValue(value), isTrue, reason: value.toString());
  }
  expect(map.containsValue(Object()), isFalse);
}
