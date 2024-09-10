// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_test_macros/json_codable.dart';

@JsonCodable()
class A {
  final bool boolField;

  final bool? nullableBoolField;

  final String stringField;

  final String? nullableStringField;

  final int intField;

  final int? nullableIntField;

  final double doubleField;

  final double? nullableDoubleField;

  final num numField;

  final num? nullableNumField;

  final List<C> listOfSerializableField;

  final List<C>? nullableListOfSerializableField;

  final Set<C> setOfSerializableField;

  final Set<C>? nullableSetOfSerializableField;

  final Map<String, C> mapOfSerializableField;

  final Map<String, C>? nullableMapOfSerializableField;
}

@JsonCodable()
class C {
  final bool boolField;
}
