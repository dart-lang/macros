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

/// Query about a corpus of Dart source code. TODO(davidmorgan): this is a placeholder.
extension type Query.fromJson(Map<String, Object?> node) {
  Query() : this.fromJson({});
}
