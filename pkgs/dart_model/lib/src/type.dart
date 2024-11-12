// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'dart_model.dart';
import 'type_system.dart';

/// A resolved representation of static type extracted from the [StaticTypeDesc]
/// protocol models.
///
/// This representation can be converted from and to [StaticTypeDesc]s without
/// losing information, but is designed to make some type operations more
/// efficent to represent: First, it uses Dart's type hierarchy, allowing
/// subtype checks and pattern matching to test for different kinds of types.
/// Second, it is able to describe recursive type structures enabled by type
/// parameterss referencing themselves (e.g. `<T extends Comparable<T>>`)
/// directly without requiring a level of indirection.
sealed class StaticType {
  const StaticType._();

  /// Converts a serialized type [description] from the model into a
  /// [StaticType].
  ///
  /// The [translatedParameters] are a map of [StaticTypeParameterDesc.identifier]
  /// to their resolved [StaticTypeParameter] instance available from the
  /// context of this type. For self-contained type descriptions, an empty map
  /// is sufficient. To parse types inside a structure containing type
  /// parameters (e.g. the return type of a generic function), all available
  /// type parameters need to be provided as context.
  factory StaticType(
    StaticTypeDesc description, {
    Map<int, StaticTypeParameter>? translatedParameters,
  }) {
    return _translateFromDescription(description, translatedParameters ?? {});
  }

  static StaticType _translateFromDescription(
    StaticTypeDesc description,
    Map<int, StaticTypeParameter> knownTypeParameters,
  ) {
    return switch (description.type) {
      StaticTypeDescType.dynamicTypeDesc => const DynamicType(),
      StaticTypeDescType.neverTypeDesc => const NeverType(),
      StaticTypeDescType.nullableTypeDesc => NullableType(
        _translateFromDescription(
          description.asNullableTypeDesc.inner,
          knownTypeParameters,
        ),
      ),
      StaticTypeDescType.namedTypeDesc => InterfaceType._translateFrom(
        description.asNamedTypeDesc,
        knownTypeParameters,
      ),
      StaticTypeDescType.recordTypeDesc => RecordType(
        positional: [
          for (final positional in description.asRecordTypeDesc.positional)
            _translateFromDescription(positional, knownTypeParameters),
        ],
        named: {
          for (final named in description.asRecordTypeDesc.named)
            named.name: _translateFromDescription(
              named.type,
              knownTypeParameters,
            ),
        },
      ),
      StaticTypeDescType.functionTypeDesc => FunctionType._translateFrom(
        description.asFunctionTypeDesc,
        knownTypeParameters,
      ),
      StaticTypeDescType.typeParameterTypeDesc => TypeParameterType(
        parameter:
            knownTypeParameters[description
                .asTypeParameterTypeDesc
                .parameterId]!,
      ),
      StaticTypeDescType.voidTypeDesc => const VoidType(),
      _ => _UnknownType(description),
    };
  }

  /// The protocol-level description of this type.
  StaticTypeDesc get description =>
      _buildDescription(_StaticTypeToDescription());

  StaticTypeDesc _buildDescription(_StaticTypeToDescription context);

  /// Calls the appropriate `visit` method on the [visitor] depending on the
  /// kind of type.
  ///
  /// For types that are unknown to this macro client, e.g. because a new type
  /// representation has been added to the SDK, this method throws an error.
  Ret accept<Arg, Ret>(TypeVisitor<Arg, Ret> visitor, Arg arg);

  /// Returns whether `this` type is a subtype of [other] under the type system
  /// of the current resolved model.
  bool isSubtypeOf(StaticType other) {
    return StaticTypeSystem.current.isSubtype(this, other);
  }

  /// Returns whether `this` type is semantically equal to [other] under the
  /// type system of the current resolved model.
  ///
  /// Two types are equal if they are subtypes of each other. For instance,
  /// `Never?` and `Null` are equal types.
  bool isEqualTo(StaticType other) {
    return StaticTypeSystem.current.areEqual(this, other);
  }
}

/// An unknown type from the schema that doesn't have a known representation.
///
/// This type is introcuced to handle schema changes introducing new types in
/// future Dart versions - we can't introspect these types without upgrading
/// the macro implementation, but we don't break existing programs not using
/// these types.
final class _UnknownType extends StaticType {
  final StaticTypeDesc _original;

  _UnknownType(this._original) : super._();

  @override
  StaticTypeDesc _buildDescription(_StaticTypeToDescription context) {
    return _original;
  }

  @override
  Ret accept<Arg, Ret>(TypeVisitor<Arg, Ret> visitor, Arg arg) {
    throw UnsupportedError('Unknown type encountered.');
  }
}

/// Context passed around [StaticType._buildDescription] to keep track of which
/// type parameters have been assigned which identifiers in the serialized form.
/// Introducing this level of indirection is required to handle recursive
/// type structures (e.g. `Function<T extends LinkedListEntry<T>>()`).
final class _StaticTypeToDescription {
  final Map<StaticTypeParameter, int> parameterIds = {};

  int referenceParameter(StaticTypeParameter parameter) {
    return parameterIds[parameter]!;
  }

  int uniqueIdFor(StaticTypeParameter parameter) {
    return parameterIds[parameter] = parameterIds.length;
  }
}

/// A type backed by a class, mixin, interface or extension type.
final class InterfaceType extends StaticType {
  /// The name introducing this type.
  final QualifiedName name;

  /// The instantiation this type, containing the type arguments passed to the
  /// type parameters on [name].
  ///
  /// For instance, the type `Future<void>` would be represented with a single-
  /// element [instantiation] containing a [VoidType].
  final List<StaticType> instantiation;

  const InterfaceType({required this.name, required this.instantiation})
    : super._();

  static InterfaceType _translateFrom(
    NamedTypeDesc desc,
    Map<int, StaticTypeParameter> parameters,
  ) {
    return InterfaceType(
      name: desc.name,
      instantiation: [
        for (final type in desc.instantiation)
          StaticType._translateFromDescription(type, parameters),
      ],
    );
  }

  bool get isDartCoreObject => name.equals(objectName);
  bool get isDartCoreNull => name.equals(nullName);
  bool get isDartCoreFunction => name.equals(functionName);
  bool get isDartCoreRecord => name.equals(recordName);
  bool get isDartAsyncFutureOr => name.equals(futureOrName);

  @override
  StaticTypeDesc _buildDescription(_StaticTypeToDescription context) {
    return StaticTypeDesc.namedTypeDesc(
      NamedTypeDesc(
        name: name,
        instantiation: [
          for (final type in instantiation) type._buildDescription(context),
        ],
      ),
    );
  }

  @override
  Ret accept<Arg, Ret>(TypeVisitor<Arg, Ret> visitor, Arg arg) {
    return visitor.visitInterfaceType(this, arg);
  }

  /// The [QualifiedName] for the [Object] type in `dart:core`.
  static final QualifiedName objectName = QualifiedName(
    uri: 'dart:core',
    name: 'Object',
  );

  /// The [QualifiedName] for the [Null] type in `dart:core`.
  static final QualifiedName nullName = QualifiedName(
    uri: 'dart:core',
    name: 'Null',
  );

  /// The [QualifiedName] for the [Function] type in `dart:core`.
  static final QualifiedName functionName = QualifiedName(
    uri: 'dart:core',
    name: 'Function',
  );

  /// The [QualifiedName] for the [Record] type in `dart:core`.
  static final QualifiedName recordName = QualifiedName(
    uri: 'dart:core',
    name: 'Record',
  );

  /// The [QualifiedName] for the [FutureOr] type in `dart:async`.
  static final QualifiedName futureOrName = QualifiedName(
    uri: 'dart:async',
    name: 'FutureOr',
  );
}

/// A type of the form `T?`.
final class NullableType extends StaticType {
  /// The inner type `T` in `T?`.
  final StaticType inner;

  const NullableType(this.inner) : super._();

  @override
  StaticTypeDesc _buildDescription(_StaticTypeToDescription context) {
    return StaticTypeDesc.nullableTypeDesc(
      NullableTypeDesc(inner: inner._buildDescription(context)),
    );
  }

  @override
  Ret accept<Arg, Ret>(TypeVisitor<Arg, Ret> visitor, Arg arg) {
    return visitor.visitNullableType(this, arg);
  }
}

final class StaticTypeParameter {
  /// The statically declared bound of this type parameter.
  ///
  /// If omitted, the implicit bound is a [DynamicType].
  StaticType? bound;

  StaticTypeParameter([this.bound]);
}

/// A type referencing a [StaticTypeParameter], e.g. the return type in the
/// function type `T Function<T>()`.
final class TypeParameterType extends StaticType {
  final StaticTypeParameter parameter;

  TypeParameterType({required this.parameter}) : super._();

  @override
  Ret accept<Arg, Ret>(TypeVisitor<Arg, Ret> visitor, Arg arg) {
    return visitor.visitTypeParameterType(this, arg);
  }

  @override
  StaticTypeDesc _buildDescription(_StaticTypeToDescription context) {
    return StaticTypeDesc.typeParameterTypeDesc(
      TypeParameterTypeDesc(parameterId: context.referenceParameter(parameter)),
    );
  }
}

/// The type `dynamic`.
final class DynamicType extends StaticType {
  const DynamicType() : super._();

  @override
  Ret accept<Arg, Ret>(TypeVisitor<Arg, Ret> visitor, Arg arg) {
    return visitor.visitDynamicType(this, arg);
  }

  @override
  StaticTypeDesc _buildDescription(_StaticTypeToDescription context) {
    return StaticTypeDesc.dynamicTypeDesc(DynamicTypeDesc());
  }
}

/// The type `void`.
final class VoidType extends StaticType {
  const VoidType() : super._();

  @override
  Ret accept<Arg, Ret>(TypeVisitor<Arg, Ret> visitor, Arg arg) {
    return visitor.visitVoidType(this, arg);
  }

  @override
  @override
  StaticTypeDesc _buildDescription(_StaticTypeToDescription context) {
    return StaticTypeDesc.voidTypeDesc(VoidTypeDesc());
  }
}

/// The type `Never`.
final class NeverType extends StaticType {
  const NeverType() : super._();

  @override
  Ret accept<Arg, Ret>(TypeVisitor<Arg, Ret> visitor, Arg arg) {
    return visitor.visitNeverType(this, arg);
  }

  @override
  StaticTypeDesc _buildDescription(_StaticTypeToDescription context) {
    return StaticTypeDesc.neverTypeDesc(NeverTypeDesc());
  }
}

/// The representation for record types, containing positional and named record
/// fields.
final class RecordType extends StaticType {
  final List<StaticType> positional;
  final Map<String, StaticType> named;

  RecordType({this.positional = const [], this.named = const {}}) : super._();

  @override
  Ret accept<Arg, Ret>(TypeVisitor<Arg, Ret> visitor, Arg arg) {
    return visitor.visitRecordType(this, arg);
  }

  @override
  StaticTypeDesc _buildDescription(_StaticTypeToDescription context) {
    return StaticTypeDesc.recordTypeDesc(
      RecordTypeDesc(
        positional: [
          for (final positional in positional)
            positional._buildDescription(context),
        ],
        named: [
          for (final MapEntry(:key, :value) in named.entries)
            NamedRecordField(name: key, type: value._buildDescription(context)),
        ],
      ),
    );
  }
}

/// The type representation for function types, consisting of introduced type
/// parameters, the return and argument types.
final class FunctionType extends StaticType {
  final StaticType returnType;
  final List<StaticTypeParameter> typeParameters;
  final List<StaticType> requiredPositional;
  final List<StaticType> optionalPositional;
  final List<NamedFunctionParameter> named;

  FunctionType({
    required this.returnType,
    this.typeParameters = const [],
    this.requiredPositional = const [],
    this.optionalPositional = const [],
    this.named = const [],
  }) : super._();

  static FunctionType _translateFrom(
    FunctionTypeDesc desc,
    Map<int, StaticTypeParameter> parameters,
  ) {
    var typeParameters = const <StaticTypeParameter>[];

    if (desc.typeParameters.isNotEmpty) {
      // We can't define the bound right away because that might also depend on
      // type parameters (e.g. `<T extends Comparable<T>>`). So we create these
      // half-baked type parameters and then patch things up later to create the
      // final representation.
      typeParameters = List.generate(
        desc.typeParameters.length,
        (_) => StaticTypeParameter(),
      );

      parameters = {
        ...parameters,
        for (final (i, desc) in desc.typeParameters.indexed)
          desc.identifier: typeParameters[i],
      };

      // Now that the mapping from id -> type parameters ready, we translate
      // bounds.
      for (final (i, desc) in desc.typeParameters.indexed) {
        if (desc.bound case final bound?) {
          typeParameters[i].bound = StaticType._translateFromDescription(
            bound,
            parameters,
          );
        }
      }
    }

    return FunctionType(
      typeParameters: typeParameters,
      returnType: StaticType._translateFromDescription(
        desc.returnType,
        parameters,
      ),
      requiredPositional: [
        for (final desc in desc.requiredPositionalParameters)
          StaticType._translateFromDescription(desc, parameters),
      ],
      optionalPositional: [
        for (final desc in desc.optionalPositionalParameters)
          StaticType._translateFromDescription(desc, parameters),
      ],
      named: [
        for (final desc in desc.namedParameters)
          NamedFunctionParameter(
            type: StaticType._translateFromDescription(desc.type, parameters),
            name: desc.name,
            required: desc.required,
          ),
      ],
    );
  }

  @override
  Ret accept<Arg, Ret>(TypeVisitor<Arg, Ret> visitor, Arg arg) {
    return visitor.visitFunctionType(this, arg);
  }

  @override
  StaticTypeDesc _buildDescription(_StaticTypeToDescription context) {
    for (final parameter in typeParameters) {
      context.uniqueIdFor(parameter);
    }

    return StaticTypeDesc.functionTypeDesc(
      FunctionTypeDesc(
        returnType: returnType._buildDescription(context),
        typeParameters: [
          for (final parameter in typeParameters)
            StaticTypeParameterDesc(
              identifier: context.referenceParameter(parameter),
              bound: parameter.bound?._buildDescription(context),
            ),
        ],
        requiredPositionalParameters: [
          for (final type in requiredPositional)
            type._buildDescription(context),
        ],
        optionalPositionalParameters: [
          for (final type in optionalPositional)
            type._buildDescription(context),
        ],
        namedParameters: [
          for (final type in named)
            NamedFunctionTypeParameter(
              type: type.type._buildDescription(context),
              name: type.name,
              required: type.required,
            ),
        ],
      ),
    );
  }

  /// Instantiates a generic function type with the given [typeArguments].
  ///
  /// This returns a new function type without type parameters obtained by
  /// substituting [typeParameters] with [typeArguments] in the return and
  /// argument types.
  ///
  /// For instance, instantiating the generic function type `T Function<T>()`
  /// with `[VoidType()]` as type argument yields `void Function()`.
  FunctionType instantiate(List<StaticType> typeArguments) {
    if (typeArguments.length != typeParameters.length) {
      throw ArgumentError.value(
        typeArguments,
        'typeArguments',
        'Must match length of type parameters (${typeParameters.length})',
      );
    }

    final substitution = TypeSubstitution(
      substitution: {
        for (final (i, parameter) in typeParameters.indexed)
          parameter: typeArguments[i],
      },
    );

    return FunctionType(
      returnType: substitution.applyTo(returnType),
      typeParameters: const [],
      requiredPositional: [
        for (final positional in requiredPositional)
          substitution.applyTo(positional),
      ],
      optionalPositional: [
        for (final optional in optionalPositional)
          substitution.applyTo(optional),
      ],
      named: [for (final named in named) named._substitute(substitution)],
    );
  }
}

final class NamedFunctionParameter {
  final StaticType type;
  final String name;
  final bool required;

  NamedFunctionParameter({
    required this.type,
    required this.name,
    required this.required,
  });

  NamedFunctionParameter _substitute(TypeSubstitution substitution) {
    return NamedFunctionParameter(
      type: substitution.applyTo(type),
      name: name,
      required: required,
    );
  }
}

abstract class TypeVisitor<Arg, Ret> {
  Ret defaultType(StaticType type, Arg arg);

  Ret visitDynamicType(DynamicType type, Arg arg) {
    return defaultType(type, arg);
  }

  Ret visitFunctionType(FunctionType type, Arg arg) {
    return defaultType(type, arg);
  }

  Ret visitNeverType(NeverType type, Arg arg) {
    return defaultType(type, arg);
  }

  Ret visitNullableType(NullableType type, Arg arg) {
    return defaultType(type, arg);
  }

  Ret visitInterfaceType(InterfaceType type, Arg arg) {
    return defaultType(type, arg);
  }

  Ret visitRecordType(RecordType type, Arg arg) {
    return defaultType(type, arg);
  }

  Ret visitTypeParameterType(TypeParameterType type, Arg arg) {
    return defaultType(type, arg);
  }

  Ret visitVoidType(VoidType type, Arg arg) {
    return defaultType(type, arg);
  }
}

/// A substitution replacing [StaticTypeParameter]s with other types.
///
/// Applying substitutions is useful when instantiating other generic types.
final class TypeSubstitution {
  final Map<StaticTypeParameter, StaticType> substitution;

  TypeSubstitution({required this.substitution});

  StaticType applyTo(StaticType type) {
    return type.accept(const _ApplyTypeSubstitution(), this);
  }
}

final class _ApplyTypeSubstitution
    implements TypeVisitor<TypeSubstitution, StaticType> {
  const _ApplyTypeSubstitution();

  @override
  StaticType visitDynamicType(DynamicType type, TypeSubstitution arg) {
    return type;
  }

  @override
  StaticType visitFunctionType(FunctionType type, TypeSubstitution arg) {
    final newTypeParameters = List.generate(
      type.typeParameters.length,
      (_) => StaticTypeParameter(),
    );

    final innerSubstitution = TypeSubstitution(
      substitution: {
        ...arg.substitution,
        for (final (i, old) in type.typeParameters.indexed)
          old: TypeParameterType(parameter: newTypeParameters[i]),
      },
    );

    for (final (i, newParam) in newTypeParameters.indexed) {
      newParam.bound = type.typeParameters[i].bound?.accept(
        this,
        innerSubstitution,
      );
    }

    return FunctionType(
      returnType: type.returnType.accept(this, arg),
      typeParameters: newTypeParameters,
      requiredPositional: [
        for (final type in type.requiredPositional) type.accept(this, arg),
      ],
      optionalPositional: [
        for (final type in type.optionalPositional) type.accept(this, arg),
      ],
      named: [
        for (final named in type.named)
          NamedFunctionParameter(
            name: named.name,
            required: named.required,
            type: named.type.accept(this, arg),
          ),
      ],
    );
  }

  @override
  StaticType visitInterfaceType(InterfaceType type, TypeSubstitution arg) {
    return InterfaceType(
      name: type.name,
      instantiation: [
        for (final type in type.instantiation) type.accept(this, arg),
      ],
    );
  }

  @override
  StaticType visitNeverType(NeverType type, TypeSubstitution arg) {
    return type;
  }

  @override
  StaticType visitNullableType(NullableType type, TypeSubstitution arg) {
    return NullableType(type.inner.accept(this, arg));
  }

  @override
  StaticType visitRecordType(RecordType type, TypeSubstitution arg) {
    return RecordType(
      positional: [
        for (final field in type.positional) field.accept(this, arg),
      ],
      named: {
        for (final MapEntry(:key, :value) in type.named.entries)
          key: value.accept(this, arg),
      },
    );
  }

  @override
  StaticType visitTypeParameterType(
    TypeParameterType type,
    TypeSubstitution arg,
  ) {
    if (arg.substitution[type.parameter] case final substitution?) {
      return substitution;
    }

    return type;
  }

  @override
  StaticType defaultType(StaticType type, TypeSubstitution arg) {
    return type;
  }

  @override
  StaticType visitVoidType(VoidType type, TypeSubstitution arg) {
    return type;
  }
}
