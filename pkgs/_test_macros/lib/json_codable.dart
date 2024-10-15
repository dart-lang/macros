// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';
import 'package:macro/macro.dart';
import 'package:macro_service/macro_service.dart';

import 'templating.dart';

/// A macro which adds a `fromJson(Map<String, Object?> json)` JSON decoding
/// constructor to a class.
class JsonCodable {
  const JsonCodable();
}

final _jsonMapTypeForLiteral = '<{{dart:core#String}}, {{dart:core#Object}}?>';
final _jsonMapType = '{{dart:core#Map}}$_jsonMapTypeForLiteral';
final _mapEntryType = '{{dart:core#MapEntry}}';

class JsonCodableImplementation
    implements ClassDeclarationsMacro, ClassDefinitionsMacro {
  @override
  MacroDescription get description => MacroDescription(
      annotation: QualifiedName(
          uri: 'package:_test_macros/json_codable.dart', name: 'JsonCodable'),
      runsInPhases: [2, 3]);

  @override
  Future<AugmentResponse> buildDeclarationsForClass(
      Interface target, Model model, Host host) async {
    final qualifiedName = model.qualifiedNameOf(target.node)!;
    return AugmentResponse(augmentations: [
      Augmentation(code: expandTemplate('''
// TODO(davidmorgan): see https://github.com/dart-lang/macros/issues/80.
// external ${qualifiedName.name}.fromJson($_jsonMapType json);
// external $_jsonMapType toJson();
   '''))
    ]);
  }

  @override
  Future<AugmentResponse> buildDefinitionsForClass(
      Interface target, Model model, Host host) async {
    final qualifiedName = model.qualifiedNameOf(target.node)!;
    // TODO(davidmorgan): put `extends` information directly in `Interface`.
    final superclassName =
        MacroScope.current.typeSystem.supertypeOf(qualifiedName);

    return AugmentResponse(augmentations: [
      await _generateFromJson(
          host, model, qualifiedName, superclassName, target),
      await _generateToJson(host, model, qualifiedName, superclassName, target)
    ]);
  }

  Future<Augmentation> _generateFromJson(
    Host host,
    Model model,
    QualifiedName target,
    QualifiedName superclassName,
    Interface clazz,
  ) async {
    var superclassHasFromJson = false;
    // TODO(davidmorgan): add recommended way to check for core types.
    if (superclassName.asString != 'dart:core#Object') {
      // TODO(davidmorgan): first query could already fetch the super class.
      final supermodel = await host.query(Query(target: superclassName));
      final superclass =
          supermodel.uris[superclassName.uri]!.scopes[superclassName.name]!;
      final constructor = superclass.members['fromJson'];
      if (constructor != null && _isValidFromJsonConstructor(constructor)) {
        superclassHasFromJson = true;
      } else {
        // TODO(davidmorgan): report as a diagnostic.
        throw ArgumentError(
            'Serialization of classes that extend other classes is only '
            'supported if those classes have a valid '
            '`fromJson(Map<String, Object?> json)` constructor.');
      }
    }

    final initializers = <String>[];
    for (final field
        in clazz.members.entries.where((m) => m.value.properties.isField)) {
      final name = field.key;
      final type = field.value.returnType;
      initializers
          .add('$name = ${_convertTypeFromJson("json[r'$name']", type)}');
    }

    if (superclassHasFromJson) {
      initializers.add('super.fromJson(json)');
    }

    // TODO(davidmorgan): helper for augmenting initializers.
    // See: https://github.com/dart-lang/sdk/blob/main/pkg/_macros/lib/src/executor/builder_impls.dart#L500
    return Augmentation(code: expandTemplate('''
augment ${target.name}.fromJson($_jsonMapType json) :
${initializers.join(',\n')};
'''));
  }

  Future<Augmentation> _generateToJson(
    Host host,
    Model model,
    QualifiedName target,
    QualifiedName superclassName,
    Interface clazz,
  ) async {
    var superclassHasToJson = false;
    if (superclassName.asString != 'dart:core#Object') {
      // TODO(davidmorgan): first query could already fetch the super class.
      final supermodel = await host.query(Query(target: superclassName));
      final superclass =
          supermodel.uris[superclassName.uri]!.scopes[superclassName.name]!;
      final method = superclass.members['toJson'];
      if (method != null && _isValidToJsonMethod(method)) {
        superclassHasToJson = true;
      } else {
        // TODO(davidmorgan): report as a diagnostic.
        throw ArgumentError(
            'Serialization of classes that extend other classes is only '
            'supported if those classes have a valid '
            '`Map<String, Object?> json toJson()` method.');
      }
    }

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
    final jsonInitializer =
        superclassHasToJson ? 'super.toJson()' : '$_jsonMapTypeForLiteral{}';
    return Augmentation(code: expandTemplate('''
augment $_jsonMapType toJson() {
  final json = $jsonInitializer;
${serializers.join('')}
  return json;
}
'''));
  }

  /// Returns whether [constructor] is a constructor
  /// `fromJson(Map<String, Object?>)`.
  bool _isValidFromJsonConstructor(Member constructor) =>
      constructor.properties.isConstructor &&
      constructor.optionalPositionalParameters.isEmpty &&
      constructor.namedParameters.isEmpty &&
      constructor.requiredPositionalParameters.length == 1 &&
      constructor.requiredPositionalParameters[0].type ==
          StaticTypeDescType.namedTypeDesc &&
      _isJsonMapType(
          constructor.requiredPositionalParameters[0].asNamedTypeDesc);

  /// Returns whether [method] is a method
  /// `toJson(Map<String, Object?>)`.
  bool _isValidToJsonMethod(Member method) =>
      method.properties.isMethod &&
      !method.properties.isStatic &&
      method.requiredPositionalParameters.isEmpty &&
      method.optionalPositionalParameters.isEmpty &&
      method.namedParameters.isEmpty &&
      _isJsonMapType(method.returnType.asNamedTypeDesc);

  /// Returns whether [type] is a type `Map<String, Object?>)`.
  bool _isJsonMapType(NamedTypeDesc type) =>
      type.name.asString == 'dart:core#Map' &&
      type.instantiation[0].asNamedTypeDesc.name.asString ==
          'dart:core#String' &&
      type.instantiation[1].type == StaticTypeDescType.nullableTypeDesc &&
      type.instantiation[1].asNullableTypeDesc.inner.asNamedTypeDesc.name
              .asString ==
          'dart:core#Object';

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
