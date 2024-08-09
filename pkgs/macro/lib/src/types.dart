import 'package:dart_model/dart_model.dart';

/// A fully-resolved static type representation.
///
/// Unlike [StaticTypeDesc]s which are partial representations of a Dart type,
/// subclasses of [ResolvedType] are constructed by fetching related types from
/// the macro executor, allowing them to be inspected synchronously afterwards.
sealed class ResolvedType {
  const ResolvedType();

  /// The partial representation of this static type.
  StaticTypeDesc get description {
    return _buildDescription(_ResolvedTypeToDescription());
  }

  ResolvedType substitute(Map<StaticTypeParameter, ResolvedType> substitution) {
    return this;
  }

  StaticTypeDesc _buildDescription(_ResolvedTypeToDescription context);
}

final class NamedType extends ResolvedType {
  final QualifiedName name;
  final List<ResolvedType> typeArguments;

  /// The type parameters declared by [name]. Used only to build supertype
  /// substitutions - no reference to these parameters is ever part of a public
  /// resolved type.
  final List<StaticTypeParameter> typeParameters;

  /// All direct named supertypes of this type.
  ///
  /// For instance, the named type `List<T>` would have a single element in this
  /// list, `Iterable<StaticTypeParameterType(T)>`.
  final List<NamedType> namedSuperTypes;

  NamedType({
    required this.name,
    required this.typeArguments,
    required this.typeParameters,
    required this.namedSuperTypes,
  });

  Iterable<NamedType> get superTypes {
    return _constructSuperTypes([]);
  }

  Iterable<NamedType> _constructSuperTypes(
      List<QualifiedName> instantiatedSuperClasses) sync* {
    final substitution = {
      for (var i = 0; i < typeParameters.length; i++)
        typeParameters[i]: typeArguments[i]
    };

    for (final superType in namedSuperTypes) {
      if (instantiatedSuperClasses.contains(superType.name)) {
        continue;
      }

      instantiatedSuperClasses.add(superType.name);
      final instantiatedSuperType = superType.substitute(substitution);
      yield instantiatedSuperType;
      yield* instantiatedSuperType
          ._constructSuperTypes(instantiatedSuperClasses);
    }
  }

  @override
  StaticTypeDesc _buildDescription(_ResolvedTypeToDescription context) {
    return StaticTypeDesc.namedStaticTypeDesc(NamedStaticTypeDesc(
      name: name,
      instantiation: [
        for (final type in typeArguments) type._buildDescription(context)
      ],
    ));
  }

  @override
  NamedType substitute(Map<StaticTypeParameter, ResolvedType> substitution) {
    return NamedType(
      name: name,
      typeArguments: [
        for (final argument in typeArguments) argument.substitute(substitution),
      ],
      typeParameters: typeParameters,
      namedSuperTypes: namedSuperTypes,
    );
  }

  bool get isDartCoreObject => name == _object;
  bool get isDartCoreNull => name == _null;
  bool get isDartCoreFunction => name == _function;
  bool get isDartCoreRecord => name == _record;
  bool get isDartAsyncFutureOr => name == _futureOr;

  static final QualifiedName _object = QualifiedName('dart:core#Object');
  static final QualifiedName _null = QualifiedName('dart:core#Null');
  static final QualifiedName _function = QualifiedName('dart:core#Function');
  static final QualifiedName _record = QualifiedName('dart:core#Record');
  static final QualifiedName _futureOr = QualifiedName('dart:async#FutureOr');
}

/// Resolved representation of a type `T?` given a resolved [inner] type `T`.
final class NullableType extends ResolvedType {
  /// The inner type `T` in `T?`.
  final ResolvedType inner;

  NullableType(this.inner);

  @override
  StaticTypeDesc _buildDescription(_ResolvedTypeToDescription context) {
    return StaticTypeDesc.nullableTypeDesc(
        NullableTypeDesc(inner: inner._buildDescription(context)));
  }
}

final class FunctionType extends ResolvedType {
  final ResolvedType returnType;
  final List<StaticTypeParameter> typeParameters;
  final List<ResolvedType> requiredPositional;
  final List<ResolvedType> optionalPositional;
  final List<NamedFunctionParameter> named;

  FunctionType({
    required this.returnType,
    this.typeParameters = const [],
    this.requiredPositional = const [],
    this.optionalPositional = const [],
    this.named = const [],
  });

  @override
  StaticTypeDesc _buildDescription(_ResolvedTypeToDescription context) {
    for (final parameter in typeParameters) {
      context.uniqueIdFor(parameter);
    }

    return StaticTypeDesc.functionTypeDesc(FunctionTypeDesc(
      returnType: returnType._buildDescription(context),
      typeParameters: [
        for (final parameter in typeParameters)
          StaticTypeParameterDesc(
            identifier: context.referenceParameter(parameter),
            bound: parameter.bound?._buildDescription(context),
          ),
      ],
      requiredPositionalParameters: [
        for (final type in requiredPositional) type._buildDescription(context),
      ],
      optionalPositionalParameters: [
        for (final type in optionalPositional) type._buildDescription(context),
      ],
      namedParameters: [
        for (final type in named)
          NamedFunctionTypeParameter(
            type: type.type._buildDescription(context),
            name: type.name,
            required: type.required,
          ),
      ],
    ));
  }

  @override
  ResolvedType substitute(Map<StaticTypeParameter, ResolvedType> substitution) {
    return FunctionType(
      returnType: returnType.substitute(substitution),
      typeParameters: typeParameters,
      requiredPositional: [
        for (final type in requiredPositional) type.substitute(substitution),
      ],
      optionalPositional: [
        for (final type in optionalPositional) type.substitute(substitution),
      ],
      named: [
        for (final type in named) type._substitute(substitution),
      ],
    );
  }

  /// Instantiates a generic function type with the given [typeArguments].
  ///
  /// This returns a new function type without type parameters obtained by
  /// substituting [typeParameters] with [typeArguments] in the return and
  /// argument types.
  FunctionType instantiate(List<ResolvedType> typeArguments) {
    if (typeArguments.length != typeParameters.length) {
      throw ArgumentError.value(typeArguments, 'typeArguments',
          'Must match length of type parameters (${typeParameters.length})');
    }

    final substitution = {
      for (final (i, parameter) in typeParameters.indexed)
        parameter: typeArguments[i]
    };

    return FunctionType(
      returnType: returnType.substitute(substitution),
      typeParameters: const [],
      requiredPositional: [
        for (final positional in requiredPositional)
          positional.substitute(substitution),
      ],
      optionalPositional: [
        for (final optional in optionalPositional)
          optional.substitute(substitution),
      ],
      named: [for (final named in named) named._substitute(substitution)],
    );
  }
}

final class NamedFunctionParameter {
  final ResolvedType type;
  final String name;
  final bool required;

  NamedFunctionParameter({
    required this.type,
    required this.name,
    required this.required,
  });

  NamedFunctionParameter _substitute(
      Map<StaticTypeParameter, ResolvedType> substitution) {
    return NamedFunctionParameter(
      type: type.substitute(substitution),
      name: name,
      required: required,
    );
  }
}

final class StaticTypeParameter {
  ResolvedType? bound;

  StaticTypeParameter([this.bound]);
}

final class TypeParameterType extends ResolvedType {
  final StaticTypeParameter parameter;

  TypeParameterType({required this.parameter});

  @override
  StaticTypeDesc _buildDescription(_ResolvedTypeToDescription context) {
    return StaticTypeDesc.typeParameterTypeDesc(TypeParameterTypeDesc(
        parameterId: context.referenceParameter(parameter)));
  }

  @override
  ResolvedType substitute(Map<StaticTypeParameter, ResolvedType> substitution) {
    if (substitution[parameter] case final substituted?) {
      return substituted;
    } else {
      return this;
    }
  }
}

final class DynamicType extends ResolvedType {
  const DynamicType();

  @override
  StaticTypeDesc _buildDescription(_ResolvedTypeToDescription context) {
    return StaticTypeDesc.dynamicTypeDesc(DynamicTypeDesc());
  }
}

final class NeverType extends ResolvedType {
  const NeverType();

  @override
  StaticTypeDesc _buildDescription(_ResolvedTypeToDescription context) {
    return StaticTypeDesc.neverTypeDesc(NeverTypeDesc());
  }
}

final class VoidType extends ResolvedType {
  const VoidType();

  @override
  StaticTypeDesc _buildDescription(_ResolvedTypeToDescription context) {
    return StaticTypeDesc.voidTypeDesc(VoidTypeDesc());
  }
}

final class RecordType extends ResolvedType {
  final List<ResolvedType> positional;
  final Map<String, ResolvedType> named;

  RecordType({this.positional = const [], this.named = const {}});

  @override
  StaticTypeDesc _buildDescription(_ResolvedTypeToDescription context) {
    return StaticTypeDesc.recordTypeDesc(
      RecordTypeDesc(
        positional: [
          for (final positional in positional) positional.description,
        ],
        named: [
          for (final MapEntry(:key, :value) in named.entries)
            NamedRecordField(name: key, type: value.description),
        ],
      ),
    );
  }

  @override
  ResolvedType substitute(Map<StaticTypeParameter, ResolvedType> substitution) {
    return RecordType(
      positional: [
        for (final type in positional) type.substitute(substitution)
      ],
      named: {
        for (final MapEntry(:key, :value) in named.entries)
          key: value.substitute(substitution),
      },
    );
  }
}

final class _ResolvedTypeToDescription {
  final Map<StaticTypeParameter, int> parameterIds = {};

  int referenceParameter(StaticTypeParameter parameter) {
    return parameterIds[parameter]!;
  }

  int uniqueIdFor(StaticTypeParameter parameter) {
    return parameterIds[parameter] = parameterIds.length;
  }
}
