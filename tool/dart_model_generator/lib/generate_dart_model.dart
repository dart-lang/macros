// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:json_schema/json_schema.dart';

class DartModelGenerator {
  void run() {
    final result = <String>[];
    final schema = JsonSchema.create(
        File('schemas/dart_model.schema.json').readAsStringSync());
    for (final def in schema.defs.entries) {
      result.add(_generateExtensionType(def.key, def.value));
    }

    File('pkgs/dart_model/lib/src/dart_model.g.dart').writeAsStringSync(
        DartFormatter().formatSource(SourceCode(result.join('\n'))).text);
  }

  String _generateExtensionType(String name, JsonSchema definition) {
    final result = StringBuffer();

    final jsonType = switch (definition.type) {
      SchemaType.object => 'Map<String, Object?> node',
      SchemaType.string => 'String string',
      _ => throw UnsupportedError('Schema type ${definition.type}.'),
    };
    result.writeln('extension type $name.fromJson($jsonType) {');

    final propertyMetadatas = definition.properties.entries
        .map((e) => _readPropertyMetadata(e.key, e.value))
        .toList();
    if (definition.type == SchemaType.object) {
      result.writeln('  $name({');
      for (final property in propertyMetadatas) {
        result.writeln(switch (property.type) {
          PropertyType.object =>
            '${property.elementTypeName}? ${property.name},',
          PropertyType.bool => 'bool? ${property.name},',
          PropertyType.string => 'string? ${property.name},',
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
    } else if (definition.type == SchemaType.string) {
      result.writeln('$name(String string) : this.fromJson(string);');
    }

    for (final property in propertyMetadatas) {
      result.writeln(switch (property.type) {
        PropertyType.object =>
          // TODO(davidmorgan): use the extension type constructor instead of
          // casting.
          '${property.elementTypeName} get ${property.name} => '
              'node[\'${property.name}\']!'
              ' as ${property.elementTypeName};',
        PropertyType.bool => 'bool get ${property.name} => '
            'node[\'${property.name}\']! as bool;',
        PropertyType.string => 'String get ${property.name} => '
            'node[\'${property.name}\']! as String;',
        PropertyType.list =>
          'List<${property.elementTypeName}> get ${property.name} => '
              'node[\'${property.name}\']! '
              'as List<${property.elementTypeName}>;',
        PropertyType.map =>
          'Map<String, ${property.elementTypeName}> get ${property.name} => '
              'node[\'${property.name}\']! '
              'as Map<String, ${property.elementTypeName}>;',
      });
    }
    result.writeln('}');
    return result.toString();
  }

  PropertyMetadata _readPropertyMetadata(String name, JsonSchema schema) {
    if (schema.schemaMap!.containsKey(r'$ref')) {
      final ref = schema.schemaMap![r'$ref']! as String;
      if (ref.startsWith(r'#/$defs/')) {
        final schemaName = ref.substring(r'#/$defs/'.length);
        return PropertyMetadata(
            name: name, type: PropertyType.object, elementTypeName: schemaName);
      } else {
        throw UnsupportedError('Unsupported: $name $schema');
      }
    }

    return switch (schema.type) {
      SchemaType.boolean =>
        PropertyMetadata(name: name, type: PropertyType.bool),
      SchemaType.string =>
        PropertyMetadata(name: name, type: PropertyType.string),
      SchemaType.array => PropertyMetadata(
          name: name,
          type: PropertyType.list,
          elementTypeName: _readRefName(schema, 'items')),
      SchemaType.object => PropertyMetadata(
          name: name,
          type: PropertyType.map,
          elementTypeName: _readRefName(schema, 'additionalProperties')),
      _ => throw UnsupportedError('Unsupported schema type: ${schema.type}'),
    };
  }

  String _readRefName(JsonSchema schema, String key) {
    final ref = schema.schemaMap![key]![r'$ref'];
    return ref.substring(r'#/$defs/'.length);
  }
}

enum PropertyType {
  object,
  bool,
  string,
  list,
  map,
}

class PropertyMetadata {
  String name;
  PropertyType type;
  String? elementTypeName;

  PropertyMetadata(
      {required this.name, required this.type, this.elementTypeName});
}
