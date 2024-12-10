// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:dart_model/dart_model.dart';
// ignore: implementation_imports
import 'package:dart_model/src/macro_metadata.g.dart';
import 'package:macro/macro.dart';
import 'package:macro_service/macro_service.dart';

import 'templating.dart';

/// A macro equivalent to `package:built_value` value types.
class BuiltValue {
  const BuiltValue();
}

/// A macro equivalent to `package:built_value` builders.
class BuiltValueBuilder {
  const BuiltValueBuilder();
}

class BuiltValueImplementation
    implements ClassTypesMacro, ClassDeclarationsMacro {
  @override
  MacroDescription get description => MacroDescription(
    annotation: QualifiedName(
      uri: 'package:_test_macros/built_value.dart',
      name: 'BuiltValue',
    ),
    runsInPhases: [1, 2],
  );

  @override
  Future<void> buildTypesForClass(ClassTypesBuilder<Interface> builder) async {
    final valueName = builder.model.qualifiedNameOf(builder.target.node)!;
    final builderSimpleName = '${valueName.name}Builder';
    builder.declareType(
      builderSimpleName,
      augmentation('''
@{{package:_test_macros/built_value.dart#BuiltValueBuilder}}()
class $builderSimpleName {}
'''),
    );
  }

  @override
  Future<void> buildDeclarationsForClass(
    ClassDeclarationsBuilder builder,
  ) async {
    final valueName = builder.model.qualifiedNameOf(builder.target.node)!;
    final builderName = QualifiedName(
      uri: valueName.uri,
      name: '${valueName.name}Builder',
    );

    final fields =
        builder.target.members.entries
            .where((e) => e.value.properties.isField)
            .toList();

    final constructorParams = StringBuffer();
    if (fields.isNotEmpty) {
      constructorParams.write('{');
      for (final field in fields) {
        constructorParams.write('required this.${field.key},');
      }
      constructorParams.write('}');
    }

    final computeHash = StringBuffer('{{dart:core#Object}}.hashAll([');
    for (final field in fields) {
      computeHash.write('${field.key},');
    }
    computeHash.write('])');

    final comparisons = StringBuffer();
    for (final field in fields) {
      comparisons.write('&& ${field.key} == other.${field.key}');
    }

    final toString = StringBuffer('${valueName.name}(');
    for (final field in fields) {
      toString.write('${field.key}: \$${field.key}');
      if (field != fields.last) {
        toString.write(', ');
      }
    }
    toString.write(')');

    builder.declareInType(
      augmentation('''
factory ${valueName.name}([void Function(${builderName.code})? updates]) =>
  (${builderName.code}()..update(updates)).build();
${valueName.name}._($constructorParams) {}

${builderName.code} toBuilder() => ${builderName.code}()..replace(this);
${valueName.code} rebuild(void Function(${builderName.code}) updates) =>
    (toBuilder()..update(updates)).build();

  {{dart:core#int}} get hashCode => $computeHash;

  {{dart:core#bool}} operator==({{dart:core#Object}} other) =>
      other is ${valueName.code}$comparisons;

  {{dart:core#String}} toString() => '$toString';
'''),
    );
  }
}

class BuiltValueBuilderImplementation implements ClassDeclarationsMacro {
  @override
  MacroDescription get description => MacroDescription(
    annotation: QualifiedName(
      uri: 'package:_test_macros/built_value.dart',
      name: 'BuiltValueBuilder',
    ),
    runsInPhases: [2],
  );

  @override
  Future<void> buildDeclarationsForClass(
    ClassDeclarationsBuilder builder,
  ) async {
    final builderName = builder.model.qualifiedNameOf(builder.target.node)!;
    var valueShortName = builderName.name;
    if (valueShortName.endsWith('Builder')) {
      valueShortName = valueShortName.substring(
        0,
        valueShortName.length - 'Builder'.length,
      );
    } else {
      throw StateError('Builder class should have name ending "Builder".');
    }
    final valueName = QualifiedName(uri: builderName.uri, name: valueShortName);
    await builder.query(Query(target: valueName));

    final valueInterface =
        builder.model.uris[valueName.uri]!.scopes[valueName.name]!;
    final fields =
        valueInterface.members.entries
            .where((e) => e.value.properties.isField)
            .toList();

    // Check which field types are annotated with `@BuiltValue`, meaning they
    // should use nested Builders.
    //
    // First, find all the types and query for them.
    // TODO(davidmorgan): there should be a way to do this in one query.
    final fieldTypes = <String>{};
    for (final field in fields) {
      final qualifiedName = field.value.returnType.qualifiedName;
      if (qualifiedName.uri != 'dart:core') {
        fieldTypes.add(qualifiedName.asString);
      }
    }
    for (final fieldType in fieldTypes) {
      final qualifiedName = QualifiedName.parse(fieldType);
      await builder.query(Query(target: qualifiedName));
    }

    // Now check which field types have the annotation.
    final nestedBuilderTypes = <String>{};
    for (final fieldType in fieldTypes) {
      final qualifiedName = QualifiedName.parse(fieldType);
      final fieldTypeAnnotations =
          builder
              .model
              .uris[qualifiedName.uri]!
              .scopes[qualifiedName.name]!
              .metadataAnnotations;
      for (final fieldTypeAnnotation in fieldTypeAnnotations) {
        if (fieldTypeAnnotation.expression.type !=
            ExpressionType.constructorInvocation) {
          continue;
        }
        final constructorInvocation =
            fieldTypeAnnotation.expression.asConstructorInvocation;
        if (constructorInvocation.type.type !=
            TypeAnnotationType.namedTypeAnnotation) {
          continue;
        }

        final namedTypeAnnotation =
            constructorInvocation.type.asNamedTypeAnnotation;
        if (namedTypeAnnotation.reference.type !=
            ReferenceType.classReference) {
          continue;
        }

        final constructorReference =
            namedTypeAnnotation.reference.asClassReference;
        if (constructorReference.name != 'BuiltValue') {
          continue;
        }

        nestedBuilderTypes.add(qualifiedName.asString);
      }
    }

    final fieldDeclarations = StringBuffer();
    for (final field in fields) {
      final fieldTypeQualifiedName = field.value.returnType.qualifiedName;
      if (nestedBuilderTypes.contains(fieldTypeQualifiedName.asString)) {
        final fieldBuilderQualifiedName = QualifiedName(
          uri: fieldTypeQualifiedName.uri,
          name: '${fieldTypeQualifiedName.name}Builder',
        );
        fieldDeclarations.write(
          '${fieldBuilderQualifiedName.code} ${field.key} = '
          '${fieldBuilderQualifiedName.code}();',
        );
      } else {
        fieldDeclarations.write(
          '${fieldTypeQualifiedName.code}? ${field.key};',
        );
      }
    }

    final copyFields = StringBuffer();
    for (final field in fields) {
      final fieldTypeQualifiedName = field.value.returnType.qualifiedName;
      if (nestedBuilderTypes.contains(fieldTypeQualifiedName.asString)) {
        copyFields.write('this.${field.key} = other.${field.key}.toBuilder();');
      } else {
        copyFields.write('this.${field.key} = other.${field.key};');
      }
    }

    final buildParams = StringBuffer();
    for (final field in fields) {
      final fieldTypeQualifiedName = field.value.returnType.qualifiedName;
      if (nestedBuilderTypes.contains(fieldTypeQualifiedName.asString)) {
        buildParams.write('${field.key}: ${field.key}.build(),');
      } else {
        final maybeNotNull = field.value.returnType.isNullable ? '' : '!';
        buildParams.write('${field.key}: ${field.key}$maybeNotNull,');
      }
    }

    builder.declareInType(
      augmentation('''
$fieldDeclarations

void replace(${valueName.code} other) {  $copyFields }
void update(void Function(${builderName.code})? updates) => updates?.call(this);
${valueName.code} build() => ${valueName.code}._($buildParams);
'''),
    );
  }
}

extension StaticTypeDescExtension on StaticTypeDesc {
  bool get isNullable => type == StaticTypeDescType.nullableTypeDesc;

  QualifiedName get qualifiedName {
    return switch (type) {
      StaticTypeDescType.namedTypeDesc => asNamedTypeDesc.name,
      StaticTypeDescType.nullableTypeDesc =>
        asNullableTypeDesc.inner.qualifiedName,
      _ => throw ArgumentError(type),
    };
  }
}
