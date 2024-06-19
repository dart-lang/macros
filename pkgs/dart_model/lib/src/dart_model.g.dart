// This file is generated. To make changes, edit schemas/dart_model.schema.json
// then run from the repo root: dart tool/model_generator/bin/main.dart

extension type MetadataAnnotation.fromJson(Map<String, Object?> node) {
  MetadataAnnotation({
    QualifiedName? type,
  }) : this.fromJson({
          if (type != null) 'type': type,
        });
  QualifiedName get type => node['type'] as QualifiedName;
}

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
  List<MetadataAnnotation> get metadataAnnotations =>
      (node['metadataAnnotations'] as List).cast();
  Map<String, Member> get members => (node['members'] as Map).cast();
  Properties get properties => node['properties'] as Properties;
}

extension type Member.fromJson(Map<String, Object?> node) {
  Member({
    Properties? properties,
  }) : this.fromJson({
          if (properties != null) 'properties': properties,
        });
  Properties get properties => node['properties'] as Properties;
}

extension type Model.fromJson(Map<String, Object?> node) {
  Model({
    Map<String, Library>? uris,
  }) : this.fromJson({
          if (uris != null) 'uris': uris,
        });
  Map<String, Library> get uris => (node['uris'] as Map).cast();
}

extension type Properties.fromJson(Map<String, Object?> node) {
  Properties({
    bool? isAbstract,
    bool? isClass,
    bool? isGetter,
    bool? isField,
    bool? isMethod,
    bool? isStatic,
    bool? isSynthetic,
  }) : this.fromJson({
          if (isAbstract != null) 'isAbstract': isAbstract,
          if (isClass != null) 'isClass': isClass,
          if (isGetter != null) 'isGetter': isGetter,
          if (isField != null) 'isField': isField,
          if (isMethod != null) 'isMethod': isMethod,
          if (isStatic != null) 'isStatic': isStatic,
          if (isSynthetic != null) 'isSynthetic': isSynthetic,
        });
  bool get isAbstract => node['isAbstract'] as bool;
  bool get isClass => node['isClass'] as bool;
  bool get isGetter => node['isGetter'] as bool;
  bool get isField => node['isField'] as bool;
  bool get isMethod => node['isMethod'] as bool;
  bool get isStatic => node['isStatic'] as bool;
  bool get isSynthetic => node['isSynthetic'] as bool;
}

extension type Library.fromJson(Map<String, Object?> node) {
  Library({
    Map<String, Interface>? scopes,
  }) : this.fromJson({
          if (scopes != null) 'scopes': scopes,
        });
  Map<String, Interface> get scopes => (node['scopes'] as Map).cast();
}

extension type QualifiedName.fromJson(String string) {
  QualifiedName(String string) : this.fromJson(string);
}
