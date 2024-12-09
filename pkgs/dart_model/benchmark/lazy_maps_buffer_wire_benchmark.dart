// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'json_buffer.dart';
import 'serialization_benchmark.dart';

/// Benchmark accumulating data into a [JsonBuffer] via [LazyMap].
class LazyMapsBufferWireBenchmark extends SerializationBenchmark {
  @override
  Uint8List serialize(Map<String, Object?> data) =>
      JsonBuffer(data).serialize();

  @override
  LazyMap createData() {
    return LazyMap(mapKeys, (key) {
      final intKey = int.parse(key);
      return Interface(
        members: LazyMap(makeMemberNames(intKey), _makeMember).cast(),
        properties: Properties(
          isAbstract: (intKey & 1) == 1,
          isClass: (intKey & 2) == 2,
          isGetter: (intKey & 4) == 4,
          isField: (intKey & 8) == 8,
          isMethod: (intKey & 16) == 16,
          isStatic: (intKey & 32) == 32,
        ),
      );
    });
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
      JsonBuffer.deserialize(serialized).asMap;
}

/// An interface.
extension type Interface.fromJson(Map<String, Object?> node) {
  Interface({Map<String, Member>? members, Properties? properties})
    : this.fromJson(
        LazyMap(
          [
            if (members != null) 'members',
            if (properties != null) 'properties',
          ],
          (key) => switch (key) {
            'members' => members,
            'properties' => properties,
            _ => null,
          },
        ),
      );

  /// Map of members by name.
  Map<String, Member> get members => (node['members'] as Map).cast();

  /// The properties of this interface.
  Properties get properties => node['properties'] as Properties;
}

extension type Member.fromJson(Map<String, Object?> node) {
  Member({Properties? properties})
    : this.fromJson(
        LazyMap(
          [if (properties != null) 'properties'],
          (key) => switch (key) {
            'properties' => properties,
            _ => null,
          },
        ),
      );

  /// The properties of this member.
  Properties get properties => node['properties'] as Properties;
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
  }) : this.fromJson(
         LazyMap(
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
           },
         ),
       );

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
