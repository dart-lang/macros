// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart_model.dart';
import 'type.dart';

final class StaticTypeSystem {
  final TypeHierarchy _hierarchy;

  late final InterfaceType _object = _lookupNamed('dart:core#Object');
  late final StaticType _objectQuestion = NullableType(_object);
  late final StaticType _null = _lookupNamed('dart:core#Null');
  late final InterfaceType _futureVoid =
      _lookupEntry('dart:async#Future').instantiate([const VoidType()]);

  StaticTypeSystem(this._hierarchy);

  TypeHierarchyEntry _lookupEntry(String qualifiedName) {
    return _hierarchy.named[qualifiedName]!;
  }

  InterfaceType _lookupNamed(String qualifiedName) {
    return StaticType(
            StaticTypeDesc.namedTypeDesc(_lookupEntry(qualifiedName).self))
        as InterfaceType;
  }

  /// Returns the resolved type `Future<[inner]>`.
  StaticType _future(StaticType inner) {
    return InterfaceType(name: _futureVoid.name, instantiation: [inner]);
  }

  /// Returns whether [type] is a top type (i.e. `dynamic`, `void` or
  /// `Object?`).
  bool _isTopType(StaticType type) {
    return switch (type) {
      NullableType(:final InterfaceType inner) => inner.name == _object.name,
      VoidType() => true,
      DynamicType() => true,
      _ => false,
    };
  }

  /// Whether [a] and [b] are semantically the same type.
  ///
  /// As per the Dart language specification, this is the case iff the types are
  /// subtypes of each other.
  /// For instance, `Never?` and `Null` are equal types.
  bool areEqual(StaticType a, StaticType b) {
    return isSubtype(a, b) && isSubtype(b, a);
  }

  bool isSubtype(StaticType a, StaticType b) {
    // This is using `T0` and `T1` names to make the implementation easier to
    // compare with the specification at
    // https://github.com/dart-lang/language/blob/main/resources/type-system/subtyping.md#rules
    final T0 = a;
    final T1 = b;

    // Reflexivity
    if (identical(a, b) || a == b) {
      return true;
    }

    // Right top: If `T1` is a top type, then `T0 <: T1`
    if (_isTopType(T1)) {
      return true;
    }

    // Left top: If `T0` is `dynamic` or `void` then `T0 <: T1` if
    // `Object? <: T1`
    if ((T0 is DynamicType || T1 is VoidType) &&
        isSubtype(_objectQuestion, T1)) {
      return true;
    }

    // Left Bottom: If `T0` is `Never` then `T0 <: T1`
    if (T0 is NeverType) {
      return true;
    }

    // Right Object: If `T1` is `Object`, then
    if (T1 case InterfaceType(isDartCoreObject: true)) {
      // If `T0` is an unpromoted type variable with bound `B` then `T0 <: T1`
      // iff `B <: Object`.
      if (T0 case TypeParameterType(:final parameter)) {
        final bound = parameter.bound ?? const DynamicType();
        return isSubtype(bound, _object);
      }

      // Note: Promoted type variables are not currently represented in macros.

      // If `T0` is `FutureOr<S>` for some `S`, then `T0 <: T1` iff
      // `S <: Object`
      if (T1
          case InterfaceType(
            isDartAsyncFutureOr: true,
            instantiation: [final S]
          )) {
        return isSubtype(S, _object);
      }

      // Neither are legacy types, so the `S*` rule is not applicable.

      // If `T0` is `Null`, `dynamic`, `void`, or `S?` for any `S`, then the
      // subtyping does not hold.
      return switch (T0) {
        InterfaceType(isDartCoreNull: true) ||
        DynamicType() ||
        VoidType() ||
        NullableType() =>
          false,
        // Otherwise, `T0 <: T1` is true.
        _ => true,
      };
    }

    // Left Null: If `T0` is `Null` then:
    if (T0 case InterfaceType(isDartCoreNull: true)) {
      return switch (T1) {
        // If `T1` is a type variable (promoted or not) the query is false
        TypeParameterType() => false,
        // If `T1` is `FutureOr<S>` for some `S`, then the query is true iff
        // `Null <: S`.
        InterfaceType(
          isDartAsyncFutureOr: true,
          instantiation: [final S],
        ) =>
          isSubtype(_null, S),
        // If `T1` is `Null`, `S?` or `S*` for some `S` then the query is true.
        InterfaceType(isDartCoreNull: true) || NullableType() => true,
        // Otherwise, the query is false
        _ => false,
      };
    }

    // Note: Left Legacy and Right Legacy aren't applicable because macros don't
    // support legacy types.

    // Left FutureOr: If `T0` is `FutureOr<S0>` then: `T0 <: T1` iff
    // `Future<S0> <: T1` and `S0 <: T1`.
    if (T0
        case InterfaceType(
          isDartAsyncFutureOr: true,
          instantiation: [final S0]
        )) {
      return isSubtype(S0, T1) && isSubtype(_future(S0), T1);
    }

    // Left Nullable: if `T0` is `S0?` then: `T0 <: T1` iff `S0 <: T1` and
    // `Null <: T1`
    if (T0 case NullableType(inner: final S0)) {
      return isSubtype(S0, T1) && isSubtype(_null, T1);
    }

    // Type Variable Reflexivity 1: If `T0` is a type variable `X0` and `T1`
    // is `X0` then: `T0 <: T1`.
    if (T0 case TypeParameterType(parameter: final X0)) {
      if (T1 case TypeParameterType(parameter: final X1) when X0 == X1) {
        return true;
      }
    }
    // Type Variable Reflexivity 2 and Right Promoted Variable: Omitted because
    // bound type variables are not implemented.

    // Right FutureOr: If `T1` is `FutureOr<S1>` then `T0 <: T1` iff any of the
    // following hold:
    if (T1
        case InterfaceType(
          isDartAsyncFutureOr: true,
          instantiation: [final S1]
        )) {
      if (isSubtype(T0, _future(S1))) {
        // `T0 <: Future<S1>`
        return true;
      }
      if (isSubtype(T0, T1)) {
        // `T0 <: T1`
        return true;
      }
      if (T0
          case TypeParameterType(
            parameter: StaticTypeParameter(bound: final S0?)
          ) when isSubtype(S0, T1)) {
        // `T0` is `X0` and `X0` has bound `S0` and `S0 <: T1`
        return true;
      }

      // Or `T0` is `X0 & S0` and `S0 <: T1` is not implemented because macros
      // don't represent promoted type variables statically.
      return false;
    }

    // Right Nullable: If `T1` is `S1?` then `T0 <: T1` iff any of the following
    // hold:
    if (T1 case NullableType(inner: final S1)) {
      if (isSubtype(T0, S1)) {
        // either `T0 <: S1`
        return true;
      }
      if (isSubtype(T0, _null)) {
        // or `T0 <: Null`
      }
      if (T0
          case TypeParameterType(
            parameter: StaticTypeParameter(bound: final S0?)
          ) when isSubtype(S0, T1)) {
        // `T0` is `X0` and `X0` has bound `S0` and `S0 <: T1`
        return true;
      }

      // Or `T0` is `X0 & S0` and `S0 <: T1` is not implemented because macros
      // don't represent promoted type variables statically.
      return false;
    }

    // Left Promoted Variable is not implemented because macros don't represent
    // promoted type variables statically.

    // Left Type Variable Bound: `T0` is a type variable `X0` with bound `B0`
    // and `B0 <: T1`.
    if (T0
        case TypeParameterType(parameter: StaticTypeParameter(bound: final B0?))
        when isSubtype(B0, T1)) {
      return true;
    }

    // Function Type/Function: `T0` is a function type and `T1` is `Function`
    if (T0 is FunctionType) {
      if (T1 case InterfaceType(isDartCoreFunction: true)) {
        return true;
      }
    }

    // Record Type/Record: `T0` is a function type and `T1` is `Record`
    if (T0 is RecordType) {
      if (T1 case InterfaceType(isDartCoreRecord: true)) {
        return true;
      }
    }

    // Interface Compositionality and Super-Interface
    if (T0 is InterfaceType && T1 is InterfaceType) {
      return _namedTypeSubtypes(T0, T1);
    }

    // Positional and named function types
    if (T0 is FunctionType && T1 is FunctionType) {
      return _checkFunctionSubtype(T0, T1);
    }

    // Record types
    if (T0 is RecordType && T1 is RecordType) {
      if (T0.positional.length != T1.positional.length ||
          T0.named.length != T1.named.length) {
        return false;
      }

      for (var i = 0; i < T0.positional.length; i++) {
        if (!isSubtype(T0.positional[i], T1.positional[i])) {
          return false;
        }
      }

      for (final MapEntry(key: name, value: Vk) in T0.named.entries) {
        final Sk = T1.named[name];
        if (Sk == null || !isSubtype(Vk, Sk)) {
          return false;
        }
      }
    }

    return false;
  }

  /// Checks whether [subType] is a subtype of [superType] under the "Interface
  /// Compositionality" and "Super-Interface" rules after previous rules have
  /// already been checked.
  bool _namedTypeSubtypes(InterfaceType subType, InterfaceType superType) {
    // <: Object queries are handled by other rules.
    assert(!superType.isDartCoreObject);

    if (subType.name == superType.name) {
      return _matchingInstantiation(
          subType.instantiation, superType.instantiation);
    }

    for (final actualSuperType in _constructSuperTypes(subType, [])) {
      if (actualSuperType.name == superType.name) {
        return _matchingInstantiation(
            actualSuperType.instantiation, superType.instantiation);
      }
    }

    return false;
  }

  bool _matchingInstantiation(List<StaticType> left, List<StaticType> right) {
    assert(left.length == right.length);

    for (var i = 0; i < left.length; i++) {
      if (!isSubtype(left[i], right[i])) {
        return false;
      }
    }

    return true;
  }

  /// Walks the type hierarchy upwards from [type], yielding instantiated
  /// supertypes of that type.
  Iterable<InterfaceType> _constructSuperTypes(
      InterfaceType type, List<QualifiedName> coveredClasses) sync* {
    final hierarchyEntry = _hierarchy.named[type.name.string]!;
    // Consider e.g. a class `List<T> extends Iterable<T>` for which we have an
    // instantiation `List<int>` and now want to find supertypes.
    // First, create a mapping `T -> int`:
    final typeParameters = <StaticTypeParameter>[];
    final parameterIdToTypeParameter = <int, StaticTypeParameter>{};

    for (final parameter in hierarchyEntry.typeParameters) {
      final resolved = StaticTypeParameter();
      typeParameters.add(resolved);
      parameterIdToTypeParameter[parameter.identifier] = resolved;
    }

    final substitution = TypeSubstitution(substitution: {
      for (var i = 0; i < typeParameters.length; i++)
        typeParameters[i]: type.instantiation[i]
    });

    for (final superType in hierarchyEntry.supertypes) {
      if (coveredClasses.contains(superType.name)) {
        continue;
      }

      coveredClasses.add(superType.name);

      // The serialized `superType` format may reference type parameters from
      // the [hierarchyEntry] to describe how type parameters are passed towards
      // the supertypes. We first create the supertype from the perspective of
      // the class definition of the [type] by using the type parameters we
      // already have.
      final superTypeUsingThisTypesTypeParameters = StaticType(
        StaticTypeDesc.namedTypeDesc(superType),
        translatedParameters: parameterIdToTypeParameter,
      );

      // Which then allows instantiating the supertype based on the
      // instantiation of the subtype.
      final instantiatedSuperType = substitution
          .applyTo(superTypeUsingThisTypesTypeParameters) as InterfaceType;
      yield instantiatedSuperType;
      yield* _constructSuperTypes(instantiatedSuperType, coveredClasses);
    }
  }

  bool _checkFunctionSubtype(FunctionType left, FunctionType right) {
    final freshTypeParams =
        _freshTypeParameters(left.typeParameters, right.typeParameters);
    if (freshTypeParams == null) {
      return false;
    }

    final freshTypeArgs = [
      for (final param in freshTypeParams) TypeParameterType(parameter: param)
    ];

    // Turn the type parameters in the function types into free type variables
    // that are identical across them - this allows checking for subtypes
    // without adding a context interpreting type parameters.
    left = left.instantiate(freshTypeArgs);
    right = right.instantiate(freshTypeArgs);

    if (!isSubtype(left.returnType, right.returnType)) {
      return false;
    }

    // Positional Function Types rule
    if (left.named.isEmpty && right.named.isEmpty) {
      final n = left.requiredPositional.length;
      final m = n + left.optionalPositional.length;

      final p = right.requiredPositional.length;
      final q = p + right.optionalPositional.length;

      if (p < n || m < q) {
        return false;
      }

      for (var i = 0; i < q; i++) {
        final Si = i >= p
            ? right.optionalPositional[i - p]
            : right.optionalPositional[i];
        final Vi = i >= n
            ? left.optionalPositional[i - n]
            : left.requiredPositional[i];

        if (!isSubtype(Si, Vi)) {
          return false;
        }
      }
    }

    // Named Function Types rule
    if (right.optionalPositional.isEmpty && left.optionalPositional.isEmpty) {
      if (left.requiredPositional.length != right.requiredPositional.length) {
        return false;
      }

      for (var i = 0; i < left.requiredPositional.length; i++) {
        if (!isSubtype(
            right.requiredPositional[i], left.requiredPositional[i])) {
          return false;
        }
      }

      // Each named parameter that exists in the supertype must also exist in
      // the subtype.
      checkRight:
      for (final superTypeNamed in right.named) {
        for (final subTypeNamed in left.named) {
          if (subTypeNamed.name == superTypeNamed.name) {
            if (!isSubtype(superTypeNamed.type, subTypeNamed.type)) {
              return false;
            }
            continue checkRight;
          }
        }

        return false; // Parameter does not exist in subtype
      }

      // Each required parameter in the subtype must also be required in the
      // supertype
      checkLeft:
      for (final subTypeNamed in left.named) {
        if (subTypeNamed.required) {
          for (final superTypeNamed in right.named) {
            if (superTypeNamed.name == subTypeNamed.name &&
                superTypeNamed.required) {
              continue checkLeft;
            }
          }
        }

        return false;
      }
    }

    return false;
  }

  /// Given unifyable list of type parameters, generates a fresh list of type
  /// parameters.
  ///
  /// This allows applying a substitution to the source types defining [a] and
  /// [b], which then makes comparing type parameters easier.
  List<StaticTypeParameter>? _freshTypeParameters(
      List<StaticTypeParameter> a, List<StaticTypeParameter> b) {
    if (a.length != b.length) {
      return null;
    }
    if (a.isEmpty) {
      return const [];
    }

    final freshParameters =
        List.generate(a.length, (_) => StaticTypeParameter());
    final freshTypes = List.generate(
        a.length, (i) => TypeParameterType(parameter: freshParameters[i]));

    final substitutionA = TypeSubstitution(substitution: {
      for (final (i, parameter) in a.indexed) parameter: freshTypes[i]
    });
    final substitutionB = TypeSubstitution(substitution: {
      for (final (i, parameter) in b.indexed) parameter: freshTypes[i]
    });

    for (var i = 0; i < a.length; i++) {
      var boundA = a[i].bound;
      var boundB = b[i].bound;

      if (boundA == null && boundB == null) {
        continue;
      }

      boundA ??= substitutionA.applyTo(boundA ?? const DynamicType());
      boundB ??= substitutionB.applyTo(boundB ?? const DynamicType());

      if (!areEqual(boundA, boundB)) {
        return null;
      }

      if (boundA is! DynamicType) {
        freshParameters[i].bound = boundA;
      }
    }

    return freshParameters;
  }
}

extension on TypeHierarchyEntry {
  InterfaceType instantiate(List<StaticType> typeArguments) {
    final raw = StaticType(StaticTypeDesc.namedTypeDesc(self)) as InterfaceType;
    return InterfaceType(name: raw.name, instantiation: typeArguments);
  }
}
