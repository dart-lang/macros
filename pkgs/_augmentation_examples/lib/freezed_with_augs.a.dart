// Generated code modified by hand to use augmenations.

part of 'freezed_with_augs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
augment class MyClass {
  final String? a;
  final int? b;

  augment MyClass({String? a, int? b}) : a = a, b = b;

  @override
  String toString() {
    return 'MyClass(a: $a, b: $b)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MyClass &&
            (identical(other.a, a) || other.a == a) &&
            (identical(other.b, b) || other.b == b));
  }

  @override
  int get hashCode => Object.hash(runtimeType, a, b);

  /// Create a copy of MyClass
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$$MyClassImplCopyWith<MyClass> get copyWith =>
      __$$MyClassImplCopyWithImpl<MyClass>(this, _$identity);
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
  $Res call({Object? a = freezed, Object? b = freezed}) {
    return _then(
      _value.copyWith(
            a:
                freezed == a
                    ? _value.a
                    : a // ignore: cast_nullable_to_non_nullable
                        as String?,
            b:
                freezed == b
                    ? _value.b
                    : b // ignore: cast_nullable_to_non_nullable
                        as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MyClassImplCopyWith<$Res> implements $MyClassCopyWith<$Res> {
  factory _$$MyClassImplCopyWith(
    MyClass value,
    $Res Function(MyClass) then,
  ) = __$$MyClassImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? a, int? b});
}

/// @nodoc
class __$$MyClassImplCopyWithImpl<$Res>
    extends _$MyClassCopyWithImpl<$Res, MyClass>
    implements _$$MyClassImplCopyWith<$Res> {
  __$$MyClassImplCopyWithImpl(
    MyClass _value,
    $Res Function(MyClass) _then,
  ) : super(_value, _then);

  /// Create a copy of MyClass
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? a = freezed, Object? b = freezed}) {
    return _then(
      MyClass(
        a:
            freezed == a
                ? _value.a
                : a // ignore: cast_nullable_to_non_nullable
                    as String?,
        b:
            freezed == b
                ? _value.b
                : b // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
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
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'Union',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
augment class Union {
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
    Data value,
    $Res Function(Data) then,
  ) = __$$DataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int value});
}

/// @nodoc
class __$$DataImplCopyWithImpl<$Res>
    extends _$UnionCopyWithImpl<$Res, Data>
    implements _$$DataImplCopyWith<$Res> {
  __$$DataImplCopyWithImpl(Data _value, $Res Function(Data) _then)
    : super(_value, _then);

  /// Create a copy of Union
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? value = null}) {
    return _then(
      Data(
        null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class Data implements Union {
  const Data(this.value, {final String? $type})
    : $type = $type ?? 'default';

  factory Data.fromJson(Map<String, dynamic> json) =>
      _$$DataImplFromJson(json);

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
            other is Data &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  /// Create a copy of Union
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$$DataImplCopyWith<Data> get copyWith =>
      __$$DataImplCopyWithImpl<Data>(this, _$identity);

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int value) $default, {
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(int a, String b) complex,
  }) {
    return $default(value);
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int value)? $default, {
    TResult? Function()? loading,
    TResult? Function(String? message)? error,
    TResult? Function(int a, String b)? complex,
  }) {
    return $default?.call(value);
  }

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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Data value) $default, {
    required TResult Function(Loading value) loading,
    required TResult Function(ErrorDetails value) error,
    required TResult Function(Complex value) complex,
  }) {
    return $default(this);
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(Data value)? $default, {
    TResult? Function(Loading value)? loading,
    TResult? Function(ErrorDetails value)? error,
    TResult? Function(Complex value)? complex,
  }) {
    return $default?.call(this);
  }

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

  Map<String, dynamic> toJson() {
    return _$$DataImplToJson(this);
  }
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
    Loading value,
    $Res Function(Loading) then,
  ) = __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$UnionCopyWithImpl<$Res, Loading>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
    Loading _value,
    $Res Function(Loading) _then,
  ) : super(_value, _then);

  /// Create a copy of Union
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class Loading implements Union {
  const Loading({final String? $type}) : $type = $type ?? 'loading';

  factory Loading.fromJson(Map<String, dynamic> json) =>
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
        (other.runtimeType == runtimeType && other is Loading);
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
    return _$$LoadingImplToJson(this);
  }
}

/// @nodoc
abstract class _$$ErrorDetailsImplCopyWith<$Res> {
  factory _$$ErrorDetailsImplCopyWith(
    ErrorDetails value,
    $Res Function(ErrorDetails) then,
  ) = __$$ErrorDetailsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$ErrorDetailsImplCopyWithImpl<$Res>
    extends _$UnionCopyWithImpl<$Res, ErrorDetails>
    implements _$$ErrorDetailsImplCopyWith<$Res> {
  __$$ErrorDetailsImplCopyWithImpl(
    ErrorDetails _value,
    $Res Function(ErrorDetails) _then,
  ) : super(_value, _then);

  /// Create a copy of Union
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = freezed}) {
    return _then(
      ErrorDetails(
        freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class ErrorDetails implements Union {
  const ErrorDetails([this.message, final String? $type])
    : $type = $type ?? 'error';

  factory ErrorDetails.fromJson(Map<String, dynamic> json) =>
      _$$ErrorDetailsImplFromJson(json);

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
            other is ErrorDetails &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Union
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$$ErrorDetailsImplCopyWith<ErrorDetails> get copyWith =>
      __$$ErrorDetailsImplCopyWithImpl<ErrorDetails>(this, _$identity);

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
    return _$$ErrorDetailsImplToJson(this);
  }
}

/// @nodoc
abstract class _$$ComplexImplCopyWith<$Res> {
  factory _$$ComplexImplCopyWith(
    Complex value,
    $Res Function(Complex) then,
  ) = __$$ComplexImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int a, String b});
}

/// @nodoc
class __$$ComplexImplCopyWithImpl<$Res>
    extends _$UnionCopyWithImpl<$Res, Complex>
    implements _$$ComplexImplCopyWith<$Res> {
  __$$ComplexImplCopyWithImpl(
    Complex _value,
    $Res Function(Complex) _then,
  ) : super(_value, _then);

  /// Create a copy of Union
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? a = null, Object? b = null}) {
    return _then(
      Complex(
        null == a
            ? _value.a
            : a // ignore: cast_nullable_to_non_nullable
                as int,
        null == b
            ? _value.b
            : b // ignore: cast_nullable_to_non_nullable
                as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class Complex implements Union {
  const Complex(this.a, this.b, {final String? $type})
    : $type = $type ?? 'complex';

  factory Complex.fromJson(Map<String, dynamic> json) =>
      _$$ComplexImplFromJson(json);

  final int a;
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
            other is Complex &&
            (identical(other.a, a) || other.a == a) &&
            (identical(other.b, b) || other.b == b));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, a, b);

  /// Create a copy of Union
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$$ComplexImplCopyWith<Complex> get copyWith =>
      __$$ComplexImplCopyWithImpl<Complex>(this, _$identity);

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
    return _$$ComplexImplToJson(this);
  }
}

/// @nodoc
augment class SharedProperty {
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
    SharedProperty value,
    $Res Function(SharedProperty) then,
  ) = _$SharedPropertyCopyWithImpl<$Res, SharedProperty>;
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
  $Res call({Object? name = freezed}) {
    return _then(
      _value.copyWith(
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SharedProperty0ImplCopyWith<$Res>
    implements $SharedPropertyCopyWith<$Res> {
  factory _$$SharedProperty0ImplCopyWith(
    SharedProperty0 value,
    $Res Function(SharedProperty0) then,
  ) = __$$SharedProperty0ImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, int? age});
}

/// @nodoc
class __$$SharedProperty0ImplCopyWithImpl<$Res>
    extends _$SharedPropertyCopyWithImpl<$Res, SharedProperty0>
    implements _$$SharedProperty0ImplCopyWith<$Res> {
  __$$SharedProperty0ImplCopyWithImpl(
    SharedProperty0 _value,
    $Res Function(SharedProperty0) _then,
  ) : super(_value, _then);

  /// Create a copy of SharedProperty
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = freezed, Object? age = freezed}) {
    return _then(
      SharedProperty0(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        age:
            freezed == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
}

/// @nodoc

class SharedProperty0 implements SharedProperty {
  SharedProperty0({this.name, this.age});

  @override
  final String? name;
  final int? age;

  @override
  String toString() {
    return 'SharedProperty.person(name: $name, age: $age)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SharedProperty0 &&
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
  _$$SharedProperty0ImplCopyWith<SharedProperty0> get copyWith =>
      __$$SharedProperty0ImplCopyWithImpl<SharedProperty0>(
        this,
        _$identity,
      );

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

/// @nodoc
abstract class _$$SharedProperty1ImplCopyWith<$Res>
    implements $SharedPropertyCopyWith<$Res> {
  factory _$$SharedProperty1ImplCopyWith(
    SharedProperty1 value,
    $Res Function(SharedProperty1) then,
  ) = __$$SharedProperty1ImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, int? population});
}

/// @nodoc
class __$$SharedProperty1ImplCopyWithImpl<$Res>
    extends _$SharedPropertyCopyWithImpl<$Res, SharedProperty1>
    implements _$$SharedProperty1ImplCopyWith<$Res> {
  __$$SharedProperty1ImplCopyWithImpl(
    SharedProperty1 _value,
    $Res Function(SharedProperty1) _then,
  ) : super(_value, _then);

  /// Create a copy of SharedProperty
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = freezed, Object? population = freezed}) {
    return _then(
      SharedProperty1(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        population:
            freezed == population
                ? _value.population
                : population // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
}

/// @nodoc

class SharedProperty1 implements SharedProperty {
  SharedProperty1({this.name, this.population});

  @override
  final String? name;
  final int? population;

  @override
  String toString() {
    return 'SharedProperty.city(name: $name, population: $population)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SharedProperty1 &&
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
  _$$SharedProperty1ImplCopyWith<SharedProperty1> get copyWith =>
      __$$SharedProperty1ImplCopyWithImpl<SharedProperty1>(
        this,
        _$identity,
      );

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
