// This file is generated. To make changes edit schemas/*.schema.json
// then run from the repo root: dart tool/dart_model_generator/bin/main.dart

/// An augmentation to Dart code. TODO(davidmorgan): this is a placeholder.
extension type Augmentation.fromJson(Map<String, Object?> node)
    implements Object {
  Augmentation({
    String? code,
  }) : this.fromJson({
          if (code != null) 'code': code,
        });

  /// Augmentation code.
  String get code => node['code'] as String;
}

/// The type-hierarchy representation of the type `dynamic`.
extension type DynamicTypeDesc.fromJson(Null _) {
  DynamicTypeDesc() : this.fromJson(null);
}

/// A static type representation for function types.
extension type FunctionTypeDesc.fromJson(Map<String, Object?> node)
    implements Object {
  FunctionTypeDesc({
    StaticTypeDesc? returnType,
    List<StaticTypeParameterDesc>? typeParameters,
    List<StaticTypeDesc>? requiredPositionalParameters,
    List<StaticTypeDesc>? optionalPositionalParameters,
    List<NamedFunctionTypeParameter>? namedParameters,
  }) : this.fromJson({
          if (returnType != null) 'returnType': returnType,
          if (typeParameters != null) 'typeParameters': typeParameters,
          if (requiredPositionalParameters != null)
            'requiredPositionalParameters': requiredPositionalParameters,
          if (optionalPositionalParameters != null)
            'optionalPositionalParameters': optionalPositionalParameters,
          if (namedParameters != null) 'namedParameters': namedParameters,
        });
  StaticTypeDesc get returnType => node['returnType'] as StaticTypeDesc;

  /// Static type parameters introduced by this function type.
  List<StaticTypeParameterDesc> get typeParameters =>
      (node['typeParameters'] as List).cast();
  List<StaticTypeDesc> get requiredPositionalParameters =>
      (node['requiredPositionalParameters'] as List).cast();
  List<StaticTypeDesc> get optionalPositionalParameters =>
      (node['optionalPositionalParameters'] as List).cast();
  List<NamedFunctionTypeParameter> get namedParameters =>
      (node['namedParameters'] as List).cast();
}

/// A metadata annotation.
extension type MetadataAnnotation.fromJson(Map<String, Object?> node)
    implements Object {
  MetadataAnnotation({
    QualifiedName? type,
  }) : this.fromJson({
          if (type != null) 'type': type,
        });

  /// The type of the annotation.
  QualifiedName get type => node['type'] as QualifiedName;
}

/// An interface.
extension type Interface.fromJson(Map<String, Object?> node) implements Object {
  Interface({
    List<MetadataAnnotation>? metadataAnnotations,
    Map<String, Member>? members,
    NamedTypeDesc? thisType,
    Properties? properties,
  }) : this.fromJson({
          if (metadataAnnotations != null)
            'metadataAnnotations': metadataAnnotations,
          if (members != null) 'members': members,
          if (thisType != null) 'thisType': thisType,
          if (properties != null) 'properties': properties,
        });

  /// The metadata annotations attached to this iterface.
  List<MetadataAnnotation> get metadataAnnotations =>
      (node['metadataAnnotations'] as List).cast();

  /// Map of members by name.
  Map<String, Member> get members => (node['members'] as Map).cast();
  NamedTypeDesc get thisType => node['thisType'] as NamedTypeDesc;

  /// The properties of this interface.
  Properties get properties => node['properties'] as Properties;
}

/// Library.
extension type Library.fromJson(Map<String, Object?> node) implements Object {
  Library({
    Map<String, Interface>? scopes,
  }) : this.fromJson({
          if (scopes != null) 'scopes': scopes,
        });

  /// Scopes by name.
  Map<String, Interface> get scopes => (node['scopes'] as Map).cast();
}

/// Member of a scope.
extension type Member.fromJson(Map<String, Object?> node) implements Object {
  Member({
    Properties? properties,
  }) : this.fromJson({
          if (properties != null) 'properties': properties,
        });

  /// The properties of this member.
  Properties get properties => node['properties'] as Properties;
}

/// Partial model of a corpus of Dart source code.
extension type Model.fromJson(Map<String, Object?> node) implements Object {
  Model({
    Map<String, Library>? uris,
    TypeHierarchy? types,
  }) : this.fromJson({
          if (uris != null) 'uris': uris,
          if (types != null) 'types': types,
        });

  /// Libraries by URI.
  Map<String, Library> get uris => (node['uris'] as Map).cast();
  TypeHierarchy get types => node['types'] as TypeHierarchy;
}

/// A resolved named parameter as part of a [FunctionTypeDesc].
extension type NamedFunctionTypeParameter.fromJson(Map<String, Object?> node)
    implements Object {
  NamedFunctionTypeParameter({
    String? name,
    bool? required,
    StaticTypeDesc? type,
  }) : this.fromJson({
          if (name != null) 'name': name,
          if (required != null) 'required': required,
          if (type != null) 'type': type,
        });
  String get name => node['name'] as String;
  bool get required => node['required'] as bool;
  StaticTypeDesc get type => node['type'] as StaticTypeDesc;
}

/// A named field in a [RecordTypeDesc], consisting of the field name and the associated type.
extension type NamedRecordField.fromJson(Map<String, Object?> node)
    implements Object {
  NamedRecordField({
    String? name,
    StaticTypeDesc? type,
  }) : this.fromJson({
          if (name != null) 'name': name,
          if (type != null) 'type': type,
        });
  String get name => node['name'] as String;
  StaticTypeDesc get type => node['type'] as StaticTypeDesc;
}

/// A resolved static type
extension type NamedTypeDesc.fromJson(Map<String, Object?> node)
    implements Object {
  NamedTypeDesc({
    QualifiedName? name,
    List<StaticTypeDesc>? instantiation,
  }) : this.fromJson({
          if (name != null) 'name': name,
          if (instantiation != null) 'instantiation': instantiation,
        });
  QualifiedName get name => node['name'] as QualifiedName;
  List<StaticTypeDesc> get instantiation =>
      (node['instantiation'] as List).cast();
}

/// Representation of the bottom type [Never].
extension type NeverTypeDesc.fromJson(Null _) {
  NeverTypeDesc() : this.fromJson(null);
}

/// A Dart type of the form `T?` for an inner type `T`.
extension type NullableTypeDesc.fromJson(Map<String, Object?> node)
    implements Object {
  NullableTypeDesc({
    StaticTypeDesc? inner,
  }) : this.fromJson({
          if (inner != null) 'inner': inner,
        });
  StaticTypeDesc get inner => node['inner'] as StaticTypeDesc;
}

/// Set of boolean properties.
extension type Properties.fromJson(Map<String, Object?> node)
    implements Object {
  Properties({
    bool? isAbstract,
    bool? isClass,
    bool? isGetter,
    bool? isField,
    bool? isMethod,
    bool? isStatic,
  }) : this.fromJson({
          if (isAbstract != null) 'isAbstract': isAbstract,
          if (isClass != null) 'isClass': isClass,
          if (isGetter != null) 'isGetter': isGetter,
          if (isField != null) 'isField': isField,
          if (isMethod != null) 'isMethod': isMethod,
          if (isStatic != null) 'isStatic': isStatic,
        });

  /// Whether the entity is abstract, meaning it has no definition.
  bool get isAbstract => node['isAbstract'] as bool;

  /// Whether the entity is a class.
  bool get isClass => node['isClass'] as bool;

  /// Whether the entity is a getter.
  bool get isGetter => node['isGetter'] as bool;

  /// Whether the entity is a field.
  bool get isField => node['isField'] as bool;

  /// Whether the entity is a method.
  bool get isMethod => node['isMethod'] as bool;

  /// Whether the entity is static.
  bool get isStatic => node['isStatic'] as bool;
}

/// A URI combined with a name.
extension type QualifiedName.fromJson(String string) implements Object {
  QualifiedName(String string) : this.fromJson(string);
}

/// Query about a corpus of Dart source code. TODO(davidmorgan): this queries about a single class, expand to a union type for different types of queries.
extension type Query.fromJson(Map<String, Object?> node) implements Object {
  Query({
    QualifiedName? target,
  }) : this.fromJson({
          if (target != null) 'target': target,
        });

  /// The class to query about.
  QualifiedName get target => node['target'] as QualifiedName;
}

/// A resolved record type in the type hierarchy.
extension type RecordTypeDesc.fromJson(Map<String, Object?> node)
    implements Object {
  RecordTypeDesc({
    List<StaticTypeDesc>? positional,
    List<NamedRecordField>? named,
  }) : this.fromJson({
          if (positional != null) 'positional': positional,
          if (named != null) 'named': named,
        });
  List<StaticTypeDesc> get positional => (node['positional'] as List).cast();
  List<NamedRecordField> get named => (node['named'] as List).cast();
}

enum StaticTypeDescType {
  // Private so switches must have a default. See `isKnown`.
  _unknown,
  dynamicTypeDesc,
  functionTypeDesc,
  neverTypeDesc,
  nullableTypeDesc,
  namedTypeDesc,
  recordTypeDesc,
  typeParameterTypeDesc,
  voidTypeDesc;

  bool get isKnown => this != _unknown;
}

extension type StaticTypeDesc.fromJson(Map<String, Object?> node)
    implements Object {
  static StaticTypeDesc dynamicTypeDesc(DynamicTypeDesc dynamicTypeDesc) =>
      StaticTypeDesc.fromJson({
        'type': 'DynamicTypeDesc',
        'value': dynamicTypeDesc,
      });
  static StaticTypeDesc functionTypeDesc(FunctionTypeDesc functionTypeDesc) =>
      StaticTypeDesc.fromJson({
        'type': 'FunctionTypeDesc',
        'value': functionTypeDesc,
      });
  static StaticTypeDesc neverTypeDesc(NeverTypeDesc neverTypeDesc) =>
      StaticTypeDesc.fromJson({
        'type': 'NeverTypeDesc',
        'value': neverTypeDesc,
      });
  static StaticTypeDesc nullableTypeDesc(NullableTypeDesc nullableTypeDesc) =>
      StaticTypeDesc.fromJson({
        'type': 'NullableTypeDesc',
        'value': nullableTypeDesc,
      });
  static StaticTypeDesc namedTypeDesc(NamedTypeDesc namedTypeDesc) =>
      StaticTypeDesc.fromJson({
        'type': 'NamedTypeDesc',
        'value': namedTypeDesc,
      });
  static StaticTypeDesc recordTypeDesc(RecordTypeDesc recordTypeDesc) =>
      StaticTypeDesc.fromJson({
        'type': 'RecordTypeDesc',
        'value': recordTypeDesc,
      });
  static StaticTypeDesc typeParameterTypeDesc(
          TypeParameterTypeDesc typeParameterTypeDesc) =>
      StaticTypeDesc.fromJson({
        'type': 'TypeParameterTypeDesc',
        'value': typeParameterTypeDesc,
      });
  static StaticTypeDesc voidTypeDesc(VoidTypeDesc voidTypeDesc) =>
      StaticTypeDesc.fromJson({
        'type': 'VoidTypeDesc',
        'value': voidTypeDesc,
      });
  StaticTypeDescType get type {
    switch (node['type'] as String) {
      case 'DynamicTypeDesc':
        return StaticTypeDescType.dynamicTypeDesc;
      case 'FunctionTypeDesc':
        return StaticTypeDescType.functionTypeDesc;
      case 'NeverTypeDesc':
        return StaticTypeDescType.neverTypeDesc;
      case 'NullableTypeDesc':
        return StaticTypeDescType.nullableTypeDesc;
      case 'NamedTypeDesc':
        return StaticTypeDescType.namedTypeDesc;
      case 'RecordTypeDesc':
        return StaticTypeDescType.recordTypeDesc;
      case 'TypeParameterTypeDesc':
        return StaticTypeDescType.typeParameterTypeDesc;
      case 'VoidTypeDesc':
        return StaticTypeDescType.voidTypeDesc;
      default:
        return StaticTypeDescType._unknown;
    }
  }

  DynamicTypeDesc get asDynamicTypeDesc {
    if (node['type'] != 'DynamicTypeDesc') {
      throw StateError('Not a DynamicTypeDesc.');
    }
    return DynamicTypeDesc.fromJson(node['value'] as Null);
  }

  FunctionTypeDesc get asFunctionTypeDesc {
    if (node['type'] != 'FunctionTypeDesc') {
      throw StateError('Not a FunctionTypeDesc.');
    }
    return FunctionTypeDesc.fromJson(node['value'] as Map<String, Object?>);
  }

  NeverTypeDesc get asNeverTypeDesc {
    if (node['type'] != 'NeverTypeDesc') {
      throw StateError('Not a NeverTypeDesc.');
    }
    return NeverTypeDesc.fromJson(node['value'] as Null);
  }

  NullableTypeDesc get asNullableTypeDesc {
    if (node['type'] != 'NullableTypeDesc') {
      throw StateError('Not a NullableTypeDesc.');
    }
    return NullableTypeDesc.fromJson(node['value'] as Map<String, Object?>);
  }

  NamedTypeDesc get asNamedTypeDesc {
    if (node['type'] != 'NamedTypeDesc') {
      throw StateError('Not a NamedTypeDesc.');
    }
    return NamedTypeDesc.fromJson(node['value'] as Map<String, Object?>);
  }

  RecordTypeDesc get asRecordTypeDesc {
    if (node['type'] != 'RecordTypeDesc') {
      throw StateError('Not a RecordTypeDesc.');
    }
    return RecordTypeDesc.fromJson(node['value'] as Map<String, Object?>);
  }

  TypeParameterTypeDesc get asTypeParameterTypeDesc {
    if (node['type'] != 'TypeParameterTypeDesc') {
      throw StateError('Not a TypeParameterTypeDesc.');
    }
    return TypeParameterTypeDesc.fromJson(
        node['value'] as Map<String, Object?>);
  }

  VoidTypeDesc get asVoidTypeDesc {
    if (node['type'] != 'VoidTypeDesc') {
      throw StateError('Not a VoidTypeDesc.');
    }
    return VoidTypeDesc.fromJson(node['value'] as Null);
  }
}

/// A resolved type parameter introduced by a [FunctionTypeDesc].
extension type StaticTypeParameterDesc.fromJson(Map<String, Object?> node)
    implements Object {
  StaticTypeParameterDesc({
    int? identifier,
    StaticTypeDesc? bound,
  }) : this.fromJson({
          if (identifier != null) 'identifier': identifier,
          if (bound != null) 'bound': bound,
        });
  int get identifier => node['identifier'] as int;
  StaticTypeDesc get bound => node['bound'] as StaticTypeDesc;
}

/// View of a subset of a Dart program's type hierarchy as part of a queried model.
extension type TypeHierarchy.fromJson(Map<String, Object?> node)
    implements Object {
  TypeHierarchy({
    Map<String, TypeHierarchyEntry>? named,
  }) : this.fromJson({
          if (named != null) 'named': named,
        });

  /// Map of qualified interface names to their resolved named type.
  Map<String, TypeHierarchyEntry> get named => (node['named'] as Map).cast();
}

/// Entry of an interface in Dart's type hierarchy, along with supertypes.
extension type TypeHierarchyEntry.fromJson(Map<String, Object?> node)
    implements Object {
  TypeHierarchyEntry({
    List<StaticTypeParameterDesc>? typeParameters,
    NamedTypeDesc? self,
    List<NamedTypeDesc>? supertypes,
  }) : this.fromJson({
          if (typeParameters != null) 'typeParameters': typeParameters,
          if (self != null) 'self': self,
          if (supertypes != null) 'supertypes': supertypes,
        });

  /// Type parameters defined on this interface-defining element..
  List<StaticTypeParameterDesc> get typeParameters =>
      (node['typeParameters'] as List).cast();
  NamedTypeDesc get self => node['self'] as NamedTypeDesc;

  /// All direct supertypes of this type.
  List<NamedTypeDesc> get supertypes => (node['supertypes'] as List).cast();
}

/// A type formed by a reference to a type parameter.
extension type TypeParameterTypeDesc.fromJson(Map<String, Object?> node)
    implements Object {
  TypeParameterTypeDesc({
    int? parameterId,
  }) : this.fromJson({
          if (parameterId != null) 'parameterId': parameterId,
        });
  int get parameterId => node['parameterId'] as int;
}

/// The type-hierarchy representation of the type `void`.
extension type VoidTypeDesc.fromJson(Null _) {
  VoidTypeDesc() : this.fromJson(null);
}
