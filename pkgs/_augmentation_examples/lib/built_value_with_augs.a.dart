// Generated code modified by hand to use augmenations.

part of 'built_value_with_augs.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SimpleValue> _$simpleValueSerializer = new _$SimpleValueSerializer();
Serializer<VerySimpleValue> _$verySimpleValueSerializer =
    new _$VerySimpleValueSerializer();
Serializer<CompoundValue> _$compoundValueSerializer =
    new _$CompoundValueSerializer();
Serializer<ValidatedValue> _$validatedValueSerializer =
    new _$ValidatedValueSerializer();
Serializer<Account> _$accountSerializer = new _$AccountSerializer();
Serializer<WireNameValue> _$wireNameValueSerializer =
    new _$WireNameValueSerializer();

class _$SimpleValueSerializer implements StructuredSerializer<SimpleValue> {
  @override
  final Iterable<Type> types = const [SimpleValue];
  @override
  final String wireName = 'SimpleValue';

  @override
  Iterable<Object?> serialize(Serializers serializers, SimpleValue object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'anInt',
      serializers.serialize(object.anInt, specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.aString;
    if (value != null) {
      result
        ..add('aString')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  SimpleValue deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SimpleValueBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'anInt':
          result.anInt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'aString':
          result.aString = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$VerySimpleValueSerializer
    implements StructuredSerializer<VerySimpleValue> {
  @override
  final Iterable<Type> types = const [VerySimpleValue];
  @override
  final String wireName = 'VerySimpleValue';

  @override
  Iterable<Object?> serialize(Serializers serializers, VerySimpleValue object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'value',
      serializers.serialize(object.value, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  VerySimpleValue deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new VerySimpleValueBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'value':
          result.value = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
      }
    }

    return result.build();
  }
}

class _$CompoundValueSerializer implements StructuredSerializer<CompoundValue> {
  @override
  final Iterable<Type> types = const [CompoundValue];
  @override
  final String wireName = 'CompoundValue';

  @override
  Iterable<Object?> serialize(Serializers serializers, CompoundValue object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'simpleValue',
      serializers.serialize(object.simpleValue,
          specifiedType: const FullType(SimpleValue)),
    ];
    Object? value;
    value = object.validatedValue;
    if (value != null) {
      result
        ..add('validatedValue')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(ValidatedValue)));
    }
    return result;
  }

  @override
  CompoundValue deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CompoundValueBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'simpleValue':
          result.simpleValue.replace(serializers.deserialize(value,
              specifiedType: const FullType(SimpleValue))! as SimpleValue);
          break;
        case 'validatedValue':
          result.validatedValue.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ValidatedValue))!
              as ValidatedValue);
          break;
      }
    }

    return result.build();
  }
}

class _$ValidatedValueSerializer
    implements StructuredSerializer<ValidatedValue> {
  @override
  final Iterable<Type> types = const [ValidatedValue];
  @override
  final String wireName = 'ValidatedValue';

  @override
  Iterable<Object?> serialize(Serializers serializers, ValidatedValue object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'anInt',
      serializers.serialize(object.anInt, specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.aString;
    if (value != null) {
      result
        ..add('aString')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  ValidatedValue deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ValidatedValueBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'anInt':
          result.anInt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'aString':
          result.aString = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$AccountSerializer implements StructuredSerializer<Account> {
  @override
  final Iterable<Type> types = const [Account];
  @override
  final String wireName = 'Account';

  @override
  Iterable<Object?> serialize(Serializers serializers, Account object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'keyValues',
      serializers.serialize(object.keyValues,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(JsonObject)])),
    ];

    return result;
  }

  @override
  Account deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AccountBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'keyValues':
          result.keyValues.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(JsonObject)
              ]))!);
          break;
      }
    }

    return result.build();
  }
}

class _$WireNameValueSerializer implements StructuredSerializer<WireNameValue> {
  @override
  final Iterable<Type> types = const [WireNameValue];
  @override
  final String wireName = 'V';

  @override
  Iterable<Object?> serialize(Serializers serializers, WireNameValue object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'v',
      serializers.serialize(object.value, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  WireNameValue deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new WireNameValueBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'v':
          result.value = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
      }
    }

    return result.build();
  }
}

augment class SimpleValue {
  static Serializer<SimpleValue> get serializer => _$simpleValueSerializer;

  factory SimpleValue([void Function(SimpleValueBuilder)? updates]) =>
      (new SimpleValueBuilder()..update(updates)).build();

  SimpleValue._({required int anInt, String? aString}) : anInt = anInt, aString = aString {
    BuiltValueNullFieldError.checkNotNull(anInt, r'SimpleValue', 'anInt');
  }

  SimpleValue rebuild(void Function(SimpleValueBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  SimpleValueBuilder toBuilder() => new SimpleValueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SimpleValue &&
        anInt == other.anInt &&
        aString == other.aString;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, anInt.hashCode);
    _$hash = $jc(_$hash, aString.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SimpleValue')
          ..add('anInt', anInt)
          ..add('aString', aString))
        .toString();
  }
}

class SimpleValueBuilder {
  SimpleValue? _$v;

  int? _anInt;
  int? get anInt => _$this._anInt;
  set anInt(int? anInt) => _$this._anInt = anInt;

  String? _aString;
  String? get aString => _$this._aString;
  set aString(String? aString) => _$this._aString = aString;

  SimpleValueBuilder();

  SimpleValueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _anInt = $v.anInt;
      _aString = $v.aString;
      _$v = null;
    }
    return this;
  }

  void replace(SimpleValue other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other;
  }

  void update(void Function(SimpleValueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  SimpleValue build() {
    final _$result = _$v ??
        new SimpleValue._(
            anInt: BuiltValueNullFieldError.checkNotNull(
                anInt, r'SimpleValue', 'anInt'),
            aString: aString);
    replace(_$result);
    return _$result;
  }
}

augment class  VerySimpleValue {
  static Serializer<VerySimpleValue> get serializer => _$verySimpleValueSerializer;

  factory VerySimpleValue([void Function(VerySimpleValueBuilder)? updates]) =>
      (new VerySimpleValueBuilder()..update(updates)).build();

  VerySimpleValue._({required this.value}) : super._() {
    BuiltValueNullFieldError.checkNotNull(value, r'VerySimpleValue', 'value');
  }

  VerySimpleValue rebuild(void Function(VerySimpleValueBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  VerySimpleValueBuilder toBuilder() =>
      new VerySimpleValueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VerySimpleValue && value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VerySimpleValue')
          ..add('value', value))
        .toString();
  }
}

class VerySimpleValueBuilder {
  VerySimpleValue? _$v;

  int? _value;
  int? get value => _$this._value;
  set value(int? value) => _$this._value = value;

  VerySimpleValueBuilder();

  VerySimpleValueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  void replace(VerySimpleValue other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other;
  }

  void update(void Function(VerySimpleValueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  VerySimpleValue build() {
    final _$result = _$v ??
        new VerySimpleValue._(
            value: BuiltValueNullFieldError.checkNotNull(
                value, r'VerySimpleValue', 'value'));
    replace(_$result);
    return _$result;
  }
}

augment class CompoundValue {
  static Serializer<CompoundValue> get serializer => _$compoundValueSerializer;

  factory CompoundValue([void Function(CompoundValueBuilder)? updates]) =>
      (new CompoundValueBuilder()..update(updates)).build();

  CompoundValue._({required SimpleValue simpleValue, ValidatedValue? validatedValue})
      : simpleValue = simpleValue, validatedValue = validatedValue {
    BuiltValueNullFieldError.checkNotNull(
        simpleValue, r'CompoundValue', 'simpleValue');
  }

  CompoundValue rebuild(void Function(CompoundValueBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  CompoundValueBuilder toBuilder() => new CompoundValueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompoundValue &&
        simpleValue == other.simpleValue &&
        validatedValue == other.validatedValue;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, simpleValue.hashCode);
    _$hash = $jc(_$hash, validatedValue.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompoundValue')
          ..add('simpleValue', simpleValue)
          ..add('validatedValue', validatedValue))
        .toString();
  }
}

class CompoundValueBuilder {
  CompoundValue? _$v;

  SimpleValueBuilder? _simpleValue;
  SimpleValueBuilder get simpleValue =>
      _$this._simpleValue ??= new SimpleValueBuilder();
  set simpleValue(SimpleValueBuilder? simpleValue) =>
      _$this._simpleValue = simpleValue;

  ValidatedValueBuilder? _validatedValue;
  ValidatedValueBuilder get validatedValue =>
      _$this._validatedValue ??= new ValidatedValueBuilder();
  set validatedValue(ValidatedValueBuilder? validatedValue) =>
      _$this._validatedValue = validatedValue;

  CompoundValueBuilder();

  CompoundValueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _simpleValue = $v.simpleValue.toBuilder();
      _validatedValue = $v.validatedValue?.toBuilder();
      _$v = null;
    }
    return this;
  }

  void replace(CompoundValue other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other;
  }

  void update(void Function(CompoundValueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  CompoundValue build() {
    CompoundValue _$result;
    try {
      _$result = _$v ??
          new CompoundValue._(
              simpleValue: simpleValue.build(),
              validatedValue: _validatedValue?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'simpleValue';
        simpleValue.build();
        _$failedField = 'validatedValue';
        _validatedValue?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'CompoundValue', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

augment class ValidatedValue {
    static Serializer<ValidatedValue> get serializer =>
      _$validatedValueSerializer;

  factory ValidatedValue([void Function(ValidatedValueBuilder)? updates]) =>
      (new ValidatedValueBuilder()..update(updates)).build();

  augment ValidatedValue._({required int anInt, String? aString})
      : anInt = anInt, aString = aString{
    BuiltValueNullFieldError.checkNotNull(anInt, r'ValidatedValue', 'anInt');
    augmented();
  }

  ValidatedValue rebuild(void Function(ValidatedValueBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  ValidatedValueBuilder toBuilder() =>
      new ValidatedValueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ValidatedValue &&
        anInt == other.anInt &&
        aString == other.aString;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, anInt.hashCode);
    _$hash = $jc(_$hash, aString.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ValidatedValue')
          ..add('anInt', anInt)
          ..add('aString', aString))
        .toString();
  }
}

class ValidatedValueBuilder {
  ValidatedValue? _$v;

  int? _anInt;
  int? get anInt => _$this._anInt;
  set anInt(int? anInt) => _$this._anInt = anInt;

  String? _aString;
  String? get aString => _$this._aString;
  set aString(String? aString) => _$this._aString = aString;

  ValidatedValueBuilder();

  ValidatedValueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _anInt = $v.anInt;
      _aString = $v.aString;
      _$v = null;
    }
    return this;
  }

  void replace(ValidatedValue other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other;
  }

  void update(void Function(ValidatedValueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  ValidatedValue build() {
    final _$result = _$v ??
        new ValidatedValue._(
            anInt: BuiltValueNullFieldError.checkNotNull(
                anInt, r'ValidatedValue', 'anInt'),
            aString: aString);
    replace(_$result);
    return _$result;
  }
}

augment class ValueWithCode{
  factory ValueWithCode([void Function(ValueWithCodeBuilder)? updates]) =>
      (new ValueWithCodeBuilder()..update(updates))._build();

  ValueWithCode._({required int anInt, String? aString}) : this.anInt = anInt, this.aString = aString {
    BuiltValueNullFieldError.checkNotNull(anInt, r'ValueWithCode', 'anInt');
  }

  ValueWithCode rebuild(void Function(ValueWithCodeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  ValueWithCodeBuilder toBuilder() => new ValueWithCodeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ValueWithCode &&
        anInt == other.anInt &&
        aString == other.aString;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, anInt.hashCode);
    _$hash = $jc(_$hash, aString.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ValueWithCode')
          ..add('anInt', anInt)
          ..add('aString', aString))
        .toString();
  }
}

class ValueWithCodeBuilder {
  ValueWithCode? _$v;

  int? _anInt;
  int? get anInt => _$this._anInt;
  set anInt(int? anInt) => _$this._anInt = anInt;

  String? _aString;
  String? get aString => _$this._aString;
  set aString(String? aString) => _$this._aString = aString;

  ValueWithCodeBuilder();

  ValueWithCodeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _anInt = $v.anInt;
      _aString = $v.aString;
      _$v = null;
    }
    return this;
  }

  void replace(ValueWithCode other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other;
  }

  void update(void Function(ValueWithCodeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  ValueWithCode build() => _build();

  ValueWithCode _build() {
    final _$result = _$v ??
        new ValueWithCode._(
            anInt: BuiltValueNullFieldError.checkNotNull(
                anInt, r'ValueWithCode', 'anInt'),
            aString: aString);
    replace(_$result);
    return _$result;
  }
}

augment class ValueWithDefaults {
  factory ValueWithDefaults(
          [void Function(ValueWithDefaultsBuilder)? updates]) =>
      (new ValueWithDefaultsBuilder()..update(updates)).build();

  ValueWithDefaults._({required int anInt, String? aString}) : anInt = anInt, aString = aString {
    BuiltValueNullFieldError.checkNotNull(anInt, r'ValueWithDefaults', 'anInt');
  }

  ValueWithDefaults rebuild(void Function(ValueWithDefaultsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  ValueWithDefaultsBuilder toBuilder() =>
      new ValueWithDefaultsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ValueWithDefaults &&
        anInt == other.anInt &&
        aString == other.aString;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, anInt.hashCode);
    _$hash = $jc(_$hash, aString.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ValueWithDefaults')
          ..add('anInt', anInt)
          ..add('aString', aString))
        .toString();
  }
}

augment class ValueWithDefaultsBuilder {
  ValueWithDefaults? _$v;

  augment int get anInt {
    _$this;
    return augmented;
  }

  augment  set anInt(int anInt) {
    _$this;
    augmented = anInt;
  }

  augment String? get aString {
    _$this;
    return augmented;
  }

  augment set aString(String? aString) {
    _$this;
    augmented = aString;
  }

  ValueWithDefaultsBuilder();

  ValueWithDefaultsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      anInt = $v.anInt;
      aString = $v.aString;
      _$v = null;
    }
    return this;
  }

  void replace(ValueWithDefaults other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other;
  }

  void update(void Function(ValueWithDefaultsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  ValueWithDefaults build() => _build();

  ValueWithDefaults _build() {
    final _$result = _$v ??
        new ValueWithDefaults._(
            anInt: BuiltValueNullFieldError.checkNotNull(
                anInt, r'ValueWithDefaults', 'anInt'),
            aString: aString);
    replace(_$result);
    return _$result;
  }
}

augment class DerivedValue {
  int? __derivedValue;
  Iterable<String>? __derivedString;

  factory DerivedValue([void Function(DerivedValueBuilder)? updates]) =>
      (new DerivedValueBuilder()..update(updates))._build();

  DerivedValue._({required int anInt}) : anInt = anInt {
    BuiltValueNullFieldError.checkNotNull(anInt, r'DerivedValue', 'anInt');
  }

  augment int get derivedValue => __derivedValue ??= augmented;

  augment Iterable<String> get derivedString => __derivedString ??= augmented;

  DerivedValue rebuild(void Function(DerivedValueBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  DerivedValueBuilder toBuilder() => new DerivedValueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DerivedValue && anInt == other.anInt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, anInt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DerivedValue')..add('anInt', anInt))
        .toString();
  }
}

class DerivedValueBuilder {
  DerivedValue? _$v;

  int? _anInt;
  int? get anInt => _$this._anInt;
  set anInt(int? anInt) => _$this._anInt = anInt;

  DerivedValueBuilder();

  DerivedValueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _anInt = $v.anInt;
      _$v = null;
    }
    return this;
  }

  void replace(DerivedValue other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other;
  }

  void update(void Function(DerivedValueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  DerivedValue build() => _build();

  DerivedValue _build() {
    final _$result = _$v ??
        new DerivedValue._(
            anInt: BuiltValueNullFieldError.checkNotNull(
                anInt, r'DerivedValue', 'anInt'));
    replace(_$result);
    return _$result;
  }
}

augment class Account {
  static Serializer<Account> get serializer => _$accountSerializer;

  factory Account([void Function(AccountBuilder)? updates]) =>
      (new AccountBuilder()..update(updates))._build();

  Account._({required int id, required String name, required BuiltMap<String, JsonObject> keyValues})
      : id = id, name = name, keyValues = keyValues {
    BuiltValueNullFieldError.checkNotNull(id, r'Account', 'id');
    BuiltValueNullFieldError.checkNotNull(name, r'Account', 'name');
    BuiltValueNullFieldError.checkNotNull(keyValues, r'Account', 'keyValues');
  }

  Account rebuild(void Function(AccountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  AccountBuilder toBuilder() => new AccountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Account &&
        id == other.id &&
        name == other.name &&
        keyValues == other.keyValues;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, keyValues.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Account')
          ..add('id', id)
          ..add('name', name)
          ..add('keyValues', keyValues))
        .toString();
  }
}

class AccountBuilder {
  Account? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  MapBuilder<String, JsonObject>? _keyValues;
  MapBuilder<String, JsonObject> get keyValues =>
      _$this._keyValues ??= new MapBuilder<String, JsonObject>();
  set keyValues(MapBuilder<String, JsonObject>? keyValues) =>
      _$this._keyValues = keyValues;

  AccountBuilder();

  AccountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _keyValues = $v.keyValues.toBuilder();
      _$v = null;
    }
    return this;
  }

  void replace(Account other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other;
  }

  void update(void Function(AccountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  Account build() => _build();

  Account _build() {
    Account _$result;
    try {
      _$result = _$v ??
          new Account._(
              id: BuiltValueNullFieldError.checkNotNull(id, r'Account', 'id'),
              name: BuiltValueNullFieldError.checkNotNull(
                  name, r'Account', 'name'),
              keyValues: keyValues.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'keyValues';
        keyValues.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Account', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

augment class WireNameValue {
  static Serializer<WireNameValue> get serializer => _$wireNameValueSerializer;

  factory WireNameValue([void Function(WireNameValueBuilder)? updates]) =>
      (new WireNameValueBuilder()..update(updates)).build();

  WireNameValue._({required int value}) : value = value {
    BuiltValueNullFieldError.checkNotNull(value, r'WireNameValue', 'value');
  }

  WireNameValue rebuild(void Function(WireNameValueBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  WireNameValueBuilder toBuilder() => new WireNameValueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WireNameValue && value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WireNameValue')..add('value', value))
        .toString();
  }
}

class WireNameValueBuilder {
  WireNameValue? _$v;

  int? _value;
  int? get value => _$this._value;
  set value(int? value) => _$this._value = value;

  WireNameValueBuilder();

  WireNameValueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  void replace(WireNameValue other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other;
  }

  void update(void Function(WireNameValueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  WireNameValue build() {
    final _$result = _$v ??
        new WireNameValue._(
            value: BuiltValueNullFieldError.checkNotNull(
                value, r'WireNameValue', 'value'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
