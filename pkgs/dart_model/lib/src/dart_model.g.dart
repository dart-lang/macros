// This file is generated. To make changes edit schemas/*.schema.json
// then run from the repo root: dart tool/dart_model_generator/bin/main.dart

import 'json_buffer.dart' show LazyMap;

/// An augmentation to Dart code. TODO(davidmorgan): this is a placeholder.
extension type Augmentation.fromJson(Map<String, Object?> node) {
  Augmentation({
    String? code,
  }) : this.fromJson(LazyMap(
            [
              if (code != null) 'code',
            ],
            (key) => switch (key) {
                  'code' => code,
                  _ => null,
                }));

  /// Augmentation code.
  String get code => node['code'] as String;
}

/// A metadata annotation.
extension type MetadataAnnotation.fromJson(Map<String, Object?> node) {
  MetadataAnnotation({
    QualifiedName? type,
  }) : this.fromJson(LazyMap(
            [
              if (type != null) 'type',
            ],
            (key) => switch (key) {
                  'type' => type,
                  _ => null,
                }));

  /// The type of the annotation.
  QualifiedName get type => node['type'] as QualifiedName;
}

/// An interface.
extension type Interface.fromJson(Map<String, Object?> node) {
  Interface({
    List<MetadataAnnotation>? metadataAnnotations,
    Map<String, Member>? members,
    Properties? properties,
  }) : this.fromJson(LazyMap(
            [
              if (metadataAnnotations != null) 'metadataAnnotations',
              if (members != null) 'members',
              if (properties != null) 'properties',
            ],
            (key) => switch (key) {
                  'metadataAnnotations' => metadataAnnotations,
                  'members' => members,
                  'properties' => properties,
                  _ => null,
                }));

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
  }) : this.fromJson(LazyMap(
            [
              if (scopes != null) 'scopes',
            ],
            (key) => switch (key) {
                  'scopes' => scopes,
                  _ => null,
                }));

  /// Scopes by name.
  Map<String, Interface> get scopes => (node['scopes'] as Map).cast();
}

/// Member of a scope.
extension type Member.fromJson(Map<String, Object?> node) {
  Member({
    Properties? properties,
  }) : this.fromJson(LazyMap(
            [
              if (properties != null) 'properties',
            ],
            (key) => switch (key) {
                  'properties' => properties,
                  _ => null,
                }));

  /// The properties of this member.
  Properties get properties => node['properties'] as Properties;
}

/// Partial model of a corpus of Dart source code.
extension type Model.fromJson(Map<String, Object?> node) {
  Model({
    Map<String, Library>? uris,
  }) : this.fromJson(LazyMap(
            [
              if (uris != null) 'uris',
            ],
            (key) => switch (key) {
                  'uris' => uris,
                  _ => null,
                }));

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
  }) : this.fromJson(LazyMap(
            [
              if (inner != null) 'inner',
            ],
            (key) => switch (key) {
                  'inner' => inner,
                  _ => null,
                }));
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
  }) : this.fromJson(LazyMap(
            [
              if (isAbstract != null) 'isAbstract',
              if (isClass != null) 'isClass',
              if (isGetter != null) 'isGetter',
              if (isField != null) 'isField',
              if (isMethod != null) 'isMethod',
              if (isStatic != null) 'isStatic',
            ],
            (key) => switch (key) {
                  'isAbstract' => isAbstract,
                  'isClass' => isClass,
                  'isGetter' => isGetter,
                  'isField' => isField,
                  'isMethod' => isMethod,
                  'isStatic' => isStatic,
                  _ => null,
                }));

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
  }) : this.fromJson(LazyMap(
            [
              if (target != null) 'target',
            ],
            (key) => switch (key) {
                  'target' => target,
                  _ => null,
                }));

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
  static StaticType neverType(NeverType neverType) => StaticType.fromJson({
        'type': 'NeverType',
        'value': neverType,
      });
  static StaticType nullableType(NullableType nullableType) =>
      StaticType.fromJson({
        'type': 'NullableType',
        'value': nullableType,
      });
  static StaticType voidType(VoidType voidType) => StaticType.fromJson({
        'type': 'VoidType',
        'value': voidType,
      });
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
