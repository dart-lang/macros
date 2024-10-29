// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:dart_model/dart_model.dart';
import 'package:test/test.dart';

void main() {
  group('Model', () {
    late Model model;

    setUp(() {
      Scope.macro.run(() {
        model = Model()
          ..uris['package:dart_model/dart_model.dart'] = (Library()
            ..scopes['JsonData'] = (Interface(
                properties: Properties(isClass: true),
                metadataAnnotations: [
                  MetadataAnnotation(
                      type: QualifiedName(
                          uri: 'package:dart_model/dart_model.dart',
                          name: 'SomeAnnotation'))
                ])
              ..members['_root'] = Member(
                properties: Properties(isField: true, isStatic: false),
                namedParameters: [],
              )));
      });
    });

    final expected = {
      'uris': {
        'package:dart_model/dart_model.dart': {
          'scopes': {
            'JsonData': {
              'metadataAnnotations': [
                {
                  'type': {
                    'uri': 'package:dart_model/dart_model.dart',
                    'name': 'SomeAnnotation'
                  }
                }
              ],
              'members': {
                '_root': {
                  'properties': {'isField': true, 'isStatic': false},
                  'declarationType': 'member',
                  'namedParameters': <Map<String, Object?>>[],
                }
              },
              'properties': {'isClass': true},
              'declarationType': 'interface',
            }
          }
        }
      }
    };

    test('maps to JSON', () {
      expect(model as Map, expected);
    });

    test('maps to JSON after deserialization', () {
      final deserializedModel = Model.fromJson(
          json.decode(json.encode(model as Map)) as Map<String, Object?>);
      expect(deserializedModel as Map, expected);
    });

    test('maps can be accessed as fields', () {
      expect(model.uris['package:dart_model/dart_model.dart'],
          expected['uris']!['package:dart_model/dart_model.dart']);
      expect(
          model.uris['package:dart_model/dart_model.dart']!.scopes['JsonData'],
          expected['uris']!['package:dart_model/dart_model.dart']!['scopes']![
              'JsonData']);
      expect(
          model.uris['package:dart_model/dart_model.dart']!.scopes['JsonData']!
              .properties,
          expected['uris']!['package:dart_model/dart_model.dart']!['scopes']![
              'JsonData']!['properties']);
    });

    test('maps can be accessed as fields after deserialization', () {
      final deserializedModel = Model.fromJson(
          json.decode(json.encode(model as Map)) as Map<String, Object?>);

      expect(
          deserializedModel.uris['package:dart_model/dart_model.dart']!
              .scopes['JsonData']!.properties,
          expected['uris']!['package:dart_model/dart_model.dart']!['scopes']![
              'JsonData']!['properties']);
    });

    test('lists can be accessed as fields', () {
      expect(
          model.uris['package:dart_model/dart_model.dart']!.scopes['JsonData']!
              .members,
          expected['uris']!['package:dart_model/dart_model.dart']!['scopes']![
              'JsonData']!['members']);
    });

    test('lists can be accessed as fields after deserialization', () {
      final deserializedModel = Model.fromJson(
          json.decode(json.encode(model as Map)) as Map<String, Object?>);

      expect(
          deserializedModel.uris['package:dart_model/dart_model.dart']!
              .scopes['JsonData']!.members,
          expected['uris']!['package:dart_model/dart_model.dart']!['scopes']![
              'JsonData']!['members']);
    });

    test('can give the path to Interfaces in buffer backed maps', () {
      final interface =
          model.uris['package:dart_model/dart_model.dart']!.scopes['JsonData']!;
      expect(model.qualifiedNameOf(interface.node)!.asString,
          'package:dart_model/dart_model.dart#JsonData');
    });

    test('can give the path to Members in buffer backed maps', () {
      final member = model.uris['package:dart_model/dart_model.dart']!
          .scopes['JsonData']!.members['_root']!;
      expect(model.qualifiedNameOf(member.node)!.asString,
          'package:dart_model/dart_model.dart#JsonData._root');
    });

    test('can give the path to Interfaces in SDK maps', () {
      final copiedModel = Model.fromJson(_copyMap(model.node));
      final interface = copiedModel
          .uris['package:dart_model/dart_model.dart']!.scopes['JsonData']!;
      expect(copiedModel.qualifiedNameOf(interface.node)!.asString,
          'package:dart_model/dart_model.dart#JsonData');
    });

    test('can give the path to Members in SDK maps', () {
      final copiedModel = Model.fromJson(_copyMap(model.node));
      final member = copiedModel.uris['package:dart_model/dart_model.dart']!
          .scopes['JsonData']!.members['_root']!;
      expect(copiedModel.qualifiedNameOf(member.node)!.asString,
          'package:dart_model/dart_model.dart#JsonData._root');
    });

    test('can give the path to Members in merged maps', () {
      late final Member fooMember;
      late final Model otherModel;

      /// Create one model in a different scope so it gets a different buffer.
      Scope.query.run(() {
        otherModel = Model()
          ..uris['package:dart_model/dart_model.dart'] = (Library()
            ..scopes['JsonData'] = (Interface()
              ..members['foo'] =
                  Member(properties: Properties(isStatic: true))));
        fooMember = otherModel.uris['package:dart_model/dart_model.dart']!
            .scopes['JsonData']!.members['foo']!;
      });

      Scope.macro.run(() {
        final rootMember = model.uris['package:dart_model/dart_model.dart']!
            .scopes['JsonData']!.members['_root']!;

        final mergedModel = model.mergeWith(otherModel);

        expect(mergedModel.qualifiedNameOf(rootMember.node)!.asString,
            'package:dart_model/dart_model.dart#JsonData._root');
        expect(mergedModel.qualifiedNameOf(fooMember.node)!.asString,
            'package:dart_model/dart_model.dart#JsonData::foo');

        expect(model.qualifiedNameOf(fooMember.node), null);
        expect(otherModel.qualifiedNameOf(rootMember.node), null);
      });
    });

    test('path to Members works for cycles', () {
      final copiedModel = Model.fromJson(_copyMap(model.node));
      // Add an invalid link creating a loop in the map structure.
      (copiedModel.node['uris'] as Map<String, Object?>)['loop'] = copiedModel;
      final member = copiedModel.uris['package:dart_model/dart_model.dart']!
          .scopes['JsonData']!.members['_root']!;
      expect(
          copiedModel.qualifiedNameOf(member.node),
          QualifiedName(
            uri: 'package:dart_model/dart_model.dart',
            scope: 'JsonData',
            name: '_root',
            isStatic: false,
          ));
    });

    test('path to Members works for reused node', () {
      final copiedModel = Model.fromJson(_copyMap(model.node));
      // Reuse a node.
      copiedModel.uris['duplicate'] =
          copiedModel.uris['package:dart_model/dart_model.dart']!;
      final member = copiedModel.uris['package:dart_model/dart_model.dart']!
          .scopes['JsonData']!.members['_root']!;
      expect(
          copiedModel.qualifiedNameOf(member.node),
          QualifiedName(
            uri: 'package:dart_model/dart_model.dart',
            scope: 'JsonData',
            name: '_root',
            isStatic: false,
          ));
    });

    test('path to Member returns null for Member in wrong Map', () {
      final copiedModel = Model.fromJson(_copyMap(model.node));
      final member = model.uris['package:dart_model/dart_model.dart']!
          .scopes['JsonData']!.members['_root']!;
      final copiedMember = Member.fromJson(_copyMap(model
          .uris['package:dart_model/dart_model.dart']!
          .scopes['JsonData']!
          .members['_root']!
          .node));
      expect(copiedModel.qualifiedNameOf(member.node), null);
      expect(model.qualifiedNameOf(copiedMember.node), null);
    });

    test('Declaration', () {
      Scope.macro.run(() {
        MacroScope.current.addModel(model);
        final interface = model
            .uris['package:dart_model/dart_model.dart']!.scopes['JsonData']!;
        final member = interface.members['_root']!;

        expect(member.declarationType, DeclarationType.member);
        expect(interface.declarationType, DeclarationType.interface);

        String produceOutput(Declaration declaration) {
          final maybeMember = declaration.maybeMember;
          final maybeInterface = declaration.maybeInterface;
          return [
            'declaration:${declaration.properties.toString()}',
            if (maybeMember != null)
              'member:${maybeMember.namedParameters.toString()}',
            if (maybeInterface != null)
              'interface:${maybeInterface.members.length}',
          ].toString();
        }

        expect(produceOutput(member),
            '[declaration:{isField: true, isStatic: false}, member:[]]');
        expect(produceOutput(interface),
            '[declaration:{isClass: true}, interface:1]');
      });
    });
  });

  group('QualifiedName', () {
    test('asString', () {
      expect(QualifiedName(uri: 'package:foo/foo.dart', name: 'Foo').asString,
          'package:foo/foo.dart#Foo');
      expect(
          QualifiedName(
                  uri: 'package:foo/foo.dart',
                  name: 'bar',
                  scope: 'Foo',
                  isStatic: false)
              .asString,
          'package:foo/foo.dart#Foo.bar');
      expect(
          QualifiedName(
                  uri: 'package:foo/foo.dart',
                  name: 'baz',
                  scope: 'Foo',
                  isStatic: true)
              .asString,
          'package:foo/foo.dart#Foo::baz');
    });

    test('parse', () {
      expect(QualifiedName.parse('package:foo/foo.dart#Foo').uri,
          'package:foo/foo.dart');
      expect(QualifiedName.parse('package:foo/foo.dart#Foo').name, 'Foo');
      final fooBar = QualifiedName.parse('package:foo/foo.dart#Foo.bar');
      expect(fooBar.name, 'bar');
      expect(fooBar.scope, 'Foo');
      expect(fooBar.isStatic, false);
      final fooBaz = QualifiedName.parse('package:foo/foo.dart#Foo::baz');
      expect(fooBaz.name, 'baz');
      expect(fooBaz.scope, 'Foo');
      expect(fooBaz.isStatic, true);
    });
  });
}

Map<String, Object?> _copyMap(Map<String, Object?> map) {
  final result = <String, Object?>{};
  for (final entry in map.entries) {
    if (entry.value is Map<String, Object?>) {
      result[entry.key] = _copyMap(entry.value as Map<String, Object?>);
    } else {
      result[entry.key] = entry.value;
    }
  }
  return result;
}
