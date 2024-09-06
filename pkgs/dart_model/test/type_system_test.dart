// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';
import 'package:test/test.dart';

void main() {
  late StaticTypeSystem typeSystem;
  Scope.macro.run(() {
    typeSystem = StaticTypeSystem(_model.types);
  });

  InterfaceType interfaceType(String name,
      [List<StaticType> instantiation = const []]) {
    return InterfaceType(
        name: QualifiedName(name), instantiation: instantiation);
  }

  InterfaceType future(StaticType of) {
    return interfaceType('dart:async#Future', [of]);
  }

  const never = NeverType();
  final $null = interfaceType('dart:core#Null');
  final object = interfaceType('dart:core#Object');
  final dartCoreRecord = interfaceType('dart:core#Record');

  group('interface types', () {
    test('are subtypes of themselves', () {
      expect(typeSystem.isSubtype(future(object), future(object)), isTrue);
    });

    test('subtypes through class hierarchy', () {
      expect(
          typeSystem.isSubtype(interfaceType('dart:core#double'),
              interfaceType('dart:core#num')),
          isTrue);
      expect(
          typeSystem.isSubtype(interfaceType('dart:core#double'),
              interfaceType('dart:core#int')),
          isFalse);
    });

    test('subtype check checks generics', () {
      // List<Object> <: Iterable<Object>
      expect(
          typeSystem.isSubtype(interfaceType('dart:core#List', [object]),
              interfaceType('dart:core#Iterable', [object])),
          isTrue);
      // List<int> <: Iterable<num>
      expect(
          typeSystem.isSubtype(
              interfaceType('dart:core#List', [interfaceType('dart:core#int')]),
              interfaceType(
                  'dart:core#Iterable', [interfaceType('dart:core#num')])),
          isTrue);

      // List<int> is not a subtype of Iterable<String>
      expect(
          typeSystem.isSubtype(
              interfaceType('dart:core#List', [interfaceType('dart:core#int')]),
              interfaceType(
                  'dart:core#Iterable', [interfaceType('dart:core#String')])),
          isFalse);
    });
  });

  test('Null is not a subtype of Object', () {
    expect(typeSystem.isSubtype($null, object), isFalse);
  });

  group('records', () {
    test('are subtypes of dart:core#Record', () {
      final recordType = RecordType(positional: [object], named: {});
      expect(typeSystem.isSubtype(recordType, dartCoreRecord), isTrue);
    });
  });

  test('Null? and Null are the same type', () {
    expect(
      typeSystem.areEqual(NullableType($null), $null),
      isTrue,
    );
  });

  test('Never is a subtype of everything', () {
    expect(typeSystem.isSubtype(never, object), isTrue);
    expect(typeSystem.isSubtype(never, NullableType(object)), isTrue);
  });

  test('Never? and Null are the same type', () {
    expect(
      typeSystem.areEqual(const NullableType(never), $null),
      isTrue,
    );
  });
}

TypeHierarchyEntry _entryWithoutTypeArguments(String name,
    [String supertype = 'dart:core#Object']) {
  return TypeHierarchyEntry(
    typeParameters: [],
    supertypes: [
      NamedTypeDesc(
        name: QualifiedName(supertype),
        instantiation: [],
      ),
    ],
    self: NamedTypeDesc(
      name: QualifiedName(name),
      instantiation: [],
    ),
  );
}

final _model = Model(
  types: TypeHierarchy()
    ..named.addAll(
      {
        'dart:core#Object': TypeHierarchyEntry(
          typeParameters: [],
          supertypes: [],
          self: NamedTypeDesc(
            name: QualifiedName('dart:core#Object'),
            instantiation: [],
          ),
        ),
        'dart:core#Null': _entryWithoutTypeArguments('dart:core#Null'),
        'dart:core#Record': _entryWithoutTypeArguments('dart:core#Object'),
        'dart:core#Function': _entryWithoutTypeArguments('dart:core#Function'),
        'dart:core#String': _entryWithoutTypeArguments('dart:core#String'),
        'dart:core#num': _entryWithoutTypeArguments('dart:core#num'),
        'dart:core#int':
            _entryWithoutTypeArguments('dart:core#int', 'dart:core#num'),
        'dart:core#double':
            _entryWithoutTypeArguments('dart:core#double', 'dart:core#num'),
        'dart:core#Iterable': TypeHierarchyEntry(
          typeParameters: [
            StaticTypeParameterDesc(identifier: 0),
          ],
          supertypes: [
            NamedTypeDesc(
              name: QualifiedName('dart:core#Object'),
              instantiation: [],
            ),
          ],
          self: NamedTypeDesc(
            name: QualifiedName('dart:core#Iterable'),
            instantiation: [
              StaticTypeDesc.typeParameterTypeDesc(
                  TypeParameterTypeDesc(parameterId: 0)),
            ],
          ),
        ),
        'dart:core#List': TypeHierarchyEntry(
          typeParameters: [
            StaticTypeParameterDesc(identifier: 1),
          ],
          supertypes: [
            NamedTypeDesc(
              name: QualifiedName('dart:core#Iterable'),
              instantiation: [
                StaticTypeDesc.typeParameterTypeDesc(
                    TypeParameterTypeDesc(parameterId: 1)),
              ],
            ),
          ],
          self: NamedTypeDesc(
            name: QualifiedName('dart:core#List'),
            instantiation: [
              StaticTypeDesc.typeParameterTypeDesc(
                  TypeParameterTypeDesc(parameterId: 1)),
            ],
          ),
        ),
        'dart:async#Future': TypeHierarchyEntry(
          typeParameters: [
            StaticTypeParameterDesc(identifier: 2),
          ],
          supertypes: [
            NamedTypeDesc(
              name: QualifiedName('dart:core#Object'),
              instantiation: [],
            ),
          ],
          self: NamedTypeDesc(
            name: QualifiedName('dart:async#Future'),
            instantiation: [
              StaticTypeDesc.typeParameterTypeDesc(
                  TypeParameterTypeDesc(parameterId: 2)),
            ],
          ),
        ),
      },
    ),
);
