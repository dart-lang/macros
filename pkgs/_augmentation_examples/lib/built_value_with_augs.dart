// Copyright (c) 2024, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';

part 'built_value_with_augs.g.dart';

// @BuiltValue(serializable: true)
class SimpleValue {
  final int anInt;
  final String? aString;
}

// @BuiltValue(serializable: true)
class VerySimpleValue {
  final int value;
}

// @BuiltValue(serializable: true)
class CompoundValue {
  final SimpleValue simpleValue;
  final ValidatedValue? validatedValue;
}

// @BuiltValue(serializable: true)
class ValidatedValue {
  final int anInt;
  final String? aString;

  ValidatedValue._() {
    if (anInt == 7) throw StateError('anInt may not be 7');
  }
}

// @BuiltValue()
class ValueWithCode {
  static final int youCanHaveStaticFields = 3;

  final int anInt;
  final String? aString;

  String get youCanWriteDerivedGetters => anInt.toString() + aString!;

  factory ValueWithCode.fromCustomFactory(int anInt) => ValueWithCode(
    (b) =>
        b
          ..anInt = anInt
          ..aString = 'two',
  );
}

// @BuiltValue()
class ValueWithDefaults {
  final int anInt;
  final String? aString;
}

// @BuiltValueBuilder()
class ValueWithDefaultsBuilder {
  int anInt = 7;
  String? aString;
}

// @BuiltValue()
class DerivedValue {
  final int anInt;

  @memoized
  int get derivedValue => anInt + 10;

  @memoized
  Iterable<String> get derivedString => [toString()];
}

// @BuiltValue(serializable: true)
class Account {
  final int id;
  final String name;
  final BuiltMap<String, JsonObject> keyValues;
}

// @BuiltValue(wireName: 'V')
class WireNameValue {
  // @BuiltValueField(wireName: 'v')
  final int value;
}
