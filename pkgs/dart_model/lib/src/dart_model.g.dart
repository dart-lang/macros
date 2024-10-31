// This file is generated. To make changes edit tool/dart_model_generator
// then run from the repo root: dart tool/dart_model_generator/bin/main.dart

// ignore: implementation_imports,unused_import,prefer_relative_imports
import 'package:dart_model/src/deep_cast_map.dart';
// ignore: implementation_imports,unused_import,prefer_relative_imports
import 'package:dart_model/src/json_buffer/json_buffer_builder.dart';
// ignore: implementation_imports,unused_import,prefer_relative_imports
import 'package:dart_model/src/macro_metadata.g.dart';
// ignore: implementation_imports,unused_import,prefer_relative_imports
import 'package:dart_model/src/scopes.dart';

/// An augmentation to Dart code.
extension type Augmentation.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'code': Type.closedListPointer,
  });
  Augmentation({
    List<Code>? code,
  }) : this.fromJson(Scope.createMap(
          _schema,
          code,
        ));

  /// Augmentation code.
  List<Code> get code => (node['code'] as List).cast<Code>();

  /// Hash code for comparing instances of this extension type.
  int get identityHash => Object.hashAll((node['code'] as List?)
          ?.cast<Code>()
          ?.map((entry) => entry.identityHash) ??
      const []);
}

enum CodeType {
  // Private so switches must have a default. See `isKnown`.
  _unknown,
  qualifiedName,
  string;

  bool get isKnown => this != _unknown;
}

extension type Code.fromJson(Map<String, Object?> node) implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'type': Type.stringPointer,
    'value': Type.anyPointer,
  });
  static Code qualifiedName(QualifiedName qualifiedName) =>
      Code.fromJson(Scope.createMap(
        _schema,
        'QualifiedName',
        qualifiedName,
      ));
  static Code string(String string) => Code.fromJson(Scope.createMap(
        _schema,
        'String',
        string,
      ));
  CodeType get type {
    switch (node['type'] as String) {
      case 'QualifiedName':
        return CodeType.qualifiedName;
      case 'String':
        return CodeType.string;
      default:
        return CodeType._unknown;
    }
  }

  QualifiedName get asQualifiedName {
    if (node['type'] != 'QualifiedName') {
      throw StateError('Not a QualifiedName.');
    }
    return QualifiedName.fromJson(node['value'] as Map<String, Object?>);
  }

  String get asString {
    if (node['type'] != 'String') {
      throw StateError('Not a String.');
    }
    return node['value'] as String;
  }

  /// Hash code for comparing instances of this extension type.
// TODO: A real implementation for union types.
  int get identityHash => 0;
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
      (node['typeParameters'] as List).cast<StaticTypeParameterDesc>();
  List<StaticTypeDesc> get requiredPositionalParameters =>
      (node['requiredPositionalParameters'] as List).cast<StaticTypeDesc>();
  List<StaticTypeDesc> get optionalPositionalParameters =>
      (node['optionalPositionalParameters'] as List).cast<StaticTypeDesc>();
  List<NamedFunctionTypeParameter> get namedParameters =>
      (node['namedParameters'] as List).cast<NamedFunctionTypeParameter>();

  /// Hash code for comparing instances of this extension type.
  int get identityHash => Object.hash(
        (node['returnType'] as StaticTypeDesc?)?.identityHash ?? 0,
        Object.hashAll((node['typeParameters'] as List?)
                ?.cast<StaticTypeParameterDesc>()
                ?.map((entry) => entry.identityHash) ??
            const []),
        Object.hashAll((node['requiredPositionalParameters'] as List?)
                ?.cast<StaticTypeDesc>()
                ?.map((entry) => entry.identityHash) ??
            const []),
        Object.hashAll((node['optionalPositionalParameters'] as List?)
                ?.cast<StaticTypeDesc>()
                ?.map((entry) => entry.identityHash) ??
            const []),
        Object.hashAll((node['namedParameters'] as List?)
                ?.cast<NamedFunctionTypeParameter>()
                ?.map((entry) => entry.identityHash) ??
            const []),
      );
}

/// A metadata annotation.
extension type MetadataAnnotation.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'expression': Type.typedMapPointer,
  });
  MetadataAnnotation({
    Expression? expression,
  }) : this.fromJson(Scope.createMap(
          _schema,
          expression,
        ));

  /// The expression of the annotation.
  Expression get expression => node['expression'] as Expression;

  /// Hash code for comparing instances of this extension type.
  int get identityHash =>
      (node['expression'] as Expression?)?.identityHash ?? 0;
}

/// Interface type for all declarations
extension type Declaration._(Map<String, Object?> node) implements Object {
  /// The metadata annotations attached to this declaration.
  List<MetadataAnnotation> get metadataAnnotations =>
      (node['metadataAnnotations'] as List).cast<MetadataAnnotation>();

  /// The properties of this declaration.
  Properties get properties => node['properties'] as Properties;

  /// Hash code for comparing instances of this extension type.
  int get identityHash => Object.hash(
        Object.hashAll((node['metadataAnnotations'] as List?)
                ?.cast<MetadataAnnotation>()
                ?.map((entry) => entry.identityHash) ??
            const []),
        (node['properties'] as Properties?)?.identityHash ?? 0,
      );
}

/// An interface.
extension type Interface.fromJson(Map<String, Object?> node)
    implements Declaration {
  static final TypedMapSchema _schema = TypedMapSchema({
    'members': Type.growableMapPointer,
    'thisType': Type.typedMapPointer,
    'metadataAnnotations': Type.closedListPointer,
    'properties': Type.typedMapPointer,
  });
  Interface({
    NamedTypeDesc? thisType,
    List<MetadataAnnotation>? metadataAnnotations,
    Properties? properties,
  }) : this.fromJson(Scope.createMap(
          _schema,
          Scope.createGrowableMap(),
          thisType,
          metadataAnnotations,
          properties,
        ));

  /// Map of members by name.
  Map<String, Member> get members =>
      (node['members'] as Map).cast<String, Member>();

  /// The type of the expression `this` when used in this interface.
  NamedTypeDesc get thisType => node['thisType'] as NamedTypeDesc;

  /// Hash code for comparing instances of this extension type.
  int get identityHash => Object.hash(
        Object.hashAll((node['members'] as Map?)
                ?.cast<String, Member>()
                ?.entries
                .map((entry) =>
                    Object.hash(entry.key, entry.value.identityHash)) ??
            const []),
        (node['thisType'] as NamedTypeDesc?)?.identityHash ?? 0,
        Object.hashAll((node['metadataAnnotations'] as List?)
                ?.cast<MetadataAnnotation>()
                ?.map((entry) => entry.identityHash) ??
            const []),
        (node['properties'] as Properties?)?.identityHash ?? 0,
      );
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
  Map<String, Interface> get scopes =>
      (node['scopes'] as Map).cast<String, Interface>();

  /// Hash code for comparing instances of this extension type.
  int get identityHash => Object.hashAll((node['scopes'] as Map?)
          ?.cast<String, Interface>()
          ?.entries
          .map((entry) => Object.hash(entry.key, entry.value.identityHash)) ??
      const []);
}

/// Member of a scope.
extension type Member.fromJson(Map<String, Object?> node)
    implements Declaration {
  static final TypedMapSchema _schema = TypedMapSchema({
    'returnType': Type.typedMapPointer,
    'requiredPositionalParameters': Type.closedListPointer,
    'optionalPositionalParameters': Type.closedListPointer,
    'namedParameters': Type.closedListPointer,
    'metadataAnnotations': Type.closedListPointer,
    'properties': Type.typedMapPointer,
  });
  Member({
    StaticTypeDesc? returnType,
    List<StaticTypeDesc>? requiredPositionalParameters,
    List<StaticTypeDesc>? optionalPositionalParameters,
    List<NamedFunctionTypeParameter>? namedParameters,
    List<MetadataAnnotation>? metadataAnnotations,
    Properties? properties,
  }) : this.fromJson(Scope.createMap(
          _schema,
          returnType,
          requiredPositionalParameters,
          optionalPositionalParameters,
          namedParameters,
          metadataAnnotations,
          properties,
        ));

  /// The return type of this member, if it has one.
  StaticTypeDesc get returnType => node['returnType'] as StaticTypeDesc;

  /// The required positional parameters of this member, if it has them.
  List<StaticTypeDesc> get requiredPositionalParameters =>
      (node['requiredPositionalParameters'] as List).cast<StaticTypeDesc>();

  /// The optional positional parameters of this member, if it has them.
  List<StaticTypeDesc> get optionalPositionalParameters =>
      (node['optionalPositionalParameters'] as List).cast<StaticTypeDesc>();

  /// The named parameters of this member, if it has them.
  List<NamedFunctionTypeParameter> get namedParameters =>
      (node['namedParameters'] as List).cast<NamedFunctionTypeParameter>();

  /// Hash code for comparing instances of this extension type.
  int get identityHash => Object.hash(
        (node['returnType'] as StaticTypeDesc?)?.identityHash ?? 0,
        Object.hashAll((node['requiredPositionalParameters'] as List?)
                ?.cast<StaticTypeDesc>()
                ?.map((entry) => entry.identityHash) ??
            const []),
        Object.hashAll((node['optionalPositionalParameters'] as List?)
                ?.cast<StaticTypeDesc>()
                ?.map((entry) => entry.identityHash) ??
            const []),
        Object.hashAll((node['namedParameters'] as List?)
                ?.cast<NamedFunctionTypeParameter>()
                ?.map((entry) => entry.identityHash) ??
            const []),
        Object.hashAll((node['metadataAnnotations'] as List?)
                ?.cast<MetadataAnnotation>()
                ?.map((entry) => entry.identityHash) ??
            const []),
        (node['properties'] as Properties?)?.identityHash ?? 0,
      );
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
  Map<String, Library> get uris =>
      (node['uris'] as Map).cast<String, Library>();

  /// The resolved static type hierarchy.
  TypeHierarchy get types => node['types'] as TypeHierarchy;

  static final watch = Stopwatch()..start();

  /// Hash code for comparing instances of this extension type.
  int get identityHash {
    watch.start();
    try {
      return Object.hash(
        Object.hashAll((node['uris'] as Map?)
                ?.cast<String, Library>()
                ?.entries
                .map((entry) =>
                    Object.hash(entry.key, entry.value.identityHash)) ??
            const []),
        (node['types'] as TypeHierarchy?)?.identityHash ?? 0,
      );
    } finally {
      watch.stop();
      print('Model.identityHash: ${watch.elapsedMilliseconds}ms');
    }
  }
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

  /// Hash code for comparing instances of this extension type.
  int get identityHash => Object.hash(
        (node['name'] as String?).hashCode,
        (node['required'] as bool?).hashCode,
        (node['type'] as StaticTypeDesc?)?.identityHash ?? 0,
      );
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

  /// Hash code for comparing instances of this extension type.
  int get identityHash => Object.hash(
        (node['name'] as String?).hashCode,
        (node['type'] as StaticTypeDesc?)?.identityHash ?? 0,
      );
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
      (node['instantiation'] as List).cast<StaticTypeDesc>();

  /// Hash code for comparing instances of this extension type.
  int get identityHash => Object.hash(
        (node['name'] as QualifiedName?)?.identityHash ?? 0,
        Object.hashAll((node['instantiation'] as List?)
                ?.cast<StaticTypeDesc>()
                ?.map((entry) => entry.identityHash) ??
            const []),
      );
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

  /// Hash code for comparing instances of this extension type.
  int get identityHash => (node['inner'] as StaticTypeDesc?)?.identityHash ?? 0;
}

/// Set of boolean properties.
extension type Properties.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'isAbstract': Type.boolean,
    'isClass': Type.boolean,
    'isConstructor': Type.boolean,
    'isGetter': Type.boolean,
    'isField': Type.boolean,
    'isMethod': Type.boolean,
    'isStatic': Type.boolean,
  });
  Properties({
    bool? isAbstract,
    bool? isClass,
    bool? isConstructor,
    bool? isGetter,
    bool? isField,
    bool? isMethod,
    bool? isStatic,
  }) : this.fromJson(Scope.createMap(
          _schema,
          isAbstract,
          isClass,
          isConstructor,
          isGetter,
          isField,
          isMethod,
          isStatic,
        ));

  /// Whether the entity is abstract, meaning it has no definition.
  bool get isAbstract => node['isAbstract'] as bool;

  /// Whether the entity is a class.
  bool get isClass => node['isClass'] as bool;

  /// Whether the entity is a constructor.
  bool get isConstructor => node['isConstructor'] as bool;

  /// Whether the entity is a getter.
  bool get isGetter => node['isGetter'] as bool;

  /// Whether the entity is a field.
  bool get isField => node['isField'] as bool;

  /// Whether the entity is a method.
  bool get isMethod => node['isMethod'] as bool;

  /// Whether the entity is static.
  bool get isStatic => node['isStatic'] as bool;

  /// Hash code for comparing instances of this extension type.
  int get identityHash => Object.hash(
        (node['isAbstract'] as bool?).hashCode,
        (node['isClass'] as bool?).hashCode,
        (node['isConstructor'] as bool?).hashCode,
        (node['isGetter'] as bool?).hashCode,
        (node['isField'] as bool?).hashCode,
        (node['isMethod'] as bool?).hashCode,
        (node['isStatic'] as bool?).hashCode,
      );
}

/// A URI combined with a name and scope referring to a declaration. The name and scope are looked up in the export scope of the URI.
extension type QualifiedName.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'uri': Type.stringPointer,
    'scope': Type.stringPointer,
    'name': Type.stringPointer,
    'isStatic': Type.boolean,
  });
  QualifiedName({
    String? uri,
    String? scope,
    String? name,
    bool? isStatic,
  }) : this.fromJson(Scope.createMap(
          _schema,
          uri,
          scope,
          name,
          isStatic,
        ));

  /// Parses [string] of the form `uri#[scope.|scope::]name`.
  ///
  /// No scope indicates a top level declaration in the library.
  ///
  /// If the scope and name are separated with a `.` that indicates the
  /// instance scope, and a `::` indicates the static scope.
  static QualifiedName parse(String string) {
    final index = string.indexOf('#');
    if (index == -1) throw ArgumentError('Expected `#` in string: $string');
    final nameAndScope = string.substring(index + 1);
    late final String name;
    late final String? scope;
    late final bool? isStatic;
    if (nameAndScope.contains('::')) {
      [scope, name] = nameAndScope.split('::');
      isStatic = true;
    } else if (nameAndScope.contains('.')) {
      [scope, name] = nameAndScope.split('.');
      isStatic = false;
    } else {
      name = nameAndScope;
      scope = null;
      isStatic = null;
    }
    return QualifiedName(
        uri: string.substring(0, index),
        name: name,
        scope: scope,
        isStatic: isStatic);
  }

  /// The URI of the file containing the name.
  String get uri => node['uri'] as String;

  /// The optional scope to look up the name in.
  String? get scope => node['scope'] as String?;

  /// The name of the declaration to look up.
  String get name => node['name'] as String;

  /// Whether the name refers to something in the static scope as opposed to the instance scope of `scope`. Will be `null` if `scope` is `null`.
  bool? get isStatic => node['isStatic'] as bool?;

  /// Hash code for comparing instances of this extension type.
  int get identityHash => Object.hash(
        (node['uri'] as String?).hashCode,
        (node['scope'] as String?).hashCode,
        (node['name'] as String?).hashCode,
        (node['isStatic'] as bool?).hashCode,
      );
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

  /// Hash code for comparing instances of this extension type.
  int get identityHash => (node['target'] as QualifiedName?)?.identityHash ?? 0;
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
  List<StaticTypeDesc> get positional =>
      (node['positional'] as List).cast<StaticTypeDesc>();
  List<NamedRecordField> get named =>
      (node['named'] as List).cast<NamedRecordField>();

  /// Hash code for comparing instances of this extension type.
  int get identityHash => Object.hash(
        Object.hashAll((node['positional'] as List?)
                ?.cast<StaticTypeDesc>()
                ?.map((entry) => entry.identityHash) ??
            const []),
        Object.hashAll((node['named'] as List?)
                ?.cast<NamedRecordField>()
                ?.map((entry) => entry.identityHash) ??
            const []),
      );
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

  /// Hash code for comparing instances of this extension type.
// TODO: A real implementation for union types.
  int get identityHash => 0;
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

  /// Hash code for comparing instances of this extension type.
  int get identityHash => Object.hash(
        (node['identifier'] as int?).hashCode,
        (node['bound'] as StaticTypeDesc?)?.identityHash ?? 0,
      );
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
  Map<String, TypeHierarchyEntry> get named =>
      (node['named'] as Map).cast<String, TypeHierarchyEntry>();

  /// Hash code for comparing instances of this extension type.
  int get identityHash => Object.hashAll((node['named'] as Map?)
          ?.cast<String, TypeHierarchyEntry>()
          ?.entries
          .map((entry) => Object.hash(entry.key, entry.value.identityHash)) ??
      const []);
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
      (node['typeParameters'] as List).cast<StaticTypeParameterDesc>();

  /// The named static type represented by this entry.
  NamedTypeDesc get self => node['self'] as NamedTypeDesc;

  /// All direct supertypes of this type.
  List<NamedTypeDesc> get supertypes =>
      (node['supertypes'] as List).cast<NamedTypeDesc>();

  /// Hash code for comparing instances of this extension type.
  int get identityHash => Object.hash(
        Object.hashAll((node['typeParameters'] as List?)
                ?.cast<StaticTypeParameterDesc>()
                ?.map((entry) => entry.identityHash) ??
            const []),
        (node['self'] as NamedTypeDesc?)?.identityHash ?? 0,
        Object.hashAll((node['supertypes'] as List?)
                ?.cast<NamedTypeDesc>()
                ?.map((entry) => entry.identityHash) ??
            const []),
      );
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

  /// Hash code for comparing instances of this extension type.
  int get identityHash => (node['parameterId'] as int?).hashCode;
}

/// The type-hierarchy representation of the type `void`.
extension type VoidTypeDesc.fromJson(Null _) {
  VoidTypeDesc() : this.fromJson(null);
}
