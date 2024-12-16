// Generated code modified by hand to use augmenations.

part of 'freezed_with_augs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$$DataImplFromJson(Map<String, dynamic> json) =>
    Data((json['value'] as num).toInt(), $type: json['runtimeType'] as String?);

Map<String, dynamic> _$$DataImplToJson(Data instance) => <String, dynamic>{
  'value': instance.value,
  'runtimeType': instance.$type,
};

Loading _$$LoadingImplFromJson(Map<String, dynamic> json) =>
    Loading($type: json['runtimeType'] as String?);

Map<String, dynamic> _$$LoadingImplToJson(Loading instance) =>
    <String, dynamic>{'runtimeType': instance.$type};

ErrorDetails _$$ErrorDetailsImplFromJson(Map<String, dynamic> json) =>
    ErrorDetails(json['message'] as String?, json['runtimeType'] as String?);

Map<String, dynamic> _$$ErrorDetailsImplToJson(ErrorDetails instance) =>
    <String, dynamic>{
      'message': instance.message,
      'runtimeType': instance.$type,
    };

Complex _$$ComplexImplFromJson(Map<String, dynamic> json) => Complex(
  (json['a'] as num).toInt(),
  json['b'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$ComplexImplToJson(Complex instance) =>
    <String, dynamic>{
      'a': instance.a,
      'b': instance.b,
      'runtimeType': instance.$type,
    };
