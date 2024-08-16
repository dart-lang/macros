// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/src/json_buffer/json_buffer_builder.dart';

import 'serialization_benchmark.dart';

JsonBufferBuilder? runningBuffer;

/// Benchmark accumulating data directly into a [JsonBufferBuilder].
class BuilderMapsBuilderWireBenchmark extends SerializationBenchmark {
  @override
  void run() {
    createData();

    serialized = runningBuffer!.serialize();
  }

  Map<String, Object?> createData() {
    final buffer = runningBuffer = JsonBufferBuilder();
    final map = buffer.map;

    for (final key in mapKeys) {
      final intKey = int.parse(key);
      final members = buffer.createGrowableMap<Member>();
      map[key] = Interface(
          members: members,
          properties: Properties(
              isAbstract: (intKey & 1) == 1,
              isClass: (intKey & 2) == 2,
              isGetter: (intKey & 4) == 4,
              isField: (intKey & 8) == 8,
              isMethod: (intKey & 16) == 16,
              isStatic: (intKey & 32) == 32));
      members['a'] = _makeMember('a');
      members['aa'] = _makeMember('aa');
      members['aaa'] = _makeMember('aaa');
      members['aaaa'] = _makeMember('aaaa');
    }

    return buffer.map;
  }

  @override
  void deserialize() {
    deserialized = JsonBufferBuilder.deserialize(serialized!).map;
  }

  Member _makeMember(String key) {
    final intKey = key.length;
    return Member(
        properties: Properties(
            isAbstract: (intKey & 1) == 1,
            isClass: (intKey & 2) == 2,
            isGetter: (intKey & 4) == 4,
            isField: const [true, false, null][intKey % 3],
            isMethod: (intKey & 16) == 16,
            isStatic: (intKey & 32) == 32));
  }
}

/// An interface.
extension type Interface.fromJson(Map<String, Object?> node) {
  static TypedMapSchema schema = TypedMapSchema({
    'members': Type.growableMapPointer,
    'properties': Type.typedMapPointer,
  });

  Interface({
    Map<String, Member>? members,
    Properties? properties,
  }) : this.fromJson(
            runningBuffer!.createTypedMap(schema, members, properties));

  /// Map of members by name.
  Map<String, Member> get members => (node['members'] as Map).cast();

  /// The properties of this interface.
  Properties get properties => node['properties'] as Properties;
}

extension type Member.fromJson(Map<String, Object?> node) {
  static TypedMapSchema schema = TypedMapSchema(
    {'properties': Type.typedMapPointer},
  );

  Member({
    Properties? properties,
  }) : this.fromJson(runningBuffer!.createTypedMap(schema, properties));

  /// The properties of this member.
  Properties get properties => node['properties'] as Properties;
}

/// Set of boolean properties.
extension type Properties.fromJson(Map<String, Object?> node) {
  static TypedMapSchema schema = TypedMapSchema({
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
  }) : this.fromJson(runningBuffer!.createTypedMap(schema, isAbstract, isClass,
            isGetter, isField, isMethod, isStatic));

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
