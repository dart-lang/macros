// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:core' hide Type;
import 'dart:io';

import 'package:dart_style/dart_style.dart';

/// Context for codegen: all the schemas, so types can be looked up.
class GenerationContext {
  /// All schemas.
  final Schemas schemas;

  /// The schema codegen is running for.
  final Schema currentSchema;

  GenerationContext(this.schemas, this.currentSchema);

  /// Gets the path needed for a `"$ref"` JSON schema reference.
  ///
  /// Looks up which schema it's in; if it's not the current schema, returns a
  /// path with the filename.
  String lookupReferencePath(String typeName) {
    final schema = lookupDeclaringSchema(typeName);
    if (schema == null) {
      throw ArgumentError('No schema defines type: $typeName');
    } else if (schema == currentSchema) {
      // It's in this schema.
      return '#/\$defs/$typeName';
    } else {
      // It needs a reference to the schema filename.
      return 'file:${schema.schemaPath}#/\$defs/$typeName';
    }
  }

  /// Gets the schema that defines [typeName], or `null` if no schema does.
  Schema? lookupDeclaringSchema(String typeName) {
    for (final schema in schemas.schemas) {
      if (schema.hasType(typeName)) {
        return schema;
      }
    }
    return null;
  }

  /// Gets the declaration of the type named [typeName], or throws if it is not
  /// defined in any schema.
  Definition lookupDefinition(String typeName) {
    final result = lookupDeclaringSchema(typeName)
        ?.declarations
        .where((d) => d.name == typeName)
        .singleOrNull;
    if (result == null) throw ArgumentError('Unknown type: $typeName');
    return result;
  }

  /// Generates any needed import statements.
  List<String> generateImports() {
    // Find any types defined in schemas other than the current schema, add
    // imports for them.
    final schemas = {
      for (final typeName in currentSchema.allTypeNames)
        lookupDeclaringSchema(typeName),
    }.nonNulls;
    return ([
      "import 'package:dart_model/src/json_buffer/json_buffer_builder.dart';",
      "import 'package:dart_model/src/scopes.dart';",
      for (final schema in schemas)
        if (schema != currentSchema)
          "import 'package:${schema.codePackage}/${schema.codePath}';",
    ].toList()
          ..sort())
        .expand((i) => [
              '// ignore: implementation_imports,'
                  'unused_import,prefer_relative_imports',
              i
            ])
        .toList();
  }
}

/// A codegen result and the path it should be written to.
class GenerationResult {
  final String path;
  final String content;
  GenerationResult({required this.path, required this.content});

  void write() {
    File(path).writeAsStringSync(content);
  }
}

/// A list of definitions of JSON schemas.
class Schemas {
  final List<Schema> schemas;
  Schemas(this.schemas);

  /// Generates JSON schemas and Dart code.
  List<GenerationResult> generate() {
    final result = <GenerationResult>[];
    for (final schema in schemas) {
      final context = GenerationContext(this, schema);
      final generatedSchema = const JsonEncoder.withIndent('  ')
          .convert(schema.generateSchema(context));
      result.add(GenerationResult(
          path: 'schemas/${schema.schemaPath}', content: '$generatedSchema\n'));

      final generatedCode = _format(schema.generateCode(context));
      result.add(GenerationResult(
          path: 'pkgs/${schema.codePackage}/lib/${schema.codePath}',
          content: generatedCode));
    }
    return result;
  }
}

/// Definition of a JSON schema.
class Schema {
  /// The path to write the generated JSON schema to.
  final String schemaPath;

  /// The package to write the generated Dart code to.
  final String codePackage;

  /// The path in [codePackage] to write the generated Dart code to.
  final String codePath;

  /// The top level valid types of the schema.
  final List<String> rootTypes;

  /// The types defined in the schema.
  final List<Definition> declarations;

  Schema({
    required this.schemaPath,
    required this.codePackage,
    required this.codePath,
    required this.rootTypes,
    required this.declarations,
  });

  /// Whether [typeName] is defined in this schema.
  bool hasType(String typeName) => declarations.any((d) => d.name == typeName);

  /// Generates JSON schema corresponding to this schema definition.
  Map<String, Object?> generateSchema(GenerationContext context) => {
        r'$schema': 'https://json-schema.org/draft/2020-12/schema',
        'oneOf': [
          for (var type in rootTypes)
            TypeReference(type).generateSchema(context),
        ],
        r'$defs': {
          for (var declaration in declarations)
            declaration.name: declaration.generateSchema(context),
        }
      };

  /// Generates Dart code corresponding to this schema definition.
  String generateCode(GenerationContext context) {
    final result = StringBuffer('''
// This file is generated. To make changes edit tool/dart_model_generator
// then run from the repo root: dart tool/dart_model_generator/bin/main.dart

''');

    for (final import in context.generateImports()) {
      result.writeln(import);
    }

    for (final declaration in declarations) {
      result.writeln(declaration.generateCode(context));
    }

    return result.toString();
  }

  /// The names of all types referenced in this schema.
  Set<String> get allTypeNames => {
        ...rootTypes,
        for (final declaration in declarations) ...declaration.allTypeNames
      };
}

/// Definition of a type.
abstract class Definition {
  /// The name of the defined type.
  String get name;

  /// Defines a "class".
  ///
  /// Generated as an extension type over `Map<String, Object?>`.
  ///
  /// [createInBuffer] specifies whether the type is written directly to a
  /// buffer when created. If so, it must be created in a `Scope` which will
  /// provide the buffer.
  ///
  /// [extraCode] is arbitrary code to write directly in the extension type.
  /// Needed for static methods and constructors; "instance" methods can be
  /// added as extensions outside the generated code.
  factory Definition.clazz(String name,
      {required String description,
      required List<Property> properties,
      bool createInBuffer,
      String? extraCode}) = ClassTypeDefinition;

  /// Defines a union.
  ///
  /// [createInBuffer] specifies whether the type is written directly to a
  /// buffer when created. If so, it must be created in a `Scope` which will
  /// provide the buffer.
  factory Definition.union(String name,
      {required String description,
      required List<String> types,
      required List<Property> properties,
      bool createInBuffer}) = UnionTypeDefinition;

  /// Defines a named type represented in JSON as a string.
  factory Definition.stringTypedef(String name, {required String description}) =
      StringTypedefDefinition;

  /// Defines a named type represented in JSON as `null`.
  factory Definition.nullTypedef(String name, {required String description}) =
      NullTypedefDefinition;

  /// Generates JSON schema for this type.
  Map<String, Object?> generateSchema(GenerationContext context);

  /// Generates Dart code for this type.
  String generateCode(GenerationContext context);

  /// The names of all types referenced in this declaration.
  Set<String> get allTypeNames;

  /// The Dart type name of the wire representation of this type.
  String get representationTypeName;
}

/// A property in a declaration.
class Property {
  String name;
  TypeReference type;
  String? description;
  bool required;
  bool nullable;

  /// Property with [name], [type], [description] and optionally [required] or
  /// [nullable].
  Property(
    this.name, {
    required String type,
    this.description,
    this.required = false,
    this.nullable = false,
  }) : type = TypeReference(type);

  /// Generates JSON schema for this type.
  Map<String, Object?> generateSchema(GenerationContext context) => {
        name: type.generateSchema(context, description: description),
      };

  /// Dart code for declaring a parameter corresponding to this property.
  String get parameterCode => '${required ? 'required ' : ''}'
      '${_type(nullable: !required)} $name,';

  /// Dart code for passing a named argument corresponding to this property.
  String get namedArgumentCode =>
      "${required ? '' : 'if ($name != null) '}'$name': $name,";

  /// Dart code for a getter for this property.
  String get getterCode {
    final nullAwareCast = nullable ? '?.cast()' : '.cast()';

    if (type.isMap) {
      final representationType = nullable ? 'Map?' : 'Map';
      return _describe('${_type()} get $name => '
          "(node['$name'] as $representationType)$nullAwareCast;");
    } else if (type.isList) {
      final representationType = nullable ? 'List?' : 'List';
      return _describe('${_type()} get $name => '
          "(node['$name'] as $representationType)$nullAwareCast;");
    } else {
      return _describe("${_type()} get $name => node['$name'] as ${_type()};");
    }
  }

  /// Dart code for entry in  `TypedMapSchema`.
  String typedMapSchemaCode(GenerationContext context) {
    return "'$name':${type.typedMapSchemaType(context)},";
  }

  String _describe(String code) =>
      description == null ? code : '/// $description\n$code';

  String _type({bool nullable = false}) {
    return '${type.dartType}${(nullable || this.nullable) ? '?' : ''}';
  }

  /// The names of all types referenced by this property.
  Set<String> get allTypeNames {
    if (type.isMap) return {'Map', type.elementType!};
    if (type.isList) return {'List', type.elementType!};
    return {type.name};
  }
}

/// A reference to a type.
///
/// Either a reference to a user type, which will use `$ref` in the generated
/// schema, or a reference to a built-in type, which can be described directly.
///
/// Collections can use names `List<Foo>` and `Map<Foo>`. The `Map` type only
/// has one parameter because keys are always `String` in JSON.
class TypeReference {
  static final RegExp _simpleRegexp = RegExp(r'^[A-Za-z]+$');
  static final RegExp _mapRegexp = RegExp(r'^Map<([A-Za-z]+)>$');
  static final RegExp _listRegexp = RegExp(r'^List<([A-Za-z]+)>$');

  String name;
  late final bool isMap;
  late final bool isList;
  late final String? elementType;

  TypeReference(this.name) {
    if (_simpleRegexp.hasMatch(name)) {
      isMap = false;
      isList = false;
      elementType = null;
    } else if (_mapRegexp.hasMatch(name)) {
      isMap = true;
      isList = false;
      elementType = _mapRegexp.firstMatch(name)!.group(1);
    } else if (_listRegexp.hasMatch(name)) {
      isMap = false;
      isList = true;
      elementType = _listRegexp.firstMatch(name)!.group(1);
    } else {
      throw ArgumentError('Invalid type name: $name');
    }
  }

  /// The Dart type name of this type.
  String get dartType {
    if (isMap) return 'Map<String, $elementType>';
    return name;
  }

  String typedMapSchemaType(GenerationContext context) {
    if (isMap) {
      return 'Type.growableMapPointer';
    } else if (isList) {
      return 'Type.closedListPointer';
    } else if (name == 'String') {
      return 'Type.stringPointer';
    } else if (name == 'bool') {
      return 'Type.boolean';
    } else if (name == 'int') {
      return 'Type.uint32';
    } else {
      final representationType =
          context.lookupDefinition(name).representationTypeName;
      if (representationType == 'Map<String, Object?>') {
        return 'Type.typedMapPointer';
      } else if (representationType == 'String') {
        return 'Type.stringPointer';
      } else {
        throw UnsupportedError('Representation type: $representationType');
      }
    }
  }

  /// Generates JSON schema for this type.
  Map<String, Object?> generateSchema(GenerationContext context,
      {String? description}) {
    if (isList) {
      return {
        'type': 'array',
        if (description != null) 'description': description,
        'items': TypeReference(elementType!).generateSchema(context),
      };
    } else if (isMap) {
      return {
        'type': 'object',
        if (description != null) 'description': description,
        'additionalProperties':
            TypeReference(elementType!).generateSchema(context),
      };
    } else if (name == 'String') {
      return {
        'type': 'string',
        if (description != null) 'description': description,
      };
    } else if (name == 'bool') {
      return {
        'type': 'boolean',
        if (description != null) 'description': description,
      };
    } else if (name == 'int') {
      return {
        'type': 'integer',
        if (description != null) 'description': description,
      };
    }
    // Not a built-in type, look up a user-defined type. This throws if there
    // is no such type defined.
    return {
      if (description != null) r'$comment': description,
      r'$ref': context.lookupReferencePath(name),
    };
  }
}

/// Definition of a class type.
class ClassTypeDefinition implements Definition {
  @override
  final String name;
  final String description;
  final List<Property> properties;
  final bool createInBuffer;
  final String? extraCode;

  ClassTypeDefinition(this.name,
      {required this.description,
      required this.properties,
      this.createInBuffer = false,
      this.extraCode});

  @override
  Map<String, Object?> generateSchema(GenerationContext context) => {
        'type': 'object',
        'description': description,
        'properties': {
          for (final property in properties)
            ...property.generateSchema(context),
        }
      };

  List<Property> get propertiesExceptMap =>
      properties.where((p) => !p.type.isMap).toList();

  @override
  String generateCode(GenerationContext context) {
    final result = StringBuffer();

    result.writeln('/// $description');
    result.write('extension type $name.fromJson(Map<String, Object?> node)'
        ' implements Object {');

    if (createInBuffer) {
      result.write('static final TypedMapSchema _schema = TypedMapSchema({');
      for (final property in properties) {
        result.write(property.typedMapSchemaCode(context));
      }
      result.write('});');
    }

    // Generate the non-JSON constructor, which accepts an optional value for
    // every property and constructs JSON from it.
    if (propertiesExceptMap.isEmpty) {
      result.writeln('  $name() : ');
    } else {
      result.writeln('  $name({');
      for (final property in propertiesExceptMap) {
        result.writeln(property.parameterCode);
      }
      result.writeln('}) : ');
    }

    result.writeln('this.fromJson(');
    if (createInBuffer) {
      result.writeln('Scope.createMap(_schema,');
      for (final property in properties) {
        if (property.type.isMap) {
          result.writeln('Scope.createGrowableMap(),');
        } else {
          result.writeln('${property.name},');
        }
      }
      result.writeln(')');
    } else {
      result.writeln('{');
      for (final property in properties) {
        if (property.type.isMap) {
          result.writeln('${property.name}: {},');
        } else {
          result.writeln(property.namedArgumentCode);
        }
      }
      result.writeln('}');
    }
    result.writeln(');');

    if (extraCode != null) {
      result.writeln(extraCode);
    }

    for (final property in properties) {
      result.writeln(property.getterCode);
    }
    result.writeln('}');
    return result.toString();
  }

  @override
  Set<String> get allTypeNames =>
      properties.expand((f) => f.allTypeNames).toSet();

  @override
  String get representationTypeName => 'Map<String, Object?>';
}

/// Definition of a union type.
///
/// It has a list of possible actual types, and optionally properties of its
/// own like a class.
///
/// An enum is generated next to it called `${name}Type` with one value for
/// each possible class, plus `unknown`.
///
/// The union type has a `type` getter that returns an instance of this enum,
/// and `asFoo` getters that "cast" to each type.
///
/// On the wire the union type is: `{"type": <name>, "value": <value>}` and
/// may have additional properties as well.
class UnionTypeDefinition implements Definition {
  @override
  final String name;
  final String description;
  final List<String> types;
  final List<Property> properties;
  final bool createInBuffer;
  UnionTypeDefinition(this.name,
      {required this.description,
      required this.types,
      required this.properties,
      this.createInBuffer = false});

  @override
  Map<String, Object?> generateSchema(GenerationContext context) => {
        'type': 'object',
        'description': description,
        'properties': {
          'type': {
            'type': 'string',
          },
          'value': {
            'oneOf': [
              for (final type in types)
                TypeReference(type).generateSchema(context),
            ],
          },
          for (final property in properties)
            ...property.generateSchema(context),
          'required': [
            'type',
            'value',
            ...properties.where((e) => e.required).map((e) => e.name)
          ]..sort(),
        }
      };

  @override
  String generateCode(GenerationContext context) {
    final result = StringBuffer();

    // TODO(davidmorgan): add description(s).
    result
      ..writeln('enum ${name}Type {')
      ..writeln('  // Private so switches must have a default. See `isKnown`.')
      ..writeln('_unknown,')
      ..write(types.map(_firstToLowerCase).join(', '))
      ..writeln(';')
      ..writeln('bool get isKnown => this != _unknown;')
      ..writeln('}');

    // TODO(davidmorgan): add description.
    result.writeln(
        'extension type $name.fromJson(Map<String, Object?> node)  implements '
        'Object {');

    if (createInBuffer) {
      result
        ..writeln('static final TypedMapSchema _schema = TypedMapSchema({')
        ..writeln("'type': Type.stringPointer,")
        ..writeln("'value': Type.anyPointer,");
      for (final property in properties) {
        result.write(property.typedMapSchemaCode(context));
      }
      result.write('});');
    }

    for (final type in types) {
      final lowerType = _firstToLowerCase(type);
      result.writeln('static $name $lowerType($type $lowerType');
      if (properties.isNotEmpty) {
        result.writeln(', {');
        for (final property in properties) {
          result.writeln(property.parameterCode);
        }
        result.write('}');
      }
      result.writeln(') =>');
      if (createInBuffer) {
        result
          ..writeln('$name.fromJson(Scope.createMap(_schema,')
          ..writeln("'$type',")
          ..writeln('$lowerType,');
        for (final property in properties) {
          if (property.type.isMap) {
            result.writeln('Scope.createGrowableMap(),');
          } else {
            result.writeln('${property.name},');
          }
        }
        result.writeln('));');
      } else {
        result
          ..writeln('$name.fromJson({')
          ..writeln("'type': '$type',")
          ..writeln("'value': $lowerType,");
        for (final property in properties) {
          result.writeln(property.namedArgumentCode);
        }
        result.writeln('});');
      }
    }

    result
      ..writeln('${name}Type get type {')
      ..writeln("switch(node['type'] as String) {");
    for (final type in types) {
      final lowerType = _firstToLowerCase(type);
      result.writeln("case '$type': return ${name}Type.$lowerType;");
    }
    result
      ..writeln('default: return ${name}Type._unknown;')
      ..writeln('}')
      ..writeln('}');

    for (final type in types) {
      result
        ..writeln('$type get as$type {')
        ..writeln("if (node['type'] != '$type') "
            "{ throw StateError('Not a $type.'); }")
        ..writeln('return $type.fromJson'
            "(node['value'] as "
            '${context.lookupDefinition(type).representationTypeName});')
        ..writeln('}');
    }

    for (final property in properties) {
      result.writeln(property.getterCode);
    }
    result.writeln('}');
    return result.toString();
  }

  @override
  Set<String> get allTypeNames =>
      {...types, ...properties.expand((f) => f.allTypeNames)};

  @override
  String get representationTypeName => 'Map<String, Object?>';
}

/// Definition of a named type that is actually a String.
class StringTypedefDefinition implements Definition {
  @override
  String name;
  String description;
  StringTypedefDefinition(this.name, {required this.description});

  @override
  Map<String, Object?> generateSchema(GenerationContext context) => {
        'type': 'string',
        'description': description,
      };

  @override
  String generateCode(GenerationContext context) {
    return '/// $description\n'
        'extension type $name.fromJson(String string) implements Object {'
        '$name(String string) : this.fromJson(string);'
        '}';
  }

  @override
  Set<String> get allTypeNames => {'String'};

  @override
  String get representationTypeName => 'String';
}

/// Definition of a named type that is actually a null.
class NullTypedefDefinition implements Definition {
  @override
  final String name;
  final String description;

  NullTypedefDefinition(this.name, {required this.description});

  @override
  Map<String, Object?> generateSchema(GenerationContext context) => {
        'type': 'null',
        'description': description,
      };

  @override
  String generateCode(GenerationContext context) {
    return '/// $description\n'
        'extension type $name.fromJson(Null _) {'
        '$name() : this.fromJson(null);'
        '}';
  }

  @override
  Set<String> get allTypeNames => {'Null'};

  @override
  String get representationTypeName => 'Null';
}

String _firstToLowerCase(String string) =>
    string.substring(0, 1).toLowerCase() + string.substring(1);

String _format(String source) {
  try {
    return DartFormatter().formatSource(SourceCode(source)).text;
  } catch (_) {
    print('Failed to format:\n---\n$source\n---');
    rethrow;
  }
}
