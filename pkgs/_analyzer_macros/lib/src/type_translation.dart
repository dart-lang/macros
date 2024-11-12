// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/type_visitor.dart';
import 'package:dart_model/dart_model.dart' as model;

import '../macro_implementation.dart';

final class TypeTranslationContext {
  final Map<TypeParameterElement, int> _typeParameterIds = {};

  int idFor(TypeParameterElement parameter) {
    return _typeParameterIds.putIfAbsent(
      parameter,
      () => _typeParameterIds.length,
    );
  }
}

final class AnalyzerTypesToMacros
    extends
        UnifyingTypeVisitorWithArgument<
          model.StaticTypeDesc,
          TypeTranslationContext
        > {
  const AnalyzerTypesToMacros();

  model.StaticTypeParameterDesc translateTypeParameter(
    TypeParameterElement param,
    TypeTranslationContext context,
  ) {
    final id = context.idFor(param);
    return model.StaticTypeParameterDesc(
      identifier: id,
      bound: param.bound?.acceptWithArgument(this, context),
    );
  }

  @override
  model.StaticTypeDesc visitDartType(
    DartType type,
    TypeTranslationContext argument,
  ) {
    return {'type': '_unknown'} as model.StaticTypeDesc;
  }

  @override
  model.StaticTypeDesc visitDynamicType(
    DynamicType type,
    TypeTranslationContext argument,
  ) {
    return model.StaticTypeDesc.dynamicTypeDesc(
      model.DynamicTypeDesc(),
    ).applyNullabilitySuffix(type.nullabilitySuffix);
  }

  @override
  model.StaticTypeDesc visitFunctionType(
    FunctionType type,
    TypeTranslationContext argument,
  ) {
    return model.StaticTypeDesc.functionTypeDesc(
      model.FunctionTypeDesc(
        typeParameters: [
          for (final typeParam in type.typeFormals)
            translateTypeParameter(typeParam, argument),
        ],
        returnType: type.returnType.acceptWithArgument(this, argument),
        requiredPositionalParameters: [
          for (final positional in type.normalParameterTypes)
            positional.acceptWithArgument(this, argument),
        ],
        optionalPositionalParameters: [
          for (final positional in type.parameters)
            if (positional.isOptionalPositional)
              positional.type.acceptWithArgument(this, argument),
        ],
        namedParameters: [
          for (final named in type.parameters)
            if (named.isNamed)
              model.NamedFunctionTypeParameter(
                type: named.type.acceptWithArgument(this, argument),
                name: named.name,
                required: named.isRequiredNamed,
              ),
        ],
      ),
    ).applyNullabilitySuffix(type.nullabilitySuffix);
  }

  @override
  model.StaticTypeDesc visitInterfaceType(
    InterfaceType type,
    TypeTranslationContext argument,
  ) {
    final element = type.element;
    return model.StaticTypeDesc.namedTypeDesc(
      model.NamedTypeDesc(
        name: element.qualifiedName,
        instantiation: [
          for (final arg in type.typeArguments)
            arg.acceptWithArgument(this, argument),
        ],
      ),
    ).applyNullabilitySuffix(type.nullabilitySuffix);
  }

  @override
  model.StaticTypeDesc visitNeverType(
    NeverType type,
    TypeTranslationContext argument,
  ) {
    return model.StaticTypeDesc.neverTypeDesc(
      model.NeverTypeDesc(),
    ).applyNullabilitySuffix(type.nullabilitySuffix);
  }

  @override
  model.StaticTypeDesc visitRecordType(
    RecordType type,
    TypeTranslationContext argument,
  ) {
    return model.StaticTypeDesc.recordTypeDesc(
      model.RecordTypeDesc(
        positional: [
          for (final positional in type.positionalFields)
            positional.type.acceptWithArgument(this, argument),
        ],
        named: [
          for (final named in type.namedFields)
            model.NamedRecordField(
              name: named.name,
              type: named.type.acceptWithArgument(this, argument),
            ),
        ],
      ),
    ).applyNullabilitySuffix(type.nullabilitySuffix);
  }

  @override
  model.StaticTypeDesc visitTypeParameterType(
    TypeParameterType type,
    TypeTranslationContext argument,
  ) {
    return model.StaticTypeDesc.typeParameterTypeDesc(
      model.TypeParameterTypeDesc(parameterId: argument.idFor(type.element)),
    ).applyNullabilitySuffix(type.nullabilitySuffix);
  }

  @override
  model.StaticTypeDesc visitVoidType(
    VoidType type,
    TypeTranslationContext argument,
  ) {
    return model.StaticTypeDesc.voidTypeDesc(
      model.VoidTypeDesc(),
    ).applyNullabilitySuffix(type.nullabilitySuffix);
  }
}

extension on model.StaticTypeDesc {
  model.StaticTypeDesc applyNullabilitySuffix(NullabilitySuffix suffix) {
    if (suffix == NullabilitySuffix.question) {
      return model.StaticTypeDesc.nullableTypeDesc(
        model.NullableTypeDesc(inner: this),
      );
    } else {
      return this;
    }
  }
}
