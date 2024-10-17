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
                properties: Properties(isField: true),
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
                  'properties': {'isField': true}
                }
              },
              'properties': {'isClass': true}
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

    test('can give the path to Members in buffer backed maps', () {
      final member = model.uris['package:dart_model/dart_model.dart']!
          .scopes['JsonData']!.members['_root']!;
      expect(model.qualifiedNameOfMember(member)!.asString,
          'package:dart_model/dart_model.dart#JsonData');
    });

    test('can give the path to Members in SDK maps', () {
      final copiedModel = Model.fromJson(_copyMap(model.node));
      final member = copiedModel.uris['package:dart_model/dart_model.dart']!
          .scopes['JsonData']!.members['_root']!;
      expect(copiedModel.qualifiedNameOfMember(member)!.asString,
          'package:dart_model/dart_model.dart#JsonData');
    });

    test('can give the path to Members in merged maps', () {
      Scope.macro.run(() {
        final rootMember = model.uris['package:dart_model/dart_model.dart']!
            .scopes['JsonData']!.members['_root']!;

        final fooMember = Member();
        final otherModel = Model()
          ..uris['package:dart_model/dart_model.dart'] = (Library()
            ..scopes['JsonData'] = (Interface()..members['foo'] = fooMember));
        final mergedModel = model.mergeWith(otherModel);

        // TODO: Once QualifiedName works better, this will be a better test.
        expect(mergedModel.qualifiedNameOfMember(rootMember)!.asString,
            'package:dart_model/dart_model.dart#JsonData');
        expect(mergedModel.qualifiedNameOfMember(fooMember)!.asString,
            'package:dart_model/dart_model.dart#JsonData');

        expect(model.qualifiedNameOfMember(fooMember), null);
        expect(otherModel.qualifiedNameOfMember(rootMember), null);
      });
    });

    test('path to Members throws on cycle', () {
      final copiedModel = Model.fromJson(_copyMap(model.node));
      // Add an invalid link creating a loop in the map structure.
      (copiedModel.node['uris'] as Map<String, Object?>)['loop'] = copiedModel;
      final member = copiedModel.uris['package:dart_model/dart_model.dart']!
          .scopes['JsonData']!.members['_root']!;
      expect(() => copiedModel.qualifiedNameOfMember(member), throwsStateError);
    });

    test('path to Members throws on reused node', () {
      final copiedModel = Model.fromJson(_copyMap(model.node));
      // Reuse a node.
      copiedModel.uris['duplicate'] =
          copiedModel.uris['package:dart_model/dart_model.dart']!;
      final member = copiedModel.uris['package:dart_model/dart_model.dart']!
          .scopes['JsonData']!.members['_root']!;
      expect(() => copiedModel.qualifiedNameOfMember(member), throwsStateError);
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
      expect(copiedModel.qualifiedNameOfMember(member), null);
      expect(model.qualifiedNameOfMember(copiedMember), null);
    });
  });

  group(QualifiedName, () {
    test('asString', () {
      expect(QualifiedName(uri: 'package:foo/foo.dart', name: 'Foo').asString,
          'package:foo/foo.dart#Foo');
    });

    test('parse', () {
      expect(QualifiedName.parse('package:foo/foo.dart#Foo').uri,
          'package:foo/foo.dart');
      expect(QualifiedName.parse('package:foo/foo.dart#Foo').name, 'Foo');
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
