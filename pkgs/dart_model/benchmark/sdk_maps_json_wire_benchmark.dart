// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'serialization_benchmark.dart';

/// Benchmark accumulating data into SDK maps then serializing it to JSON.
class SdkMapsJsonWireBenchmark extends SerializationBenchmark {
  @override
  void run() {
    serialized = json.fuse(utf8).encode(createData()) as Uint8List;
  }

  Map<String, Object?> createData() {
    return Map<String, Object?>.fromIterable(
      mapKeys,
      value: (key) {
        final intKey = int.parse(key as String);
        return Interface(
          members:
              Map<String, Object?>.fromIterable(
                makeMemberNames(intKey),
                value: (k) => _makeMember(k as String),
              ).cast(),
          properties: Properties(
            isAbstract: (intKey & 1) == 1,
            isClass: (intKey & 2) == 2,
            isGetter: (intKey & 4) == 4,
            isField: (intKey & 8) == 8,
            isMethod: (intKey & 16) == 16,
            isStatic: (intKey & 32) == 32,
          ),
        );
      },
    );
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
    deserialized = json.fuse(utf8).decode(serialized!) as Map<String, Object?>;
  }
}

/// An interface.
extension type Interface.fromJson(Map<String, Object?> node) {
  Interface({Map<String, Member>? members, Properties? properties})
    : this.fromJson({
        if (members != null) 'members': members,
        if (properties != null) 'properties': properties,
      });

  /// Map of members by name.
  Map<String, Member> get members => (node['members'] as Map).cast();

  /// The properties of this interface.
  Properties get properties => node['properties'] as Properties;
}

extension type Member.fromJson(Map<String, Object?> node) {
  Member({Properties? properties})
    : this.fromJson({if (properties != null) 'properties': properties});

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
