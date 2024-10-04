// This file is generated. To make changes edit tool/dart_model_generator
// then run from the repo root: dart tool/dart_model_generator/bin/main.dart

// ignore: implementation_imports,unused_import,prefer_relative_imports
import 'package:dart_model/src/json_buffer/json_buffer_builder.dart';
// ignore: implementation_imports,unused_import,prefer_relative_imports
import 'package:dart_model/src/scopes.dart';

/// An augmentation to Dart code. TODO(davidmorgan): this is a placeholder.
extension type Augmentation.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'code': Type.stringPointer,
  });
  Augmentation({
    String? code,
  }) : this.fromJson(Scope.createMap(
          _schema,
          code,
        ));

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
  static final TypedMapSchema _schema = TypedMapSchema({
    'returnType': Type.typedMapPointer,
    'typeParameters': Type.closedListPointer,
    'requiredPositionalParameters': Type.closedListPointer,
    'optionalPositionalParameters': Type.closedListPointer,
    'namedParameters': Type.closedListPointer,
  });
  FunctionTypeDesc({
    StaticTypeDesc? returnType,
    List<StaticTypeParameterDesc>? typeParameters,
    List<StaticTypeDesc>? requiredPositionalParameters,
    List<StaticTypeDesc>? optionalPositionalParameters,
    List<NamedFunctionTypeParameter>? namedParameters,
  }) : this.fromJson(Scope.createMap(
          _schema,
          returnType,
          typeParameters,
          requiredPositionalParameters,
          optionalPositionalParameters,
          namedParameters,
        ));

  /// The return type of this function type.
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
  static final TypedMapSchema _schema = TypedMapSchema({
    'type': Type.typedMapPointer,
  });
  MetadataAnnotation({
    QualifiedName? type,
  }) : this.fromJson(Scope.createMap(
          _schema,
          type,
        ));

  /// The type of the annotation.
  QualifiedName get type => node['type'] as QualifiedName;
}

/// An interface.
extension type Interface.fromJson(Map<String, Object?> node) implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'metadataAnnotations': Type.closedListPointer,
    'members': Type.growableMapPointer,
    'thisType': Type.typedMapPointer,
    'properties': Type.typedMapPointer,
  });
  Interface({
    List<MetadataAnnotation>? metadataAnnotations,
    NamedTypeDesc? thisType,
    Properties? properties,
  }) : this.fromJson(Scope.createMap(
          _schema,
          metadataAnnotations,
          Scope.createGrowableMap(),
          thisType,
          properties,
        ));

  /// The metadata annotations attached to this interface.
  List<MetadataAnnotation> get metadataAnnotations =>
      (node['metadataAnnotations'] as List).cast();

  /// Map of members by name.
  Map<String, Member> get members => (node['members'] as Map).cast();

  /// The type of the expression `this` when used in this interface.
  NamedTypeDesc get thisType => node['thisType'] as NamedTypeDesc;

  /// The properties of this interface.
  Properties get properties => node['properties'] as Properties;
}

/// Library.
extension type Library.fromJson(Map<String, Object?> node) implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'scopes': Type.growableMapPointer,
  });
  Library()
      : this.fromJson(Scope.createMap(
          _schema,
          Scope.createGrowableMap(),
        ));

  /// Scopes by name.
  Map<String, Interface> get scopes => (node['scopes'] as Map).cast();
}

/// Member of a scope.
extension type Member.fromJson(Map<String, Object?> node) implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'properties': Type.typedMapPointer,
    'returnType': Type.typedMapPointer,
  });
  Member({
    Properties? properties,
    StaticTypeDesc? returnType,
  }) : this.fromJson(Scope.createMap(
          _schema,
          properties,
          returnType,
        ));

  /// The properties of this member.
  Properties get properties => node['properties'] as Properties;

  /// The return type of this member, if it has one.
  StaticTypeDesc get returnType => node['returnType'] as StaticTypeDesc;
}

/// Partial model of a corpus of Dart source code.
extension type Model.fromJson(Map<String, Object?> node) implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'uris': Type.growableMapPointer,
    'types': Type.typedMapPointer,
  });
  Model({
    TypeHierarchy? types,
  }) : this.fromJson(Scope.createMap(
          _schema,
          Scope.createGrowableMap(),
          types,
        ));

  /// Libraries by URI.
  Map<String, Library> get uris => (node['uris'] as Map).cast();

  /// The resolved static type hierarchy.
  TypeHierarchy get types => node['types'] as TypeHierarchy;
}

/// A resolved named parameter as part of a [FunctionTypeDesc].
extension type NamedFunctionTypeParameter.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'name': Type.stringPointer,
    'required': Type.boolean,
    'type': Type.typedMapPointer,
  });
  NamedFunctionTypeParameter({
    String? name,
    bool? required,
    StaticTypeDesc? type,
  }) : this.fromJson(Scope.createMap(
          _schema,
          name,
          required,
          type,
        ));
  String get name => node['name'] as String;
  bool get required => node['required'] as bool;
  StaticTypeDesc get type => node['type'] as StaticTypeDesc;
}

/// A named field in a [RecordTypeDesc], consisting of the field name and the associated type.
extension type NamedRecordField.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'name': Type.stringPointer,
    'type': Type.typedMapPointer,
  });
  NamedRecordField({
    String? name,
    StaticTypeDesc? type,
  }) : this.fromJson(Scope.createMap(
          _schema,
          name,
          type,
        ));
  String get name => node['name'] as String;
  StaticTypeDesc get type => node['type'] as StaticTypeDesc;
}

/// A resolved static type.
extension type NamedTypeDesc.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'name': Type.typedMapPointer,
    'instantiation': Type.closedListPointer,
  });
  NamedTypeDesc({
    QualifiedName? name,
    List<StaticTypeDesc>? instantiation,
  }) : this.fromJson(Scope.createMap(
          _schema,
          name,
          instantiation,
        ));
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
  static final TypedMapSchema _schema = TypedMapSchema({
    'inner': Type.typedMapPointer,
  });
  NullableTypeDesc({
    StaticTypeDesc? inner,
  }) : this.fromJson(Scope.createMap(
          _schema,
          inner,
        ));

  /// The type T.
  StaticTypeDesc get inner => node['inner'] as StaticTypeDesc;
}

/// Set of boolean properties.
extension type Properties.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'isAbstract': Type.boolean,
    'isClass': Type.boolean,
    'isGetter': Type.boolean,
    'isField': Type.boolean,
    'isMethod': Type.boolean,
    'isStatic': Type.boolean,
  });
  Properties({
    bool? isAbstract,
    bool? isClass,
    bool? isGetter,
    bool? isField,
    bool? isMethod,
    bool? isStatic,
  }) : this.fromJson(Scope.createMap(
          _schema,
          isAbstract,
          isClass,
          isGetter,
          isField,
          isMethod,
          isStatic,
        ));

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
extension type QualifiedName.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'uri': Type.stringPointer,
    'name': Type.stringPointer,
  });
  QualifiedName({
    String? uri,
    String? name,
  }) : this.fromJson(Scope.createMap(
          _schema,
          uri,
          name,
        ));

  /// Parses [string] of the form `uri#name`.
  static QualifiedName parse(String string) {
    final index = string.indexOf('#');
    if (index == -1) throw ArgumentError('Expected `#` in string: $string');
    return QualifiedName(
        uri: string.substring(0, index), name: string.substring(index + 1));
  }

  /// The URI of the file containing the name.
  String get uri => node['uri'] as String;

  /// The name.
  String get name => node['name'] as String;
}

enum QueryType {
  // Private so switches must have a default. See `isKnown`.
  _unknown,
  queryCode,
  batchQuery,
  queryStaticType;

  bool get isKnown => this != _unknown;
}

extension type Query.fromJson(Map<String, Object?> node) implements Object {
  static Query queryCode(QueryCode queryCode) => Query.fromJson({
        'type': 'QueryCode',
        'value': queryCode,
      });
  static Query batchQuery(BatchQuery batchQuery) => Query.fromJson({
        'type': 'BatchQuery',
        'value': batchQuery,
      });
  static Query queryStaticType(QueryStaticType queryStaticType) =>
      Query.fromJson({
        'type': 'QueryStaticType',
        'value': queryStaticType,
      });
  QueryType get type {
    switch (node['type'] as String) {
      case 'QueryCode':
        return QueryType.queryCode;
      case 'BatchQuery':
        return QueryType.batchQuery;
      case 'QueryStaticType':
        return QueryType.queryStaticType;
      default:
        return QueryType._unknown;
    }
  }

  QueryCode get asQueryCode {
    if (node['type'] != 'QueryCode') {
      throw StateError('Not a QueryCode.');
    }
    return QueryCode.fromJson(node['value'] as Map<String, Object?>);
  }

  BatchQuery get asBatchQuery {
    if (node['type'] != 'BatchQuery') {
      throw StateError('Not a BatchQuery.');
    }
    return BatchQuery.fromJson(node['value'] as Map<String, Object?>);
  }

  QueryStaticType get asQueryStaticType {
    if (node['type'] != 'QueryStaticType') {
      throw StateError('Not a QueryStaticType.');
    }
    return QueryStaticType.fromJson(node['value'] as Map<String, Object?>);
  }
}

/// Query about a Dart element identified by the [target] name.
/// The returned model will contain the element itself, and, if it introduces a type, its position in the type hierarchy.
extension type QueryCode.fromJson(Map<String, Object?> node) implements Object {
  QueryCode({
    QualifiedName? target,
  }) : this.fromJson({
          if (target != null) 'target': target,
        });

  /// The class to query about.
  QualifiedName get target => node['target'] as QualifiedName;
}

/// Include multiple other queries in a [Query] to query multiple aspects of a corpus of Dart source code at once.
extension type BatchQuery.fromJson(Map<String, Object?> node)
    implements Object {
  BatchQuery({
    List<Query>? queries,
  }) : this.fromJson({
          if (queries != null) 'queries': queries,
        });

  /// The inner queries.
  List<Query> get queries => (node['queries'] as List).cast();
}

/// Queries the position a type-defining [target] has in the type hierarchy.
///
/// The returned model will contain [Model.types] for the queried class, as well as all superclasses. Unlike with [QueryCode] however, no information is included about the structure of resolved classes.
extension type QueryStaticType.fromJson(Map<String, Object?> node)
    implements Object {
  QueryStaticType({
    QualifiedName? target,
  }) : this.fromJson({
          if (target != null) 'target': target,
        });

  /// The class for which type information is queried.
  QualifiedName get target => node['target'] as QualifiedName;
}

/// A resolved record type in the type hierarchy.
extension type RecordTypeDesc.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'positional': Type.closedListPointer,
    'named': Type.closedListPointer,
  });
  RecordTypeDesc({
    List<StaticTypeDesc>? positional,
    List<NamedRecordField>? named,
  }) : this.fromJson(Scope.createMap(
          _schema,
          positional,
          named,
        ));
  List<StaticTypeDesc> get positional => (node['positional'] as List).cast();
  List<NamedRecordField> get named => (node['named'] as List).cast();
}

enum StaticTypeDescType {
  // Private so switches must have a default. See `isKnown`.
  _unknown,
  dynamicTypeDesc,
  functionTypeDesc,
  namedTypeDesc,
  neverTypeDesc,
  nullableTypeDesc,
  recordTypeDesc,
  typeParameterTypeDesc,
  voidTypeDesc;

  bool get isKnown => this != _unknown;
}

extension type StaticTypeDesc.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'type': Type.stringPointer,
    'value': Type.anyPointer,
  });
  static StaticTypeDesc dynamicTypeDesc(DynamicTypeDesc dynamicTypeDesc) =>
      StaticTypeDesc.fromJson(Scope.createMap(
        _schema,
        'DynamicTypeDesc',
        dynamicTypeDesc,
      ));
  static StaticTypeDesc functionTypeDesc(FunctionTypeDesc functionTypeDesc) =>
      StaticTypeDesc.fromJson(Scope.createMap(
        _schema,
        'FunctionTypeDesc',
        functionTypeDesc,
      ));
  static StaticTypeDesc namedTypeDesc(NamedTypeDesc namedTypeDesc) =>
      StaticTypeDesc.fromJson(Scope.createMap(
        _schema,
        'NamedTypeDesc',
        namedTypeDesc,
      ));
  static StaticTypeDesc neverTypeDesc(NeverTypeDesc neverTypeDesc) =>
      StaticTypeDesc.fromJson(Scope.createMap(
        _schema,
        'NeverTypeDesc',
        neverTypeDesc,
      ));
  static StaticTypeDesc nullableTypeDesc(NullableTypeDesc nullableTypeDesc) =>
      StaticTypeDesc.fromJson(Scope.createMap(
        _schema,
        'NullableTypeDesc',
        nullableTypeDesc,
      ));
  static StaticTypeDesc recordTypeDesc(RecordTypeDesc recordTypeDesc) =>
      StaticTypeDesc.fromJson(Scope.createMap(
        _schema,
        'RecordTypeDesc',
        recordTypeDesc,
      ));
  static StaticTypeDesc typeParameterTypeDesc(
          TypeParameterTypeDesc typeParameterTypeDesc) =>
      StaticTypeDesc.fromJson(Scope.createMap(
        _schema,
        'TypeParameterTypeDesc',
        typeParameterTypeDesc,
      ));
  static StaticTypeDesc voidTypeDesc(VoidTypeDesc voidTypeDesc) =>
      StaticTypeDesc.fromJson(Scope.createMap(
        _schema,
        'VoidTypeDesc',
        voidTypeDesc,
      ));
  StaticTypeDescType get type {
    switch (node['type'] as String) {
      case 'DynamicTypeDesc':
        return StaticTypeDescType.dynamicTypeDesc;
      case 'FunctionTypeDesc':
        return StaticTypeDescType.functionTypeDesc;
      case 'NamedTypeDesc':
        return StaticTypeDescType.namedTypeDesc;
      case 'NeverTypeDesc':
        return StaticTypeDescType.neverTypeDesc;
      case 'NullableTypeDesc':
        return StaticTypeDescType.nullableTypeDesc;
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

  NamedTypeDesc get asNamedTypeDesc {
    if (node['type'] != 'NamedTypeDesc') {
      throw StateError('Not a NamedTypeDesc.');
    }
    return NamedTypeDesc.fromJson(node['value'] as Map<String, Object?>);
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
  static final TypedMapSchema _schema = TypedMapSchema({
    'identifier': Type.uint32,
    'bound': Type.typedMapPointer,
  });
  StaticTypeParameterDesc({
    int? identifier,
    StaticTypeDesc? bound,
  }) : this.fromJson(Scope.createMap(
          _schema,
          identifier,
          bound,
        ));
  int get identifier => node['identifier'] as int;
  StaticTypeDesc? get bound => node['bound'] as StaticTypeDesc?;
}

/// View of a subset of a Dart program's type hierarchy as part of a queried model.
extension type TypeHierarchy.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'named': Type.growableMapPointer,
  });
  TypeHierarchy()
      : this.fromJson(Scope.createMap(
          _schema,
          Scope.createGrowableMap(),
        ));

  /// Map of qualified interface names to their resolved named type.
  Map<String, TypeHierarchyEntry> get named => (node['named'] as Map).cast();
}

/// Entry of an interface in Dart's type hierarchy, along with supertypes.
extension type TypeHierarchyEntry.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'typeParameters': Type.closedListPointer,
    'self': Type.typedMapPointer,
    'supertypes': Type.closedListPointer,
  });
  TypeHierarchyEntry({
    List<StaticTypeParameterDesc>? typeParameters,
    NamedTypeDesc? self,
    List<NamedTypeDesc>? supertypes,
  }) : this.fromJson(Scope.createMap(
          _schema,
          typeParameters,
          self,
          supertypes,
        ));

  /// Type parameters defined on this interface-defining element.
  List<StaticTypeParameterDesc> get typeParameters =>
      (node['typeParameters'] as List).cast();

  /// The named static type represented by this entry.
  NamedTypeDesc get self => node['self'] as NamedTypeDesc;

  /// All direct supertypes of this type.
  List<NamedTypeDesc> get supertypes => (node['supertypes'] as List).cast();
}

/// A type formed by a reference to a type parameter.
extension type TypeParameterTypeDesc.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'parameterId': Type.uint32,
  });
  TypeParameterTypeDesc({
    int? parameterId,
  }) : this.fromJson(Scope.createMap(
          _schema,
          parameterId,
        ));
  int get parameterId => node['parameterId'] as int;
}

/// The type-hierarchy representation of the type `void`.
extension type VoidTypeDesc.fromJson(Null _) {
  VoidTypeDesc() : this.fromJson(null);
}
