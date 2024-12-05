// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import 'package:dart_model/src/json_buffer/json_buffer_builder.dart';

import 'serialization_benchmark.dart';

JsonBufferBuilder? runningBuffer;

/// Benchmark accumulating data directly into a [JsonBufferBuilder].
class LazyWrappersBufferWireBenchmark extends SerializationBenchmark {
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
      var interface = Interface(
        properties: Properties(
          isAbstract: (intKey & 1) == 1,
          isClass: (intKey & 2) == 2,
          isGetter: (intKey & 4) == 4,
          isField: (intKey & 8) == 8,
          isMethod: (intKey & 16) == 16,
          isStatic: (intKey & 32) == 32,
        ),
      );
      map[key] = interface.toJson();
      var members = interface.members;
      for (final memberName in makeMemberNames(intKey)) {
        members[memberName] = _makeMember(memberName);
      }
    }

    return buffer.map;
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
  void deserialize() {
    deserialized = _LazyMap<Object?, Interface>(
      JsonBufferBuilder.deserialize(serialized!).map,
      (json) => Interface.fromJson(json as Map<String, Object?>),
      (i) => i.toJson(),
    );
  }
}

class _LazyMap<From, To> extends MapBase<String, To> {
  final Map<String, From> _map;
  final To Function(From) _convertFrom;
  final From Function(To) _convertTo;

  _LazyMap(this._map, this._convertFrom, this._convertTo);

  @override
  To? operator [](Object? key) {
    if (_map[key] case var value?) {
      return _convertFrom(value as From);
    } else {
      return null;
    }
  }

  @override
  void operator []=(String key, To value) {
    _map[key] = _convertTo(value);
  }

  @override
  void clear() {
    _map.clear();
  }

  @override
  Iterable<String> get keys => _map.keys;

  @override
  To? remove(Object? key) {
    if (_map.remove(key) case var value?) {
      return _convertFrom(value);
    } else {
      return null;
    }
  }

  @override
  Iterable<MapEntry<String, To>> get entries =>
      _map.entries.map((e) => MapEntry(e.key, _convertFrom(e.value)));
}

abstract interface class Serializable {
  Map<String, Object?> toJson();
}

/// An interface.
abstract interface class Interface implements Serializable {
  Map<String, Member> get members;
  Properties get properties;

  static TypedMapSchema schema = TypedMapSchema({
    'members': Type.growableMapPointer,
    'properties': Type.typedMapPointer,
  });

  factory Interface({Properties? properties}) => _JsonInterface(
    runningBuffer!.createTypedMap(
      schema,
      runningBuffer!.createGrowableMap<Map<String, Object?>>(),
      properties?.toJson(),
    ),
  );

  factory Interface.fromJson(Map<String, Object?> json) => _JsonInterface(json);
}

/// An [Interface] that lazily reads from a map.
class _JsonInterface implements Interface {
  final Map<String, Object?> json;

  _JsonInterface(this.json);

  /// Map of members by name.
  @override
  Map<String, Member> get members => _LazyMap<Map<String, Object?>, Member>(
    (json['members'] as Map<String, Object?>).cast(),
    Member.fromJson,
    (m) => m.toJson(),
  );

  /// The properties of this interface.
  @override
  Properties get properties =>
      Properties.fromJson(json['properties'] as Map<String, Object?>);

  @override
  Map<String, Object?> toJson() => json;
}

/// A member.
abstract interface class Member implements Serializable {
  Properties get properties;

  static TypedMapSchema schema = TypedMapSchema({
    'properties': Type.typedMapPointer,
  });

  factory Member({Properties? properties}) =>
      _JsonMember(runningBuffer!.createTypedMap(schema, properties?.toJson()));

  factory Member.fromJson(Map<String, Object?> json) => _JsonMember(json);
}

class _JsonMember implements Member {
  final Map<String, Object?> json;

  _JsonMember(this.json);

  /// The properties of this member.
  @override
  Properties get properties =>
      Properties.fromJson(json['properties'] as Map<String, Object?>);

  @override
  Map<String, Object?> toJson() => json;
}

/// Set of boolean properties.
abstract interface class Properties implements Serializable {
  /// Whether the entity is abstract, meaning it has no definition.
  bool get isAbstract;

  /// Whether the entity is a class.
  bool get isClass;

  /// Whether the entity is a getter.
  bool get isGetter;

  /// Whether the entity is a field.
  bool get isField;

  /// Whether the entity is a method.
  bool get isMethod;

  /// Whether the entity is static.
  bool get isStatic;

  static TypedMapSchema schema = TypedMapSchema({
    'isAbstract': Type.boolean,
    'isClass': Type.boolean,
    'isGetter': Type.boolean,
    'isField': Type.boolean,
    'isMethod': Type.boolean,
    'isStatic': Type.boolean,
  });

  factory Properties({
    bool? isAbstract,
    bool? isClass,
    bool? isGetter,
    bool? isField,
    bool? isMethod,
    bool? isStatic,
  }) => _JsonProperties(
    runningBuffer!.createTypedMap(
      schema,
      isAbstract,
      isClass,
      isGetter,
      isField,
      isMethod,
      isStatic,
    ),
  );

  factory Properties.fromJson(Map<String, Object?> json) =>
      _JsonProperties(json);
}

class _JsonProperties implements Properties {
  final Map<String, Object?> json;

  _JsonProperties(this.json);

  /// Whether the entity is abstract, meaning it has no definition.
  @override
  bool get isAbstract => json['isAbstract'] as bool;

  /// Whether the entity is a class.
  @override
  bool get isClass => json['isClass'] as bool;

  /// Whether the entity is a getter.
  @override
  bool get isGetter => json['isGetter'] as bool;

  /// Whether the entity is a field.
  @override
  bool get isField => json['isField'] as bool;

  /// Whether the entity is a method.
  @override
  bool get isMethod => json['isMethod'] as bool;

  /// Whether the entity is static.
  @override
  bool get isStatic => json['isStatic'] as bool;

  @override
  Map<String, Object?> toJson() => json;
}
