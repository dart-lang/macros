// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:dart_model/dart_model.dart' as model;
import 'package:kernel/kernel.dart' as kernel;

final class TypeTranslationContext {
  final Map<kernel.Node /* StructuralTypeParameter | TypeParameter */, int>
  _typeParameterIds = {};

  int idFor(kernel.Node parameter) {
    return _typeParameterIds.putIfAbsent(
      parameter,
      () => _typeParameterIds.length,
    );
  }
}

final class KernelTypeToMacros
    extends
        kernel.DartTypeVisitor1<model.StaticTypeDesc, TypeTranslationContext>
    with
        kernel.DartTypeVisitor1DefaultMixin<
          model.StaticTypeDesc,
          TypeTranslationContext
        > {
  const KernelTypeToMacros();

  model.StaticTypeParameterDesc translateTypeParameter(
    kernel.TypeParameter param,
    TypeTranslationContext context,
  ) {
    return _translateTypeParameter(param, context, param.bound);
  }

  model.StaticTypeParameterDesc translateStructuralParameter(
    kernel.StructuralParameter param,
    TypeTranslationContext context,
  ) {
    return _translateTypeParameter(param, context, param.bound);
  }

  model.StaticTypeParameterDesc _translateTypeParameter(
    kernel.Node node,
    TypeTranslationContext context,
    kernel.DartType? bound,
  ) {
    final id = context.idFor(node);
    return model.StaticTypeParameterDesc(
      identifier: id,
      bound: bound?.accept1(this, context),
    );
  }

  @override
  model.StaticTypeDesc defaultDartType(
    kernel.DartType node,
    TypeTranslationContext arg,
  ) {
    return {'type': '_unknown'} as model.StaticTypeDesc;
  }

  @override
  model.StaticTypeDesc visitDynamicType(
    kernel.DynamicType node,
    TypeTranslationContext arg,
  ) {
    return model.StaticTypeDesc.dynamicTypeDesc(model.DynamicTypeDesc());
  }

  @override
  model.StaticTypeDesc visitFunctionType(
    kernel.FunctionType node,
    TypeTranslationContext arg,
  ) {
    return model.StaticTypeDesc.functionTypeDesc(
      model.FunctionTypeDesc(
        typeParameters: [
          for (final typeParam in node.typeParameters)
            translateStructuralParameter(typeParam, arg),
        ],
        returnType: node.returnType.accept1(this, arg),
        requiredPositionalParameters: [
          for (final positional in node.positionalParameters.take(
            node.requiredParameterCount,
          ))
            positional.accept1(this, arg),
        ],
        optionalPositionalParameters: [
          for (final positional in node.positionalParameters.skip(
            node.requiredParameterCount,
          ))
            positional.accept1(this, arg),
        ],
        namedParameters: [
          for (final named in node.namedParameters)
            model.NamedFunctionTypeParameter(
              type: named.type.accept1(this, arg),
              name: named.name,
              required: named.isRequired,
            ),
        ],
      ),
    ).applyNullability(node.declaredNullability);
  }

  @override
  model.StaticTypeDesc visitFutureOrType(
    kernel.FutureOrType node,
    TypeTranslationContext arg,
  ) {
    // Pretend that this is a `FutureOr` class instantiation, which macros use
    // to represent `FutureOr` types.
    return model.StaticTypeDesc.namedTypeDesc(
      model.NamedTypeDesc(
        name: model.QualifiedName(uri: 'dart:async', name: 'FutureOr'),
        instantiation: [node.typeArgument.accept1(this, arg)],
      ),
    ).applyNullability(node.declaredNullability);
  }

  @override
  model.StaticTypeDesc visitInterfaceType(
    kernel.InterfaceType node,
    TypeTranslationContext arg,
  ) {
    final definingClass = node.classNode;
    final library = definingClass.enclosingLibrary;

    return model.StaticTypeDesc.namedTypeDesc(
      model.NamedTypeDesc(
        name: model.QualifiedName(
          uri: '${library.importUri}',
          name: definingClass.name,
        ),
        instantiation: [
          for (final typeArg in node.typeArguments) typeArg.accept1(this, arg),
        ],
      ),
    ).applyNullability(node.declaredNullability);
  }

  @override
  model.StaticTypeDesc visitNeverType(
    kernel.NeverType node,
    TypeTranslationContext arg,
  ) {
    return model.StaticTypeDesc.neverTypeDesc(
      model.NeverTypeDesc(),
    ).applyNullability(node.declaredNullability);
  }

  @override
  model.StaticTypeDesc visitRecordType(
    kernel.RecordType node,
    TypeTranslationContext arg,
  ) {
    return model.StaticTypeDesc.recordTypeDesc(
      model.RecordTypeDesc(
        positional: [
          for (final positional in node.positional)
            positional.accept1(this, arg),
        ],
        named: [
          for (final named in node.named)
            model.NamedRecordField(
              name: named.name,
              type: named.type.accept1(this, arg),
            ),
        ],
      ),
    ).applyNullability(node.declaredNullability);
  }

  @override
  model.StaticTypeDesc visitTypedefType(
    kernel.TypedefType node,
    TypeTranslationContext arg,
  ) {
    // Type aliases are not represented in the macro type hierarchy.
    return node.unalias.accept1(this, arg);
  }

  @override
  model.StaticTypeDesc visitTypeParameterType(
    kernel.TypeParameterType node,
    TypeTranslationContext arg,
  ) {
    return model.StaticTypeDesc.typeParameterTypeDesc(
      model.TypeParameterTypeDesc(parameterId: arg.idFor(node.parameter)),
    ).applyNullability(node.declaredNullability);
  }

  @override
  model.StaticTypeDesc visitStructuralParameterType(
    kernel.StructuralParameterType node,
    TypeTranslationContext arg,
  ) {
    return model.StaticTypeDesc.typeParameterTypeDesc(
      model.TypeParameterTypeDesc(parameterId: arg.idFor(node.parameter)),
    ).applyNullability(node.declaredNullability);
  }

  @override
  model.StaticTypeDesc visitVoidType(
    kernel.VoidType node,
    TypeTranslationContext arg,
  ) {
    return model.StaticTypeDesc.voidTypeDesc(model.VoidTypeDesc());
  }
}

extension on model.StaticTypeDesc {
  model.StaticTypeDesc applyNullability(kernel.Nullability nullability) {
    if (nullability == kernel.Nullability.nullable) {
      return model.StaticTypeDesc.nullableTypeDesc(
        model.NullableTypeDesc(inner: this),
      );
    } else {
      return this;
    }
  }
}
