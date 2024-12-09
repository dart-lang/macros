// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'freezed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MyClass {
  String? get a => throw _privateConstructorUsedError;
  int? get b => throw _privateConstructorUsedError;

  /// Create a copy of MyClass
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MyClassCopyWith<MyClass> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyClassCopyWith<$Res> {
  factory $MyClassCopyWith(MyClass value, $Res Function(MyClass) then) =
      _$MyClassCopyWithImpl<$Res, MyClass>;
  @useResult
  $Res call({String? a, int? b});
}

/// @nodoc
class _$MyClassCopyWithImpl<$Res, $Val extends MyClass>
    implements $MyClassCopyWith<$Res> {
  _$MyClassCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MyClass
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? a = freezed,
    Object? b = freezed,
  }) {
    return _then(_value.copyWith(
      a: freezed == a
          ? _value.a
          : a // ignore: cast_nullable_to_non_nullable
              as String?,
      b: freezed == b
          ? _value.b
          : b // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MyClassImplCopyWith<$Res> implements $MyClassCopyWith<$Res> {
  factory _$$MyClassImplCopyWith(
          _$MyClassImpl value, $Res Function(_$MyClassImpl) then) =
      __$$MyClassImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? a, int? b});
}

/// @nodoc
class __$$MyClassImplCopyWithImpl<$Res>
    extends _$MyClassCopyWithImpl<$Res, _$MyClassImpl>
    implements _$$MyClassImplCopyWith<$Res> {
  __$$MyClassImplCopyWithImpl(
      _$MyClassImpl _value, $Res Function(_$MyClassImpl) _then)
      : super(_value, _then);

  /// Create a copy of MyClass
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? a = freezed,
    Object? b = freezed,
  }) {
    return _then(_$MyClassImpl(
      a: freezed == a
          ? _value.a
          : a // ignore: cast_nullable_to_non_nullable
              as String?,
      b: freezed == b
          ? _value.b
          : b // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$MyClassImpl implements _MyClass {
  _$MyClassImpl({this.a, this.b});

  @override
  final String? a;
  @override
  final int? b;

  @override
  String toString() {
    return 'MyClass(a: $a, b: $b)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MyClassImpl &&
            (identical(other.a, a) || other.a == a) &&
            (identical(other.b, b) || other.b == b));
  }

  @override
  int get hashCode => Object.hash(runtimeType, a, b);

  /// Create a copy of MyClass
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MyClassImplCopyWith<_$MyClassImpl> get copyWith =>
      __$$MyClassImplCopyWithImpl<_$MyClassImpl>(this, _$identity);
}

abstract class _MyClass implements MyClass {
  factory _MyClass({final String? a, final int? b}) = _$MyClassImpl;

  @override
  String? get a;
  @override
  int? get b;

  /// Create a copy of MyClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MyClassImplCopyWith<_$MyClassImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Union _$UnionFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'default':
      return Data.fromJson(json);
    case 'loading':
      return Loading.fromJson(json);
    case 'error':
      return ErrorDetails.fromJson(json);
    case 'complex':
      return Complex.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'Union',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$Union {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int value) $default, {
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(int a, String b) complex,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int value)? $default, {
    TResult? Function()? loading,
    TResult? Function(String? message)? error,
    TResult? Function(int a, String b)? complex,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int value)? $default, {
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(int a, String b)? complex,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data value) $default, {
    required TResult Function(Loading value) loading,
    required TResult Function(ErrorDetails value) error,
    required TResult Function(Complex value) complex,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(Data value)? $default, {
    TResult? Function(Loading value)? loading,
    TResult? Function(ErrorDetails value)? error,
    TResult? Function(Complex value)? complex,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Loading value)? loading,
    TResult Function(ErrorDetails value)? error,
    TResult Function(Complex value)? complex,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this Union to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnionCopyWith<$Res> {
  factory $UnionCopyWith(Union value, $Res Function(Union) then) =
      _$UnionCopyWithImpl<$Res, Union>;
}

/// @nodoc
class _$UnionCopyWithImpl<$Res, $Val extends Union>
    implements $UnionCopyWith<$Res> {
  _$UnionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Union
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DataImplCopyWith<$Res> {
  factory _$$DataImplCopyWith(
          _$DataImpl value, $Res Function(_$DataImpl) then) =
      __$$DataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int value});
}

/// @nodoc
class __$$DataImplCopyWithImpl<$Res>
    extends _$UnionCopyWithImpl<$Res, _$DataImpl>
    implements _$$DataImplCopyWith<$Res> {
  __$$DataImplCopyWithImpl(_$DataImpl _value, $Res Function(_$DataImpl) _then)
      : super(_value, _then);

  /// Create a copy of Union
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$DataImpl(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DataImpl implements Data {
  const _$DataImpl(this.value, {final String? $type})
      : $type = $type ?? 'default';

  factory _$DataImpl.fromJson(Map<String, dynamic> json) =>
      _$$DataImplFromJson(json);

  @override
  final int value;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Union(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  /// Create a copy of Union
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DataImplCopyWith<_$DataImpl> get copyWith =>
      __$$DataImplCopyWithImpl<_$DataImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int value) $default, {
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(int a, String b) complex,
  }) {
    return $default(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int value)? $default, {
    TResult? Function()? loading,
    TResult? Function(String? message)? error,
    TResult? Function(int a, String b)? complex,
  }) {
    return $default?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int value)? $default, {
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(int a, String b)? complex,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data value) $default, {
    required TResult Function(Loading value) loading,
    required TResult Function(ErrorDetails value) error,
    required TResult Function(Complex value) complex,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(Data value)? $default, {
    TResult? Function(Loading value)? loading,
    TResult? Function(ErrorDetails value)? error,
    TResult? Function(Complex value)? complex,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Loading value)? loading,
    TResult Function(ErrorDetails value)? error,
    TResult Function(Complex value)? complex,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DataImplToJson(
      this,
    );
  }
}

abstract class Data implements Union {
  const factory Data(final int value) = _$DataImpl;

  factory Data.fromJson(Map<String, dynamic> json) = _$DataImpl.fromJson;

  int get value;

  /// Create a copy of Union
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DataImplCopyWith<_$DataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$UnionCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of Union
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$LoadingImpl implements Loading {
  const _$LoadingImpl({final String? $type}) : $type = $type ?? 'loading';

  factory _$LoadingImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoadingImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Union.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int value) $default, {
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(int a, String b) complex,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int value)? $default, {
    TResult? Function()? loading,
    TResult? Function(String? message)? error,
    TResult? Function(int a, String b)? complex,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int value)? $default, {
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(int a, String b)? complex,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data value) $default, {
    required TResult Function(Loading value) loading,
    required TResult Function(ErrorDetails value) error,
    required TResult Function(Complex value) complex,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(Data value)? $default, {
    TResult? Function(Loading value)? loading,
    TResult? Function(ErrorDetails value)? error,
    TResult? Function(Complex value)? complex,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Loading value)? loading,
    TResult Function(ErrorDetails value)? error,
    TResult Function(Complex value)? complex,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LoadingImplToJson(
      this,
    );
  }
}

abstract class Loading implements Union {
  const factory Loading() = _$LoadingImpl;

  factory Loading.fromJson(Map<String, dynamic> json) = _$LoadingImpl.fromJson;
}

/// @nodoc
abstract class _$$ErrorDetailsImplCopyWith<$Res> {
  factory _$$ErrorDetailsImplCopyWith(
          _$ErrorDetailsImpl value, $Res Function(_$ErrorDetailsImpl) then) =
      __$$ErrorDetailsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$ErrorDetailsImplCopyWithImpl<$Res>
    extends _$UnionCopyWithImpl<$Res, _$ErrorDetailsImpl>
    implements _$$ErrorDetailsImplCopyWith<$Res> {
  __$$ErrorDetailsImplCopyWithImpl(
      _$ErrorDetailsImpl _value, $Res Function(_$ErrorDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Union
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$ErrorDetailsImpl(
      freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ErrorDetailsImpl implements ErrorDetails {
  const _$ErrorDetailsImpl([this.message, final String? $type])
      : $type = $type ?? 'error';

  factory _$ErrorDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ErrorDetailsImplFromJson(json);

  @override
  final String? message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Union.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorDetailsImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Union
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorDetailsImplCopyWith<_$ErrorDetailsImpl> get copyWith =>
      __$$ErrorDetailsImplCopyWithImpl<_$ErrorDetailsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int value) $default, {
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(int a, String b) complex,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int value)? $default, {
    TResult? Function()? loading,
    TResult? Function(String? message)? error,
    TResult? Function(int a, String b)? complex,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int value)? $default, {
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(int a, String b)? complex,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data value) $default, {
    required TResult Function(Loading value) loading,
    required TResult Function(ErrorDetails value) error,
    required TResult Function(Complex value) complex,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(Data value)? $default, {
    TResult? Function(Loading value)? loading,
    TResult? Function(ErrorDetails value)? error,
    TResult? Function(Complex value)? complex,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Loading value)? loading,
    TResult Function(ErrorDetails value)? error,
    TResult Function(Complex value)? complex,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ErrorDetailsImplToJson(
      this,
    );
  }
}

abstract class ErrorDetails implements Union {
  const factory ErrorDetails([final String? message]) = _$ErrorDetailsImpl;

  factory ErrorDetails.fromJson(Map<String, dynamic> json) =
      _$ErrorDetailsImpl.fromJson;

  String? get message;

  /// Create a copy of Union
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorDetailsImplCopyWith<_$ErrorDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ComplexImplCopyWith<$Res> {
  factory _$$ComplexImplCopyWith(
          _$ComplexImpl value, $Res Function(_$ComplexImpl) then) =
      __$$ComplexImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int a, String b});
}

/// @nodoc
class __$$ComplexImplCopyWithImpl<$Res>
    extends _$UnionCopyWithImpl<$Res, _$ComplexImpl>
    implements _$$ComplexImplCopyWith<$Res> {
  __$$ComplexImplCopyWithImpl(
      _$ComplexImpl _value, $Res Function(_$ComplexImpl) _then)
      : super(_value, _then);

  /// Create a copy of Union
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? a = null,
    Object? b = null,
  }) {
    return _then(_$ComplexImpl(
      null == a
          ? _value.a
          : a // ignore: cast_nullable_to_non_nullable
              as int,
      null == b
          ? _value.b
          : b // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ComplexImpl implements Complex {
  const _$ComplexImpl(this.a, this.b, {final String? $type})
      : $type = $type ?? 'complex';

  factory _$ComplexImpl.fromJson(Map<String, dynamic> json) =>
      _$$ComplexImplFromJson(json);

  @override
  final int a;
  @override
  final String b;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Union.complex(a: $a, b: $b)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ComplexImpl &&
            (identical(other.a, a) || other.a == a) &&
            (identical(other.b, b) || other.b == b));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, a, b);

  /// Create a copy of Union
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ComplexImplCopyWith<_$ComplexImpl> get copyWith =>
      __$$ComplexImplCopyWithImpl<_$ComplexImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int value) $default, {
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(int a, String b) complex,
  }) {
    return complex(a, b);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int value)? $default, {
    TResult? Function()? loading,
    TResult? Function(String? message)? error,
    TResult? Function(int a, String b)? complex,
  }) {
    return complex?.call(a, b);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int value)? $default, {
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(int a, String b)? complex,
    required TResult orElse(),
  }) {
    if (complex != null) {
      return complex(a, b);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data value) $default, {
    required TResult Function(Loading value) loading,
    required TResult Function(ErrorDetails value) error,
    required TResult Function(Complex value) complex,
  }) {
    return complex(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(Data value)? $default, {
    TResult? Function(Loading value)? loading,
    TResult? Function(ErrorDetails value)? error,
    TResult? Function(Complex value)? complex,
  }) {
    return complex?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Data value)? $default, {
    TResult Function(Loading value)? loading,
    TResult Function(ErrorDetails value)? error,
    TResult Function(Complex value)? complex,
    required TResult orElse(),
  }) {
    if (complex != null) {
      return complex(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ComplexImplToJson(
      this,
    );
  }
}

abstract class Complex implements Union {
  const factory Complex(final int a, final String b) = _$ComplexImpl;

  factory Complex.fromJson(Map<String, dynamic> json) = _$ComplexImpl.fromJson;

  int get a;
  String get b;

  /// Create a copy of Union
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ComplexImplCopyWith<_$ComplexImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SharedProperty {
  String? get name => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? name, int? age) person,
    required TResult Function(String? name, int? population) city,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? name, int? age)? person,
    TResult? Function(String? name, int? population)? city,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? name, int? age)? person,
    TResult Function(String? name, int? population)? city,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SharedProperty0 value) person,
    required TResult Function(SharedProperty1 value) city,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SharedProperty0 value)? person,
    TResult? Function(SharedProperty1 value)? city,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SharedProperty0 value)? person,
    TResult Function(SharedProperty1 value)? city,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of SharedProperty
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SharedPropertyCopyWith<SharedProperty> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SharedPropertyCopyWith<$Res> {
  factory $SharedPropertyCopyWith(
          SharedProperty value, $Res Function(SharedProperty) then) =
      _$SharedPropertyCopyWithImpl<$Res, SharedProperty>;
  @useResult
  $Res call({String? name});
}

/// @nodoc
class _$SharedPropertyCopyWithImpl<$Res, $Val extends SharedProperty>
    implements $SharedPropertyCopyWith<$Res> {
  _$SharedPropertyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SharedProperty
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SharedProperty0ImplCopyWith<$Res>
    implements $SharedPropertyCopyWith<$Res> {
  factory _$$SharedProperty0ImplCopyWith(_$SharedProperty0Impl value,
          $Res Function(_$SharedProperty0Impl) then) =
      __$$SharedProperty0ImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, int? age});
}

/// @nodoc
class __$$SharedProperty0ImplCopyWithImpl<$Res>
    extends _$SharedPropertyCopyWithImpl<$Res, _$SharedProperty0Impl>
    implements _$$SharedProperty0ImplCopyWith<$Res> {
  __$$SharedProperty0ImplCopyWithImpl(
      _$SharedProperty0Impl _value, $Res Function(_$SharedProperty0Impl) _then)
      : super(_value, _then);

  /// Create a copy of SharedProperty
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? age = freezed,
  }) {
    return _then(_$SharedProperty0Impl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      age: freezed == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$SharedProperty0Impl implements SharedProperty0 {
  _$SharedProperty0Impl({this.name, this.age});

  @override
  final String? name;
  @override
  final int? age;

  @override
  String toString() {
    return 'SharedProperty.person(name: $name, age: $age)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharedProperty0Impl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.age, age) || other.age == age));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, age);

  /// Create a copy of SharedProperty
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SharedProperty0ImplCopyWith<_$SharedProperty0Impl> get copyWith =>
      __$$SharedProperty0ImplCopyWithImpl<_$SharedProperty0Impl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? name, int? age) person,
    required TResult Function(String? name, int? population) city,
  }) {
    return person(name, age);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? name, int? age)? person,
    TResult? Function(String? name, int? population)? city,
  }) {
    return person?.call(name, age);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? name, int? age)? person,
    TResult Function(String? name, int? population)? city,
    required TResult orElse(),
  }) {
    if (person != null) {
      return person(name, age);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SharedProperty0 value) person,
    required TResult Function(SharedProperty1 value) city,
  }) {
    return person(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SharedProperty0 value)? person,
    TResult? Function(SharedProperty1 value)? city,
  }) {
    return person?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SharedProperty0 value)? person,
    TResult Function(SharedProperty1 value)? city,
    required TResult orElse(),
  }) {
    if (person != null) {
      return person(this);
    }
    return orElse();
  }
}

abstract class SharedProperty0 implements SharedProperty {
  factory SharedProperty0({final String? name, final int? age}) =
      _$SharedProperty0Impl;

  @override
  String? get name;
  int? get age;

  /// Create a copy of SharedProperty
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SharedProperty0ImplCopyWith<_$SharedProperty0Impl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SharedProperty1ImplCopyWith<$Res>
    implements $SharedPropertyCopyWith<$Res> {
  factory _$$SharedProperty1ImplCopyWith(_$SharedProperty1Impl value,
          $Res Function(_$SharedProperty1Impl) then) =
      __$$SharedProperty1ImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, int? population});
}

/// @nodoc
class __$$SharedProperty1ImplCopyWithImpl<$Res>
    extends _$SharedPropertyCopyWithImpl<$Res, _$SharedProperty1Impl>
    implements _$$SharedProperty1ImplCopyWith<$Res> {
  __$$SharedProperty1ImplCopyWithImpl(
      _$SharedProperty1Impl _value, $Res Function(_$SharedProperty1Impl) _then)
      : super(_value, _then);

  /// Create a copy of SharedProperty
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? population = freezed,
  }) {
    return _then(_$SharedProperty1Impl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      population: freezed == population
          ? _value.population
          : population // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$SharedProperty1Impl implements SharedProperty1 {
  _$SharedProperty1Impl({this.name, this.population});

  @override
  final String? name;
  @override
  final int? population;

  @override
  String toString() {
    return 'SharedProperty.city(name: $name, population: $population)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharedProperty1Impl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.population, population) ||
                other.population == population));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, population);

  /// Create a copy of SharedProperty
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SharedProperty1ImplCopyWith<_$SharedProperty1Impl> get copyWith =>
      __$$SharedProperty1ImplCopyWithImpl<_$SharedProperty1Impl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? name, int? age) person,
    required TResult Function(String? name, int? population) city,
  }) {
    return city(name, population);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? name, int? age)? person,
    TResult? Function(String? name, int? population)? city,
  }) {
    return city?.call(name, population);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? name, int? age)? person,
    TResult Function(String? name, int? population)? city,
    required TResult orElse(),
  }) {
    if (city != null) {
      return city(name, population);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SharedProperty0 value) person,
    required TResult Function(SharedProperty1 value) city,
  }) {
    return city(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SharedProperty0 value)? person,
    TResult? Function(SharedProperty1 value)? city,
  }) {
    return city?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SharedProperty0 value)? person,
    TResult Function(SharedProperty1 value)? city,
    required TResult orElse(),
  }) {
    if (city != null) {
      return city(this);
    }
    return orElse();
  }
}

abstract class SharedProperty1 implements SharedProperty {
  factory SharedProperty1({final String? name, final int? population}) =
      _$SharedProperty1Impl;

  @override
  String? get name;
  int? get population;

  /// Create a copy of SharedProperty
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SharedProperty1ImplCopyWith<_$SharedProperty1Impl> get copyWith =>
      throw _privateConstructorUsedError;
}
