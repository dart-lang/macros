// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';
import 'package:dart_model/src/lazy_merged_map.dart';
import 'package:test/test.dart' hide test;
import 'package:test/test.dart' as t show test;

void main() {
  test('Can merge models with different libraries', () async {
    final libA = Library();
    final libB = Library();
    final a = Model()..uris['package:a/a.dart'] = libA;
    final b = Model()..uris['package:b/b.dart'] = libB;
    final c = a.mergeWith(b);
    expect(c.uris['package:a/a.dart'], libA);
    expect(c.uris['package:b/b.dart'], libB);
  });

  test('Can merge models with different scopes from the same library',
      () async {
    final interfaceA = Interface();
    final interfaceB = Interface();
    final a = Model()
      ..uris['package:a/a.dart'] = (Library()..scopes['A'] = interfaceA);
    final b = Model()
      ..uris['package:a/a.dart'] = (Library()..scopes['B'] = interfaceB);
    final c = a.mergeWith(b);
    expect(c.uris['package:a/a.dart'], isA<LazyMergedMapView>());
    expect(c.uris['package:a/a.dart']!.scopes['A'], interfaceA);
    expect(c.uris['package:a/a.dart']!.scopes['B'], interfaceB);
  });

  test('Can merge models with the same interface but different properties',
      () async {
    final interfaceA1 = Interface(properties: Properties(isClass: true));
    final interfaceA2 = Interface(properties: Properties(isAbstract: true));
    final a = Model()
      ..uris['package:a/a.dart'] = (Library()..scopes['A'] = interfaceA1);
    final b = Model()
      ..uris['package:a/a.dart'] = (Library()..scopes['A'] = interfaceA2);
    final c = a.mergeWith(b);
    final properties = c.uris['package:a/a.dart']!.scopes['A']!.properties;
    expect(properties, isA<LazyMergedMapView>());
    expect(properties.isClass, true);
    expect(properties.isAbstract, true);
    // Not set
    expect(() => properties.isConstructor, throwsA(isA<TypeError>()));
  });

  test('Errors if maps have same the key with different values', () async {
    final interfaceA1 = Interface(properties: Properties(isClass: true));
    final interfaceA2 = Interface(properties: Properties(isClass: false));
    final a = Model()
      ..uris['package:a/a.dart'] = (Library()..scopes['A'] = interfaceA1);
    final b = Model()
      ..uris['package:a/a.dart'] = (Library()..scopes['A'] = interfaceA2);
    final c = a.mergeWith(b);
    expect(() => c.uris['package:a/a.dart']!.scopes['A']!.properties.isClass,
        throwsA(isA<StateError>()));
  });
}

void test(String description, void Function() body) =>
    t.test(description, () => Scope.query.run(body));
