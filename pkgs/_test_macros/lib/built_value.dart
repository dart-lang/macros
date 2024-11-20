// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:dart_model/dart_model.dart';
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
    // TODO(davidmorgan): query for fields, set and compare fields.
    builder.declareInType(
      augmentation('''
${valueName.name}([void Function(${builderName.code})? updates]) {}
${valueName.name}._() {}

${builderName.code} toBuilder() => ${builderName.code}()..replace(this);
${valueName.code} rebuild(void Function(${builderName.code}) updates) =>
    (toBuilder()..update(updates)).build();

  bool operator==(Object other) => other is ${valueName.code};
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

    // TODO(davidmorgan): query for fields, actually build fields.
    builder.declareInType(
      augmentation('''
void replace(${valueName.code} other) {}
void update(void Function(${builderName.code}) updates) => updates(this);
${valueName.code} build() => ${valueName.code}._();
'''),
    );
  }
}
