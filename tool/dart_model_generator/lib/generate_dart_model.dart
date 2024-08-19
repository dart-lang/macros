// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:json_schema/json_schema.dart';
// ignore: implementation_imports
import 'package:json_schema/src/json_schema/models/ref_provider.dart';

/// Generates `pkgs/dart_model/lib/src/dart_model.g.dart` from
/// `schemas/dart_model.schema.json`, and similarly for `macro_service`.
///
/// Generated types are extension types with JSON maps as the underlying data.
/// They have a `fromJson` constructor that takes that JSON, and a no-name
/// constructor that builds it.
void run() {
  File('pkgs/dart_model/lib/src/dart_model.g.dart').writeAsStringSync(
      generate(File('schemas/dart_model.schema.json').readAsStringSync()));
  File('pkgs/macro_service/lib/src/macro_service.g.dart').writeAsStringSync(
      generate(File('schemas/macro_service.schema.json').readAsStringSync(),
          importDartModel: true));
}

/// Generates and returns code for [schemaJson].
String generate(String schemaJson,
    {bool importDartModel = false,
    bool importMacroService = false,
    String? dartModelJson}) {
  final result = <String>[
    '// This file is generated. To make changes edit schemas/*.schema.json',
    '// then run from the repo root: '
        'dart tool/dart_model_generator/bin/main.dart',
    '',
    if (importDartModel) "import 'package:dart_model/dart_model.dart';",
  ];
  final schema = JsonSchema.create(schemaJson,
      refProvider: LocalRefProvider(dartModelJson ??
          File('schemas/dart_model.schema.json').readAsStringSync()));
  final allDefinitions = <String, JsonSchema>{
    for (final def in schema.defs.entries) def.key: def.value,
  };

  for (final MapEntry(:key, :value) in allDefinitions.entries) {
    if (_isUnion(value)) {
      result.add(_generateUnion(
        key,
        value,
        allDefinitions: allDefinitions,
      ));
    } else {
      result.add(_generateExtensionType(key, value));
    }
  }
  return DartFormatter().formatSource(SourceCode(result.join('\n'))).text;
}

/// The Dart type used to represent the JSON value for [definition].
///
/// This is most commonly a `Map<String, Object?>`, but can also be a JSON
/// primitive type for simpler definitions.
String _dartJsonType(JsonSchema definition) {
  return switch (definition.type) {
    SchemaType.object => 'Map<String, Object?>',
    SchemaType.string => 'String',
    SchemaType.nullValue => 'Null',
    _ => throw UnsupportedError('Unsupported type: ${definition.type}'),
  };
}

String _generateExtensionType(String name, JsonSchema definition) {
  final result = StringBuffer();

  // Generate the extension type header with `fromJson` constructor and the
  // appropriate underlying type.
  final jsonType = switch (definition.type) {
    SchemaType.object => 'Map<String, Object?> node',
    SchemaType.string => 'String string',
    SchemaType.nullValue => 'Null _',
    _ => throw UnsupportedError('Schema type ${definition.type}.'),
  };
  if (definition.description != null) {
    result.writeln('/// ${definition.description}');
  }
  result.write('extension type $name.fromJson($jsonType)');
  if (definition.type != SchemaType.nullValue) {
    result.write(' implements Object');
  }
  result.writeln(' {');

  // Generate the non-JSON constructor, which accepts an optional value for
  // every field and constructs JSON from it.
  final propertyMetadatas = [
    for (var e in definition.properties.entries)
      _readPropertyMetadata(e.key, e.value)
  ];
  switch (definition.type) {
    case SchemaType.object:
      if (propertyMetadatas.isEmpty) {
        result.writeln('  $name() : this.fromJson({});');
      } else {
        result.writeln('  $name({');
        for (final property in propertyMetadatas) {
          result.writeParameter(property, definition);
        }
        result.writeln('}) : this.fromJson({');
        for (final property in propertyMetadatas) {
          result.writeMapElement(property, definition);
        }
        result.writeln('});');
      }
    case SchemaType.string:
      result.writeln('$name(String string) : this.fromJson(string);');
    case SchemaType.nullValue:
      result.writeln('$name(): this.fromJson(null);');
    default:
      throw UnsupportedError('Unsupported type: ${definition.type}');
  }

  for (final property in propertyMetadatas) {
    result.writePropertyGetter(property);
  }
  result.writeln('}');
  return result.toString();
}

/// Whether [schema] represents a union type.
///
/// To be a union type it must have exactly two properties, "type" and "value",
/// where "type" is a "string" and "value" is a "oneOf".
bool _isUnion(JsonSchema schema) =>
    schema.properties['type']?.schemaMap!['type'] == 'string' &&
    schema.properties['value']?.oneOf != null;

/// Generates a type called [name] that is a union of the specified `oneOf`
/// types, which must all be `$ref`s to class definitions.
///
/// An enum is generated next to it called `${name}Type` with one value for
/// each possible class, plus `unknown`.
///
/// The union type has a `type` getter that returns an instance of this enum,
/// and `asFoo` getters that "cast" to each type.
///
/// On the wire the union type is: `{"type": <name>, "value": <value>}` and
/// may have additional properties as well.
String _generateUnion(
  String name,
  JsonSchema definition, {
  required Map<String, JsonSchema> allDefinitions,
}) {
  final oneOf = definition.properties['value']!.oneOf;
  final result = StringBuffer();
  final unionEntries = oneOf
      .map((s) => _refName(s.schemaMap![r'$ref'] as String))
      .map((name) => (name, allDefinitions[name]!));

  // TODO(davidmorgan): add description(s).
  result
    ..writeln('enum ${name}Type {')
    ..writeln('  // Private so switches must have a default. See `isKnown`.')
    ..writeln('_unknown,')
    ..write(unionEntries.map((e) => _firstToLowerCase(e.$1)).join(', '))
    ..writeln(';')
    ..writeln('bool get isKnown => this != _unknown;')
    ..writeln('}');

  final extraPropertyMetadatas = [
    for (var MapEntry(:key, :value) in definition.properties.entries)
      // These are handled specially for union types.
      if (key != 'type' && key != 'value') _readPropertyMetadata(key, value)
  ];

  // TODO(davidmorgan): add description.
  result.writeln(
      'extension type $name.fromJson(Map<String, Object?> node)  implements '
      'Object {');
  for (final (type, _) in unionEntries) {
    final lowerType = _firstToLowerCase(type);
    result.writeln('static $name $lowerType($type $lowerType');
    if (extraPropertyMetadatas.isNotEmpty) {
      result.writeln(', {');
      for (final property in extraPropertyMetadatas) {
        result.writeParameter(property, definition);
      }
      result.write('}');
    }
    result
      ..writeln(') =>')
      ..writeln('$name.fromJson({')
      ..writeln("'type': '$type',")
      ..writeln("'value': $lowerType,");
    for (final property in extraPropertyMetadatas) {
      result.writeMapElement(property, definition);
    }
    result.writeln('});');
  }

  result
    ..writeln('${name}Type get type {')
    ..writeln("switch(node['type'] as String) {");
  for (final (type, _) in unionEntries) {
    final lowerType = _firstToLowerCase(type);
    result.writeln("case '$type': return ${name}Type.$lowerType;");
  }
  result
    ..writeln('default: return ${name}Type._unknown;')
    ..writeln('}')
    ..writeln('}');

  for (final (type, schema) in unionEntries) {
    result
      ..writeln('$type get as$type {')
      ..writeln("if (node['type'] != '$type') "
          "{ throw StateError('Not a $type.'); }")
      ..writeln(
          "return $type.fromJson(node['value'] as ${_dartJsonType(schema)});")
      ..writeln('}');
  }

  for (final property in extraPropertyMetadatas) {
    result.writePropertyGetter(property);
  }

  result.writeln('}');

  return result.toString();
}

String _firstToLowerCase(String string) =>
    string.substring(0, 1).toLowerCase() + string.substring(1);

/// Gets information about an extension type property from [schema].
PropertyMetadata _readPropertyMetadata(String name, JsonSchema schema) {
  // Check for a `$ref` to another extension type defined under `$defs`.
  if (schema.schemaMap!.containsKey(r'$ref')) {
    final ref = schema.schemaMap![r'$ref'] as String;
    if (ref.contains(r'#/$defs/')) {
      final schemaName = _refName(ref);
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
    SchemaType.integer => PropertyMetadata(
        description: schema.description,
        name: name,
        type: PropertyType.integer),
    SchemaType.array => PropertyMetadata(
        description: schema.description,
        name: name,
        type: PropertyType.list,
        elementTypeName: _readRefNameOrType(schema, 'items')),
    SchemaType.object => PropertyMetadata(
        description: schema.description,
        name: name,
        type: PropertyType.map,
        // `additionalProperties` should be a type specified with a `$ref`.
        elementTypeName: _readRefNameOrType(schema, 'additionalProperties')),
    _ => throw UnsupportedError('Unsupported schema type: ${schema.type}'),
  };
}

/// Reads the type name of a `$ref` to a `$def`.
///
/// If it's not there, falls back to `type` mapped to a Dart type name.
String _readRefNameOrType(JsonSchema schema, String key) {
  final typeSchema = schema.schemaMap![key] as Map;
  final ref = typeSchema[r'$ref'] as String?;
  if (ref != null) {
    return _refName(ref);
  } else {
    final type = typeSchema['type'] as String;
    switch (type) {
      case 'integer':
        return 'int';
      default:
        throw UnsupportedError(type);
    }
  }
}

/// Returns the type name from a reference to a type under `$defs`.
String _refName(String ref) =>
    ref.substring(ref.indexOf(r'#/$defs/') + r'#/$defs/'.length);

/// The Dart types used in extension types to model JSON types.
enum PropertyType {
  object,
  bool,
  string,
  integer,
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

/// Loads referenced schemas.
///
/// No need to connect to servers like the default implementation, just return
/// the one file we know we need.
class LocalRefProvider implements RefProvider<SyncJsonProvider> {
  final String dartModelJson;

  LocalRefProvider(this.dartModelJson);

  @override
  bool get isSync => true;

  @override
  SyncJsonProvider get provide => (String path) {
        if (path != 'file:///dart_model.schema.json') {
          throw UnsupportedError(
              'This provider only loads file:///dart_model.schema.json!'
              ' Got: $path');
        }
        return json.decode(dartModelJson) as Map<String, Object?>;
      };
}

extension on StringBuffer {
  void writeType(PropertyMetadata property, {bool nullable = false}) {
    write(switch (property.type) {
      PropertyType.object => property.elementTypeName,
      PropertyType.bool => 'bool',
      PropertyType.string => 'String',
      PropertyType.integer => 'int',
      PropertyType.list => 'List<${property.elementTypeName}>',
      PropertyType.map => 'Map<String, ${property.elementTypeName}>',
    });
    if (nullable) write('?');
  }

  /// Writes a map element for [property], assuming there is a variable in
  /// scope with the same name (usually, a function parameter).
  ///
  /// If the property is not required, the element will be omitted if the
  /// variable is null.
  void writeMapElement(PropertyMetadata property, JsonSchema schema) {
    if (!schema.propertyRequired(property.name)) {
      write('if (${property.name} != null) ');
    }
    writeln("'${property.name}': ${property.name},");
  }

  /// Writes a named function parameter for [property].
  ///
  /// If the property is required, it will be non-nullable and marked as
  /// `required`, otherwise it will be nullable and optional.
  void writeParameter(PropertyMetadata property, JsonSchema schema) {
    var required = schema.propertyRequired(property.name);
    if (required) write('required ');
    writeType(property, nullable: !required);
    writeln(' ${property.name},');
  }

  /// Writes a getter for [property] that looks up in the JSON and "creates"
  /// extension types or casts collections as needed. The getters assume the
  /// data is present and will throw if it's not, and return types are always
  /// non-nullable.
  void writePropertyGetter(PropertyMetadata property) {
    if (property.description != null) {
      writeln('/// ${property.description}');
    }
    writeType(property);
    write(' get ${property.name} => ');
    switch (property.type) {
      case PropertyType.object ||
            PropertyType.bool ||
            PropertyType.string ||
            PropertyType.integer:
        write("node['${property.name}'] as ");
        writeType(property);
      case PropertyType.list:
        write("(node['${property.name}'] as List).cast()");
      case PropertyType.map:
        write("(node['${property.name}'] as Map).cast()");
    }
    writeln(';');
  }
}
