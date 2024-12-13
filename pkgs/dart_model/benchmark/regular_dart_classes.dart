// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:dart_model/src/json_buffer/json_buffer_builder.dart';

import 'serialization_benchmark.dart';

JsonBufferBuilder? runningBuffer;

/// Benchmark for regular dart classes which serialize and deserializ into
/// a [JsonBufferBuilder].
class RegularClassesBufferWireBenchmark extends SerializationBenchmark {
  @override
  /// Creates the data, but its not ready yet to be serialized.
  Map<String, Interface> createData() {
    final map = <String, Interface>{};

    for (final key in mapKeys) {
      final intKey = int.parse(key);
      var interface = Interface(
        members: {
          for (final memberName in makeMemberNames(intKey))
            memberName: _makeMember(memberName),
        },
        properties: Properties(
          isAbstract: (intKey & 1) == 1,
          isClass: (intKey & 2) == 2,
          isGetter: (intKey & 4) == 4,
          isField: (intKey & 8) == 8,
          isMethod: (intKey & 16) == 16,
          isStatic: (intKey & 32) == 32,
        ),
      );
      map[key] = interface;
    }

    return map;
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
        isStatic: (intKey & 32) == 32,
      ),
    );
  }

  @override
  Map<String, Object?> deserialize(Uint8List serialized) =>
      JsonBufferBuilder.deserialize(serialized).map.map<String, Interface>(
        (k, v) => MapEntry(k, Interface.fromJson(v as Map<String, Object?>)),
      );

  @override
  Uint8List serialize(Map<String, Object?> data) {
    final buffer = runningBuffer = JsonBufferBuilder();
    data.forEach((k, v) => buffer.map[k] = (v as Interface).toJson());
    return runningBuffer!.serialize();
  }
}

abstract interface class Serializable {
  Map<String, Object?> toJson();
}

/// An interface.
class Interface implements Serializable, Hashable {
  final Map<String, Member>? _members;
  Map<String, Member> get members => _members!;

  final Properties? _properties;
  Properties get properties => _properties!;

  static TypedMapSchema schema = TypedMapSchema({
    'members': Type.growableMapPointer,
    'properties': Type.typedMapPointer,
  });

  Interface({Properties? properties, Map<String, Member>? members})
    : _properties = properties,
      _members = members;

  factory Interface.fromJson(Map<String, Object?> json) => Interface(
    properties: Properties.fromJson(json['properties'] as Map<String, Object?>),
    members: (json['members'] as Map<String, Object?>).map(
      (k, v) => MapEntry(k, Member.fromJson(v as Map<String, Object?>)),
    ),
  );

  @override
  Map<String, Object?> toJson() {
    var membersMap = runningBuffer!.createGrowableMap<Map<String, Object?>>();
    _members?.forEach((k, v) => membersMap[k] = v.toJson());
    return runningBuffer!.createTypedMap(
      schema,
      membersMap,
      _properties?.toJson(),
    );
  }

  @override
  int get deepHash {
    var result = 0;
    result ^= 'members'.hashCode;
    _members?.forEach((k, v) {
      result ^= k.hashCode;
      result ^= v.deepHash;
    });
    result ^= 'properties'.hashCode ^ (_properties?.deepHash ?? null.hashCode);
    return result;
  }
}

/// A member.
class Member implements Serializable, Hashable {
  final Properties? _properties;
  Properties get properties => _properties!;

  static TypedMapSchema schema = TypedMapSchema({
    'properties': Type.typedMapPointer,
  });

  Member({Properties? properties}) : _properties = properties;

  factory Member.fromJson(Map<String, Object?> json) => Member(
    properties: Properties.fromJson(json['properties'] as Map<String, Object?>),
  );

  @override
  Map<String, Object?> toJson() =>
      runningBuffer!.createTypedMap(schema, _properties?.toJson());

  @override
  int get deepHash {
    var result = 0;
    result ^= 'properties'.hashCode ^ (_properties?.deepHash ?? null.hashCode);
    return result;
  }
}

/// Set of boolean properties.
class Properties implements Serializable, Hashable {
  /// Whether the entity is abstract, meaning it has no definition.
  final bool? _isAbstract;
  bool get isAbstract => _isAbstract!;

  /// Whether the entity is a class.
  final bool? _isClass;
  bool get isClass => _isClass!;

  /// Whether the entity is a getter.
  final bool? _isGetter;
  bool get isGetter => _isGetter!;

  /// Whether the entity is a field.
  final bool? _isField;
  bool get isField => _isField!;

  /// Whether the entity is a method.
  final bool? _isMethod;
  bool get isMethod => _isMethod!;

  /// Whether the entity is static.
  final bool? _isStatic;
  bool get isStatic => _isStatic!;

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
  }) : _isAbstract = isAbstract,
       _isClass = isClass,
       _isGetter = isGetter,
       _isField = isField,
       _isMethod = isMethod,
       _isStatic = isStatic;

  factory Properties.fromJson(Map<String, Object?> json) => Properties(
    isAbstract: json['isAbstract'] as bool?,
    isClass: json['isClass'] as bool?,
    isGetter: json['isGetter'] as bool?,
    isField: json['isField'] as bool?,
    isMethod: json['isMethod'] as bool?,
    isStatic: json['isStatic'] as bool?,
  );

  @override
  Map<String, Object?> toJson() => runningBuffer!.createTypedMap(
    schema,
    _isAbstract,
    _isClass,
    _isGetter,
    _isField,
    _isMethod,
    _isStatic,
  );

  @override
  int get deepHash {
    var result = 0;
    result ^= 'isAbstract'.hashCode ^ _isAbstract.hashCode;
    result ^= 'isClass'.hashCode ^ _isClass.hashCode;
    result ^= 'isGetter'.hashCode ^ _isGetter.hashCode;
    result ^= 'isField'.hashCode ^ _isField.hashCode;
    result ^= 'isMethod'.hashCode ^ _isMethod.hashCode;
    result ^= 'isStatic'.hashCode ^ _isStatic.hashCode;
    return result;
  }
}
