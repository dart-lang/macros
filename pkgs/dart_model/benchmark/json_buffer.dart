// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:collection/collection.dart';
import 'package:dart_model/src/json_buffer.dart';

Uint8List? serialized0;
Uint8List? serialized;
Uint8List? serialized2;
JsonBuffer? deserialized;
const mapSize = 10000;
final mapKeys = List.generate(mapSize, (i) => i.toString());

void main() {
  JsonBufferSerializeBenchmark0().report();
  JsonBufferSerializeBenchmark0().report();
  JsonBufferSerializeBenchmark0().report();
  print('Size: ${serialized0!.length}');
  JsonBufferSerializeBenchmark().report();
  JsonBufferSerializeBenchmark().report();
  JsonBufferSerializeBenchmark().report();
  print('Size: ${serialized!.length}');
  JsonBufferSerializeBenchmark2().report();
  JsonBufferSerializeBenchmark2().report();
  JsonBufferSerializeBenchmark2().report();
  print('Size: ${serialized2!.length}');

  if (!const DeepCollectionEquality().equals(serialized0, serialized)) {
    print('Error: serialized0 and serialized should be identical!');
  }

  if (!const DeepCollectionEquality().equals(serialized, serialized2)) {
    print('Warning: binary buffers not identical.');
  }
  if (!const DeepCollectionEquality().equals(
      JsonBuffer.deserialize(serialized!).asMap,
      JsonBuffer.deserialize(serialized2!).asMap)) {
    print('Serializer buffers are not equivalent!');
    print(JsonBuffer.deserialize(serialized!).asMap);
    print(JsonBuffer.deserialize(serialized2!).asMap);
  }
  // See note below, this is not measuring anything right now.
  // JsonBufferDeserializeBenchmark().report();
  /*if (deserialized!.asMap.keys.length != mapSize) {
    throw StateError('Benchmark invalid, map was not of expected size');
  }*/
}

class JsonBufferSerializeBenchmark0 extends BenchmarkBase {
  JsonBufferSerializeBenchmark0() : super('JsonBufferSerialize0');

  @override
  void run() {
    serialized0 = JsonBuffer(Map.fromIterable(mapKeys, value: (key) {
      final intKey = int.parse(key as String);
      return Interface.slow(
        members: Map<String, Object?>.fromIterable(
            const ['a', 'aa', 'aaa', 'aaaa'],
            value: (k) => _makeMember(k as String)).cast(),
        properties: Properties.slow(
          isAbstract: (intKey & 1) == 1,
          isClass: (intKey & 2) == 2,
          isGetter: (intKey & 4) == 4,
          isField: (intKey & 8) == 8,
          isMethod: (intKey & 16) == 16,
          isStatic: (intKey & 32) == 32,
        ),
      );
    })).serialize();
  }

  Member _makeMember(String key) {
    final intKey = key.length;
    return Member.slow(
      properties: Properties.slow(
        isAbstract: (intKey & 1) == 1,
        isClass: (intKey & 2) == 2,
        isGetter: (intKey & 4) == 4,
        isField: (intKey & 8) == 8,
        isMethod: (intKey & 16) == 16,
        isStatic: (intKey & 32) == 32,
      ),
    );
  }
}

class JsonBufferSerializeBenchmark extends BenchmarkBase {
  JsonBufferSerializeBenchmark() : super('JsonBufferSerialize');

  @override
  void run() {
    serialized = JsonBuffer(LazyMap(mapKeys, (key) {
      final intKey = int.parse(key);
      return Interface(
        members: LazyMap(const ['a', 'aa', 'aaa', 'aaaa'], _makeMember).cast(),
        properties: Properties(
          isAbstract: (intKey & 1) == 1,
          isClass: (intKey & 2) == 2,
          isGetter: (intKey & 4) == 4,
          isField: (intKey & 8) == 8,
          isMethod: (intKey & 16) == 16,
          isStatic: (intKey & 32) == 32,
        ),
      );
    })).serialize();
  }

  Member _makeMember(String key) {
    final intKey = key.length;
    return Member(
      properties: Properties(
        isAbstract: (intKey & 1) == 1,
        isClass: (intKey & 2) == 2,
        isGetter: (intKey & 4) == 4,
        isField: (intKey & 8) == 8,
        isMethod: (intKey & 16) == 16,
        isStatic: (intKey & 32) == 32,
      ),
    );
  }
}

class JsonBufferSerializeBenchmark2 extends BenchmarkBase {
  JsonBufferSerializeBenchmark2() : super('JsonBufferSerialize2');

  @override
  void run() {
    final buffer = JsonBuffer(LazyMap(mapKeys, (key) {
      final intKey = int.parse(key);
      return InterfaceBuilder()
          .members(
              LazyMap(const ['a', 'aa', 'aaa', 'aaaa'], _makeMember).cast())
          .properties(PropertiesBuilder()
              .isAbstract((intKey & 1) == 1)
              .isClass((intKey & 2) == 2)
              .isGetter((intKey & 4) == 4)
              .isField((intKey & 8) == 8)
              .isMethod((intKey & 16) == 16)
              .isStatic((intKey & 32) == 32)
              .build())
          .build();
    }));

    serialized2 = buffer.serialize();
  }

  Member _makeMember(String key) {
    final intKey = key.length;
    return MemberBuilder()
        .properties(
          PropertiesBuilder()
              .isAbstract((intKey & 1) == 1)
              .isClass((intKey & 2) == 2)
              .isGetter((intKey & 4) == 4)
              .isField((intKey & 8) == 8)
              .isMethod((intKey & 16) == 16)
              .isStatic((intKey & 32) == 32)
              .build(),
        )
        .build();
  }
}

class JsonBufferDeserializeBenchmark extends BenchmarkBase {
  JsonBufferDeserializeBenchmark() : super('JsonBufferDeserialize');

  @override
  void run() {
    // TODO: This is actually a no-op, so the benchmark is kind of pointless.
    // Should we read all the keys/values?
    deserialized = JsonBuffer.deserialize(serialized!);
  }
}

/// An interface.
extension type Interface.fromJson(Map<String, Object?> node) {
  Interface.slow({
    Map<String, Member>? members,
    Properties? properties,
  }) : this.fromJson({
          if (members != null) 'members': members,
          if (properties != null) 'properties': properties,
        });

  Interface({
    Map<String, Member>? members,
    Properties? properties,
  }) : this.fromJson(LazyMap(
            [
              if (members != null) 'members',
              if (properties != null) 'properties',
            ],
            (key) => switch (key) {
                  'members' => members,
                  'properties' => properties,
                  _ => null,
                }));

  /// Map of members by name.
  Map<String, Member> get members => (node['members'] as Map).cast();

  /// The properties of this interface.
  Properties get properties => node['properties'] as Properties;
}

extension type InterfaceBuilder._(JsonBuffer buffer) {
  factory InterfaceBuilder() {
    runningBuffer!.startMap(2);
    return InterfaceBuilder._(runningBuffer!);
  }

  InterfaceBuilder members(Map<String, Member> members) {
    buffer.addToMap('members', members);
    return this;
  }

  InterfaceBuilder properties(Properties properties) {
    buffer.addToMap('properties', properties);
    return this;
  }

  Interface build() => Interface.fromJson(buffer.endMap());
}

extension type Member.fromJson(Map<String, Object?> node) {
  Member.slow({
    Properties? properties,
  }) : this.fromJson({
          if (properties != null) 'properties': properties,
        });

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

extension type MemberBuilder._(JsonBuffer buffer) {
  factory MemberBuilder() {
    runningBuffer!.startMap(1);
    return MemberBuilder._(runningBuffer!);
  }

  MemberBuilder properties(Properties properties) {
    buffer.addToMap('properties', properties);
    return this;
  }

  Member build() => Member.fromJson(buffer.endMap());
}

/// Set of boolean properties.
extension type Properties.fromJson(Map<String, Object?> node) {
  Properties.slow({
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

extension type PropertiesBuilder._(JsonBuffer buffer) {
  factory PropertiesBuilder() {
    runningBuffer!.startMap(6);
    return PropertiesBuilder._(runningBuffer!);
  }

  PropertiesBuilder isAbstract(bool isAbstract) {
    buffer.addToMap('isAbstract', isAbstract);
    return this;
  }

  PropertiesBuilder isClass(bool isClass) {
    buffer.addToMap('isClass', isClass);
    return this;
  }

  PropertiesBuilder isGetter(bool isGetter) {
    buffer.addToMap('isGetter', isGetter);
    return this;
  }

  PropertiesBuilder isField(bool isField) {
    buffer.addToMap('isField', isField);
    return this;
  }

  PropertiesBuilder isMethod(bool isMethod) {
    buffer.addToMap('isMethod', isMethod);
    return this;
  }

  PropertiesBuilder isStatic(bool isStatic) {
    buffer.addToMap('isStatic', isStatic);
    return this;
  }

  Properties build() => Properties.fromJson(buffer.endMap());
}
