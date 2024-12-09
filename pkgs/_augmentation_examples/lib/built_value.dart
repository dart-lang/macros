// Copyright (c) 2024, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';

part 'built_value.g.dart';

abstract class SimpleValue implements Built<SimpleValue, SimpleValueBuilder> {
  static Serializer<SimpleValue> get serializer => _$simpleValueSerializer;

  int get anInt;

  String? get aString;

  factory SimpleValue([void Function(SimpleValueBuilder) updates]) =
      _$SimpleValue;
  SimpleValue._();
}

abstract class VerySimpleValue
    implements Built<VerySimpleValue, VerySimpleValueBuilder> {
  static Serializer<VerySimpleValue> get serializer =>
      _$verySimpleValueSerializer;

  int get value;

  factory VerySimpleValue(int value) => _$VerySimpleValue._(value: value);
  VerySimpleValue._();
}

abstract class CompoundValue
    implements Built<CompoundValue, CompoundValueBuilder> {
  static Serializer<CompoundValue> get serializer => _$compoundValueSerializer;

  SimpleValue get simpleValue;
  ValidatedValue? get validatedValue;

  factory CompoundValue([void Function(CompoundValueBuilder) updates]) =
      _$CompoundValue;
  CompoundValue._();
}

abstract class ValidatedValue
    implements Built<ValidatedValue, ValidatedValueBuilder> {
  static Serializer<ValidatedValue> get serializer =>
      _$validatedValueSerializer;

  int get anInt;
  String? get aString;

  factory ValidatedValue([void Function(ValidatedValueBuilder) updates]) =
      _$ValidatedValue;

  ValidatedValue._() {
    if (anInt == 7) throw StateError('anInt may not be 7');
  }
}

abstract class ValueWithCode
    implements Built<ValueWithCode, ValueWithCodeBuilder> {
  static final int youCanHaveStaticFields = 3;

  int get anInt;
  String? get aString;

  String get youCanWriteDerivedGetters => anInt.toString() + aString!;

  factory ValueWithCode([void Function(ValueWithCodeBuilder) updates]) =
      _$ValueWithCode;
  ValueWithCode._();

  factory ValueWithCode.fromCustomFactory(int anInt) => ValueWithCode(
    (b) =>
        b
          ..anInt = anInt
          ..aString = 'two',
  );
}

abstract class ValueWithDefaults
    implements Built<ValueWithDefaults, ValueWithDefaultsBuilder> {
  int get anInt;
  String? get aString;

  factory ValueWithDefaults([void Function(ValueWithDefaultsBuilder) updates]) =
      _$ValueWithDefaults;
  ValueWithDefaults._();
}

abstract class ValueWithDefaultsBuilder
    implements Builder<ValueWithDefaults, ValueWithDefaultsBuilder> {
  int anInt = 7;

  String? aString;

  factory ValueWithDefaultsBuilder() = _$ValueWithDefaultsBuilder;
  ValueWithDefaultsBuilder._();
}

abstract class DerivedValue
    implements Built<DerivedValue, DerivedValueBuilder> {
  int get anInt;

  @memoized
  int get derivedValue => anInt + 10;

  @memoized
  Iterable<String> get derivedString => [toString()];

  factory DerivedValue([void Function(DerivedValueBuilder) updates]) =
      _$DerivedValue;
  DerivedValue._();
}

abstract class Account implements Built<Account, AccountBuilder> {
  static Serializer<Account> get serializer => _$accountSerializer;
  int get id;
  String get name;
  BuiltMap<String, JsonObject> get keyValues;

  factory Account([void Function(AccountBuilder) updates]) = _$Account;
  Account._();
}

@BuiltValue(wireName: 'V')
abstract class WireNameValue
    implements Built<WireNameValue, WireNameValueBuilder> {
  static Serializer<WireNameValue> get serializer => _$wireNameValueSerializer;

  @BuiltValueField(wireName: 'v')
  int get value;

  factory WireNameValue([void Function(WireNameValueBuilder) updates]) =
      _$WireNameValue;

  WireNameValue._();
}
