// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:json_schema/json_schema.dart';

/// Generates `pkgs/dart_model/lib/src/dart_model.g.dart` from
/// `schemas/dart_model.schema.json`.
///
/// Generated types are extension types with JSON maps as the underlying data.
/// They have a `fromJson` constructor that takes that JSON, and a no-name
/// constructor that builds it.
void run() {
  File('pkgs/dart_model/lib/src/dart_model.g.dart').writeAsStringSync(
      generate(File('schemas/dart_model.schema.json').readAsStringSync()));
}

/// Generates and returns code for [schemaJson].
String generate(String schemaJson) {
  final result = <String>[
    '// This file is generated. To make changes, '
        'edit schemas/dart_model.schema.json',
    '// then run from the repo root: '
        'dart tool/model_generator/bin/main.dart',
    '',
  ];
  final schema = JsonSchema.create(schemaJson);
  for (final def in schema.defs.entries) {
    result.add(_generateExtensionType(def.key, def.value));
  }
  return DartFormatter().formatSource(SourceCode(result.join('\n'))).text;
}

String _generateExtensionType(String name, JsonSchema definition) {
  final result = StringBuffer();

  // Generate the extension type header with `fromJson` constructor and the
  // appropriate underlying type.
  final jsonType = switch (definition.type) {
    SchemaType.object => 'Map<String, Object?> node',
    SchemaType.string => 'String string',
    _ => throw UnsupportedError('Schema type ${definition.type}.'),
  };
  if (definition.description != null) {
    result.writeln('/// ${definition.description}');
  }
  result.writeln('extension type $name.fromJson($jsonType) {');

  // Generate the non-JSON constructor, which accepts an optional value for
  // every field and constructs JSON from it.
  final propertyMetadatas = [
    for (var e in definition.properties.entries)
      _readPropertyMetadata(e.key, e.value)
  ];
  switch (definition.type) {
    case SchemaType.object:
      result.writeln('  $name({');
      for (final property in propertyMetadatas) {
        result.writeln(switch (property.type) {
          PropertyType.object =>
            '${property.elementTypeName}? ${property.name},',
          PropertyType.bool => 'bool? ${property.name},',
          PropertyType.string => 'String? ${property.name},',
          PropertyType.list =>
            'List<${property.elementTypeName}>? ${property.name},',
          PropertyType.map =>
            'Map<String, ${property.elementTypeName}>? ${property.name},',
        });
      }
      result.writeln('}) : this.fromJson({');
      for (final property in propertyMetadatas) {
        result.writeln('if (${property.name} != null) '
            "'${property.name}': ${property.name},");
      }
      result.writeln('});');
    case SchemaType.string:
      result.writeln('$name(String string) : this.fromJson(string);');
    default:
      throw UnsupportedError('Unsupported type: ${definition.type}');
  }

  // Generate a getter for every field that looks up in the JSON and "creates"
  // extension types or casts collections as needed. The getters assume the
  // data is present and will throw if it's not.
  for (final property in propertyMetadatas) {
    if (property.description != null) {
      result.writeln('/// ${property.description}');
    }
    result.writeln(switch (property.type) {
      PropertyType.object =>
        // TODO(davidmorgan): use the extension type constructor instead of
        // casting.
        '${property.elementTypeName} get ${property.name} => '
            'node[\'${property.name}\'] '
            'as ${property.elementTypeName};',
      PropertyType.bool => 'bool get ${property.name} => '
          'node[\'${property.name}\'] as bool;',
      PropertyType.string => 'String get ${property.name} => '
          'node[\'${property.name}\'] as String;',
      PropertyType.list =>
        'List<${property.elementTypeName}> get ${property.name} => '
            '(node[\'${property.name}\'] as List).cast();',
      PropertyType.map =>
        'Map<String, ${property.elementTypeName}> get ${property.name} => '
            '(node[\'${property.name}\'] as Map).cast();',
    });
  }
  result.writeln('}');
  return result.toString();
}

/// Gets information about an extension type property from [schema].
PropertyMetadata _readPropertyMetadata(String name, JsonSchema schema) {
  // Check for a `$ref` to another extension type defined under `$defs`.
  if (schema.schemaMap!.containsKey(r'$ref')) {
    final ref = schema.schemaMap![r'$ref'] as String;
    if (ref.startsWith(r'#/$defs/')) {
      final schemaName = ref.substring(r'#/$defs/'.length);
      return PropertyMetadata(
          // The "description" comes from the ref'd schema. But, we want to
          // describe the property, not the type of the property. It's possible
          // to use `allOf` to specify a second schema with a second
          // `description`, but for simplicity use `$comment` which is just
          // ignored by standard tooling.
          description: schema.schemaMap![r'$comment'] as String?,
          name: name,
          type: PropertyType.object,
          elementTypeName: schemaName);
    } else {
      throw UnsupportedError('Unsupported: $name $schema');
    }
  }

  // Otherwise, it's a schema with a type.
  return switch (schema.type) {
    SchemaType.boolean => PropertyMetadata(
        description: schema.description, name: name, type: PropertyType.bool),
    SchemaType.string => PropertyMetadata(
        description: schema.description, name: name, type: PropertyType.string),
    SchemaType.array => PropertyMetadata(
        description: schema.description,
        name: name,
        type: PropertyType.list,
        // `items` should be a type specified with a `$ref`.
        elementTypeName: _readRefName(schema, 'items')),
    SchemaType.object => PropertyMetadata(
        description: schema.description,
        name: name,
        type: PropertyType.map,
        // `additionalProperties` should be a type specified with a `$ref`.
        elementTypeName: _readRefName(schema, 'additionalProperties')),
    _ => throw UnsupportedError('Unsupported schema type: ${schema.type}'),
  };
}

/// Reads the type name of a `$ref` to a `$def`.
String _readRefName(JsonSchema schema, String key) {
  final ref = (schema.schemaMap![key] as Map)[r'$ref'] as String;
  return ref.substring(r'#/$defs/'.length);
}

/// The Dart types used in extension types to model JSON types.
enum PropertyType {
  object,
  bool,
  string,
  list,
  map,
}

/// Metadata about a property in an extension type.
class PropertyMetadata {
  String? description;
  String name;
  PropertyType type;
  String? elementTypeName;

  PropertyMetadata(
      {this.description,
      required this.name,
      required this.type,
      this.elementTypeName});
}
