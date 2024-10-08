// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';
import 'package:dart_model/templating.dart';
import 'package:macro/macro.dart';
import 'package:macro_service/macro_service.dart';

/// A macro which adds a `fromJson(Map<String, Object?> json)` JSON decoding
/// constructor to a class.
class JsonCodable {
  const JsonCodable();
}

final _jsonMapTypeForLiteral = '<{{dart:core#String}}, {{dart:core#Object}}?>';
final _jsonMapType = '{{dart:core#Map}}$_jsonMapTypeForLiteral';
final _mapEntryType = '{{dart:core#MapEntry}}';

class JsonCodableImplementation implements Macro {
  @override
  MacroDescription get description => MacroDescription(
      annotation: QualifiedName(
          uri: 'package:_test_macros/json_codable.dart', name: 'JsonCodable'),
      runsInPhases: [2, 3]);

  @override
  Future<AugmentResponse> augment(Host host, AugmentRequest request) async {
    return switch (request.phase) {
      2 => phase2(host, request),
      3 => phase3(host, request),
      _ => AugmentResponse(augmentations: []),
    };
  }

  Future<AugmentResponse> phase2(Host host, AugmentRequest request) async {
    final target = request.target;
    return AugmentResponse(augmentations: [
      Augmentation(code: expandTemplate('''
// TODO(davidmorgan): see https://github.com/dart-lang/macros/issues/80.
// external ${target.name}.fromJson($_jsonMapType json);
// external $_jsonMapType toJson();
   '''))
    ]);
  }

  Future<AugmentResponse> phase3(Host host, AugmentRequest request) async {
    final result = <Augmentation>[];

    final target = request.target;
    final model = await host.query(Query(target: target));
    final clazz = model.uris[target.uri]!.scopes[target.name]!;
    // TODO(davidmorgan): check for super `fromJson`.
    final initializers = <String>[];
    for (final field
        in clazz.members.entries.where((m) => m.value.properties.isField)) {
      final name = field.key;
      final type = field.value.returnType;
      initializers
          .add('$name = ${_convertTypeFromJson("json[r'$name']", type)}');
    }

    // TODO(davidmorgan): helper for augmenting initializers.
    // See: https://github.com/dart-lang/sdk/blob/main/pkg/_macros/lib/src/executor/builder_impls.dart#L500
    result.add(Augmentation(code: expandTemplate('''
augment ${target.name}.fromJson($_jsonMapType json) :
${initializers.join(',\n')};
''')));

    final serializers = <String>[];
    for (final field
        in clazz.members.entries.where((m) => m.value.properties.isField)) {
      final name = field.key;
      final type = field.value.returnType;
      var serializer = "json[r'$name'] = ${_convertTypeToJson(name, type)};\n";
      if (type.type == StaticTypeDescType.nullableTypeDesc) {
        serializer = 'if ($name != null) {\n$serializer}\n';
      }
      serializers.add(serializer);
    }

    // TODO(davidmorgan): helper for augmenting methods.
    // See: https://github.com/dart-lang/sdk/blob/main/pkg/_macros/lib/src/executor/builder_impls.dart#L500
    result.add(Augmentation(code: expandTemplate('''
augment $_jsonMapType toJson() {
  final json = $_jsonMapTypeForLiteral{};
${serializers.join('')}
  return json;
}
''')));

    return AugmentResponse(augmentations: result);
  }

  String _convertTypeFromJson(String reference, StaticTypeDesc type) {
    // TODO(davidmorgan): _checkNamedType equivalent.
    // TODO(davidmorgan): should this code use `StaticType` and related classes
    // instead of using the extension types `StaticTypeDesc` directly?
    // TODO(davidmorgan): check for and handle missing type argument(s).
    final nullable = type.type == StaticTypeDescType.nullableTypeDesc;
    final orNull = nullable ? '?' : '';
    final nullCheck = nullable ? '$reference == null ? null : ' : '';
    final underlyingType = type.type == StaticTypeDescType.nullableTypeDesc
        ? type.asNullableTypeDesc.inner
        : type;

    if (underlyingType.type == StaticTypeDescType.namedTypeDesc) {
      final namedType = underlyingType.asNamedTypeDesc;
      if (namedType.name.uri == 'dart:core') {
        switch (namedType.name.name) {
          case 'bool':
          case 'String':
          case 'int':
          case 'double':
          case 'num':
            return '$reference as ${namedType.name.code}$orNull';
          case 'List':
            final type = namedType.instantiation.single;
            return '$nullCheck [for (final item in $reference '
                'as {{dart:core#List}}<{{dart:core#Object}}?>) '
                '${_convertTypeFromJson('item', type)}'
                ']';
          case 'Set':
            final type = namedType.instantiation.single;
            return '$nullCheck {for (final item in $reference '
                'as {{dart:core#List}}<{{dart:core#Object}}?>) '
                '${_convertTypeFromJson('item', type)}'
                '}';
          case 'Map':
            // TODO(davidmorgan): check for and handle wrong key type.
            return '$nullCheck {for (final $_mapEntryType(:key, :value) '
                'in ($reference '
                'as $_jsonMapType).entries) key: '
                '${_convertTypeFromJson('value', namedType.instantiation.last)}'
                '}';
        }
      }
      // TODO(davidmorgan): check for fromJson constructor.
      return '$nullCheck ${namedType.name.code}.fromJson($reference as '
          '$_jsonMapType)';
    }

    // TODO(davidmorgan): error reporting.
    throw UnsupportedError('$type');
  }

  String _convertTypeToJson(String reference, StaticTypeDesc type) {
    // TODO(davidmorgan): add _checkNamedType equivalent.
    final nullable = type.type == StaticTypeDescType.nullableTypeDesc;
    final nullCheck = nullable ? '$reference == null ? null : ' : '';
    final nullCheckedReference = nullable ? '$reference!' : reference;
    final underlyingType = type.type == StaticTypeDescType.nullableTypeDesc
        ? type.asNullableTypeDesc.inner
        : type;

    if (underlyingType.type == StaticTypeDescType.namedTypeDesc) {
      final namedType = underlyingType.asNamedTypeDesc;
      if (namedType.name.uri == 'dart:core') {
        switch (namedType.name.name) {
          case 'bool':
          case 'String':
          case 'int':
          case 'double':
          case 'num':
            return reference;
          case 'List':
          case 'Set':
            return '$nullCheck [for (final item in $nullCheckedReference) '
                '${_convertTypeToJson('item', namedType.instantiation.first)}'
                ']';
          case 'Map':
            return '$nullCheck {for (final $_mapEntryType(:key, :value) in '
                '$nullCheckedReference.entries) key: '
                '${_convertTypeToJson('value', namedType.instantiation.last)}'
                '}';
        }
      }
      // TODO(davidmorgan): check for toJson method.
      return '$nullCheck $reference.toJson()';
    }

    // TODO(davidmorgan): error reporting.
    throw UnsupportedError('$type');
  }
}

// TODO(davidmorgan): figure out where this should go.
extension TemplatingExtension on QualifiedName {
  String get code => '{{$uri#$name}}';
}
