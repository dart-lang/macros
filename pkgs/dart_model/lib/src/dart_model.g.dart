// This file is generated. To make changes edit schemas/*.schema.json
// then run from the repo root: dart tool/model_generator/bin/main.dart

/// An augmentation to Dart code. TODO(davidmorgan): this is a placeholder.
extension type Augmentation.fromJson(Map<String, Object?> node) {
  Augmentation({
    String? code,
  }) : this.fromJson({
          if (code != null) 'code': code,
        });

  /// Augmentation code.
  String get code => node['code'] as String;
}

/// A metadata annotation.
extension type MetadataAnnotation.fromJson(Map<String, Object?> node) {
  MetadataAnnotation({
    QualifiedName? type,
  }) : this.fromJson({
          if (type != null) 'type': type,
        });

  /// The type of the annotation.
  QualifiedName get type => node['type'] as QualifiedName;
}

/// An interface.
extension type Interface.fromJson(Map<String, Object?> node) {
  Interface({
    List<MetadataAnnotation>? metadataAnnotations,
    Map<String, Member>? members,
    Properties? properties,
  }) : this.fromJson({
          if (metadataAnnotations != null)
            'metadataAnnotations': metadataAnnotations,
          if (members != null) 'members': members,
          if (properties != null) 'properties': properties,
        });

  /// The metadata annotations attached to this iterface.
  List<MetadataAnnotation> get metadataAnnotations =>
      (node['metadataAnnotations'] as List).cast();

  /// Map of members by name.
  Map<String, Member> get members => (node['members'] as Map).cast();

  /// The properties of this interface.
  Properties get properties => node['properties'] as Properties;
}

/// Library.
extension type Library.fromJson(Map<String, Object?> node) {
  Library({
    Map<String, Interface>? scopes,
  }) : this.fromJson({
          if (scopes != null) 'scopes': scopes,
        });

  /// Scopes by name.
  Map<String, Interface> get scopes => (node['scopes'] as Map).cast();
}

/// Member of a scope.
extension type Member.fromJson(Map<String, Object?> node) {
  Member({
    Properties? properties,
  }) : this.fromJson({
          if (properties != null) 'properties': properties,
        });

  /// The properties of this member.
  Properties get properties => node['properties'] as Properties;
}

/// Partial model of a corpus of Dart source code.
extension type Model.fromJson(Map<String, Object?> node) {
  Model({
    Map<String, Library>? uris,
  }) : this.fromJson({
          if (uris != null) 'uris': uris,
        });

  /// Libraries by URI.
  Map<String, Library> get uris => (node['uris'] as Map).cast();
}

/// Representation of the bottom type [Never].
extension type NeverType.fromJson(Null _) {
  NeverType() : this.fromJson(null);
}

/// A Dart type of the form `T?` for an inner type `T`.
extension type NullableType.fromJson(Map<String, Object?> node) {
  NullableType({
    StaticType? inner,
  }) : this.fromJson({
          if (inner != null) 'inner': inner,
        });
  StaticType get inner => node['inner'] as StaticType;
}

/// Set of boolean properties.
extension type Properties.fromJson(Map<String, Object?> node) {
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
extension type QualifiedName.fromJson(String string) {
  QualifiedName(String string) : this.fromJson(string);
}

/// Query about a corpus of Dart source code. TODO(davidmorgan): this queries about a single class, expand to a union type for different types of queries.
extension type Query.fromJson(Map<String, Object?> node) {
  Query({
    QualifiedName? target,
  }) : this.fromJson({
          if (target != null) 'target': target,
        });

  /// The class to query about.
  QualifiedName get target => node['target'] as QualifiedName;
}

enum StaticTypeType {
  // Private so switches must have a default. See `isKnown`.
  _unknown,
  neverType,
  nullableType,
  voidType;

  bool get isKnown => this != _unknown;
}

extension type StaticType.fromJson(Map<String, Object?> node) {
  static StaticType neverType(NeverType neverType) =>
      StaticType.fromJson({'type': 'NeverType', 'value': null});
  static StaticType nullableType(NullableType nullableType) =>
      StaticType.fromJson({'type': 'NullableType', 'value': nullableType.node});
  static StaticType voidType(VoidType voidType) =>
      StaticType.fromJson({'type': 'VoidType', 'value': voidType.string});
  StaticTypeType get type {
    switch (node['type'] as String) {
      case 'NeverType':
        return StaticTypeType.neverType;
      case 'NullableType':
        return StaticTypeType.nullableType;
      case 'VoidType':
        return StaticTypeType.voidType;
      default:
        return StaticTypeType._unknown;
    }
  }

  NeverType get asNeverType {
    if (node['type'] != 'NeverType') {
      throw StateError('Not a NeverType.');
    }
    return NeverType.fromJson(node['value'] as Null);
  }

  NullableType get asNullableType {
    if (node['type'] != 'NullableType') {
      throw StateError('Not a NullableType.');
    }
    return NullableType.fromJson(node['value'] as Map<String, Object?>);
  }

  VoidType get asVoidType {
    if (node['type'] != 'VoidType') {
      throw StateError('Not a VoidType.');
    }
    return VoidType.fromJson(node['value'] as String);
  }
}

/// The type-hierarchy representation of the type `void`.
extension type VoidType.fromJson(String string) {
  VoidType(String string) : this.fromJson(string);
}
