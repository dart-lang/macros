// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';
import 'package:macro/macro.dart';
import 'package:macro_service/macro_service.dart';

/// A macro which adds a `fromJson(Map<String, Object?> json)` JSON decoding
/// constructor to a class.
class JsonCodable {
  const JsonCodable();
}

final _jsonMapType =
    '{{dart:core#Map}}<{{dart:core#String}}, {{dart:core#Object}}?>';

class JsonCodableImplementation implements Macro {
  @override
  MacroDescription get description => MacroDescription(
      annotation: QualifiedName(
          uri: 'package:_test_macros/json_codable.dart', name: 'JsonCodable'),
      runsInPhases: [2, 3]);

  @override
  Future<AugmentResponse> augment(Host host, AugmentRequest request) async {
    return switch (request.phase) {
      1 => phase1(host, request),
      2 => phase2(host, request),
      _ => AugmentResponse(augmentations: []),
    };
  }

  Future<AugmentResponse> phase1(Host host, AugmentRequest request) async {
    final target = request.target;
    return AugmentResponse(augmentations: [
      Augmentation(code: '''
external ${target.code}.fromJson($_jsonMapType json);
external $_jsonMapType toJson();
   '''),
    ]);
  }

  Future<AugmentResponse> phase2(Host host, AugmentRequest request) async {
    final result = <Augmentation>[];

    final target = request.target;
    final model = await host.query(Query(target: target));
    final clazz = model.uris[target.uri]!.scopes[target.name]!;
    final initializers = <String>[];
    for (final field
        in clazz.members.entries.where((m) => m.value.properties.isField)) {
      final name = field.key;
      final type = field.value.returnType;
      initializers
          .add('$name = ${_convertTypeFromJson("json[r'$name']", type)}');
    }

    // TODO(davidmorgan): helper for augmenting initializers.
    result.add(Augmentation(code: '''
augment ${target.code}.fromJson($_jsonMapType json) :
${initializers.join(',\n')};
'''));

    final serializers = <String>[];
    for (final field
        in clazz.members.entries.where((m) => m.value.properties.isField)) {
      final name = field.key;
      final type = field.value.returnType;
      serializers.add("json[r'$name'] = ${_convertTypeToJson(name, type)}");
    }

    // TODO(davidmorgan): helper for augmenting methods.
    result.add(Augmentation(code: '''
$_jsonMapType toJson() {
${serializers.join(';\n')}
};
'''));

    return AugmentResponse(augmentations: result);
  }

  String _convertTypeFromJson(String reference, StaticTypeDesc type) {
    // TODO(davidmorgan): _checkNamedType equivalent.
    final nullable = type.type == StaticTypeDescType.nullableTypeDesc;
    final orNull = nullable ? '?' : '';
    final nullCheck = nullable ? '' : '$reference == null ? null : ';
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
            return '$nullCheck [for (final item in $reference '
                'as {{dart:core#List}}<{{dart:core#Object}}?>) '
                '${_convertTypeFromJson('item', namedType.instantiation.first)}'
                ']';
          case 'Set':
            return '$nullCheck {for (final item in $reference '
                'as {{dart:core#Set}}<{{dart:core#Object}}?>) '
                '${_convertTypeFromJson('item', namedType.instantiation.first)}'
                '}';
          case 'Map':
            return '$nullCheck {for (final (:key, :value) in $reference '
                'as $_jsonMapType) key: '
                '${_convertTypeFromJson('value', namedType.instantiation.last)}'
                '}';
        }
      }
      // TODO(davidmorgan): check for fromJson constructor.
      return '$nullCheck ${namedType.name.code}.fromJson($reference as '
          '$_jsonMapType';
    }

    // TODO(davidmorgan): error reporting.
    throw UnsupportedError('$type');
  }

  String _convertTypeToJson(String reference, StaticTypeDesc type) {
    // TODO(davidmorgan): add _checkNamedType equivalent.
    final nullable = type.type == StaticTypeDescType.nullableTypeDesc;
    final nullCheck = nullable ? '' : '$reference == null ? null : ';
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
            return '$nullCheck {for (final item in $reference) '
                '${_convertTypeToJson('item', namedType.instantiation.first)}'
                '}';
          case 'Map':
            return '$nullCheck {for (final (:key, :value) in '
                '$reference.entries) key: '
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
