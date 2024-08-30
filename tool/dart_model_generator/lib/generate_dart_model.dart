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
      throw ArgumentError('No schema declares type: $typeName');
    } else if (schema == currentSchema) {
      // It's in this schema.
      return '#/\$defs/$typeName';
    } else {
      // It needs a reference to the schema filename.
      return 'file:${schema.schemaPath}#/\$defs/$typeName';
    }
  }

  /// Gets the schema that declares [typeName], or `null` if no schema does.
  Schema? lookupDeclaringSchema(String typeName) {
    for (final schema in schemas.schemas) {
      if (schema.hasType(typeName)) {
        return schema;
      }
    }
    return null;
  }

  /// Gets the declaration of the type named [typeName], or throws if it is not
  /// declared in any schema.
  Declaration lookupDeclaration(String typeName) {
    final result = lookupDeclaringSchema(typeName)
        ?.declarations
        .where((d) => d.name == typeName)
        .singleOrNull;
    if (result == null) throw ArgumentError('Unknown type: $typeName');
    return result;
  }

  /// Generates any needed import statements.
  Set<String> generateImports() {
    // Find any types declared in schemas other than the current schema, add
    // imports for them.
    final schemas = {
      for (final typeName in currentSchema.allTypeNames)
        lookupDeclaringSchema(typeName),
    }.nonNulls;
    return {
      '// ignore: implementation_imports',
      for (final schema in schemas)
        if (schema != currentSchema)
          "import 'package:${schema.codePackage}/${schema.codePath}';",
    };
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

  /// The types declared in the schema.
  final List<Declaration> declarations;

  Schema({
    required this.schemaPath,
    required this.codePackage,
    required this.codePath,
    required this.rootTypes,
    required this.declarations,
  });

  /// Whether [typeName] is declared in this schema.
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

/// Declaration of a type.
abstract class Declaration {
  /// The name of the declared type.
  String get name;

  /// Declares a class.
  factory Declaration.clazz(
    String name,
    String description,
    List<Field> properties,
  ) = ClassTypeDeclaration;

  /// Declares a union.
  factory Declaration.union(String name, String description, List<String> types,
      List<Field> fields) = UnionTypeDeclaration;

  /// Declares a named type represented in JSON as a string.
  factory Declaration.stringTypedef(String name, String description) =
      StringTypedefDeclaration;

  /// Declares a named type represented in JSON as `null`.
  factory Declaration.nullTypedef(String name, String description) =
      NullTypedefDeclaration;

  /// Generates JSON schema for this type.
  Map<String, Object?> generateSchema(GenerationContext context);

  /// Generates Dart code for this type.
  String generateCode(GenerationContext context);

  /// The names of all types referenced in this declaration.
  Set<String> get allTypeNames;

  /// The Dart type name of the wire representation of this type.
  String get representationTypeName;
}

/// A field in a declaration.
class Field {
  String name;
  TypeReference type;
  String description;
  bool required;

  /// Field with [name], [type], [description] and optionally [required].
  ///
  /// Pass empty [description] for no description.
  Field(this.name, String type, this.description, {this.required = false})
      : type = TypeReference(type);

  /// Generates JSON schema for this type.
  Map<String, Object?> generateSchema(GenerationContext context) => {
        name: type.generateSchema(context,
            description: description.isEmpty ? null : description),
      };

  /// Dart code for declaring a parameter corresponding to this field.
  String get parameterCode => '${required ? 'required ' : ''}'
      '${type.dartType}${required ? '' : '?'} $name,';

  /// Dart code for passing a named argument corresponding to this field.
  String get namedArgumentCode =>
      "${required ? '' : 'if ($name != null) '}'$name': $name,";

  /// Dart code for a getter for this field.
  String get getterCode {
    if (type.isMap) {
      return _describe(
          "${type.dartType} get $name => (node['$name'] as Map).cast();");
    } else if (type.isList) {
      return _describe(
          "${type.dartType} get $name => (node['$name'] as List).cast();");
    } else {
      return _describe(
          "${type.dartType} get $name => node['$name'] as ${type.dartType};");
    }
  }

  String _describe(String code) =>
      description.isEmpty ? code : '/// $description\n$code';

  /// The names of all types referenced by this field.
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
    // is no such type declared.
    return {
      if (description != null) r'$comment': description,
      r'$ref': context.lookupReferencePath(name),
    };
  }
}

/// Declaration of a class type.
class ClassTypeDeclaration implements Declaration {
  @override
  final String name;
  final String description;
  final List<Field> fields;

  ClassTypeDeclaration(this.name, this.description, this.fields);

  @override
  Map<String, Object?> generateSchema(GenerationContext context) => {
        'type': 'object',
        'description': description,
        'properties': {
          for (final field in fields) ...field.generateSchema(context),
        }
      };

  @override
  String generateCode(GenerationContext context) {
    final result = StringBuffer();

    result.writeln('/// $description');
    result.write('extension type $name.fromJson(Map<String, Object?> node)'
        ' implements Object {');

    // Generate the non-JSON constructor, which accepts an optional value for
    // every field and constructs JSON from it.
    if (fields.isEmpty) {
      result.writeln('  $name() : this.fromJson({});');
    } else {
      result.writeln('  $name({');
      for (final field in fields) {
        result.writeln(field.parameterCode);
      }
      result.writeln('}) : this.fromJson({');
      for (final field in fields) {
        result.writeln(field.namedArgumentCode);
      }
      result.writeln('});');
    }

    for (final field in fields) {
      result.writeln(field.getterCode);
    }
    result.writeln('}');
    return result.toString();
  }

  @override
  Set<String> get allTypeNames => fields.expand((f) => f.allTypeNames).toSet();

  @override
  String get representationTypeName => 'Map<String, Object?>';
}

/// Declaration of a union type.
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
class UnionTypeDeclaration implements Declaration {
  @override
  final String name;
  final String description;
  final List<String> types;
  final List<Field> fields;
  UnionTypeDeclaration(this.name, this.description, this.types, this.fields);

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
          for (final field in fields) ...field.generateSchema(context),
          'required': [
            'type',
            'value',
            ...fields.where((e) => e.required).map((e) => e.name)
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
    for (final type in types) {
      final lowerType = _firstToLowerCase(type);
      result.writeln('static $name $lowerType($type $lowerType');
      if (fields.isNotEmpty) {
        result.writeln(', {');
        for (final field in fields) {
          result.writeln(field.parameterCode);
        }
        result.write('}');
      }
      result
        ..writeln(') =>')
        ..writeln('$name.fromJson({')
        ..writeln("'type': '$type',")
        ..writeln("'value': $lowerType,");
      for (final field in fields) {
        result.writeln(field.namedArgumentCode);
      }
      result.writeln('});');
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
            '${context.lookupDeclaration(type).representationTypeName});')
        ..writeln('}');
    }

    for (final field in fields) {
      result.writeln(field.getterCode);
    }
    result.writeln('}');
    return result.toString();
  }

  @override
  Set<String> get allTypeNames =>
      {...types, ...fields.expand((f) => f.allTypeNames)};

  @override
  String get representationTypeName => 'Map<String, Object?>';
}

/// Declaration of a named type that is actually a String.
class StringTypedefDeclaration implements Declaration {
  @override
  String name;
  String description;
  StringTypedefDeclaration(this.name, this.description);

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

/// Declaration of a named type that is actually a null.
class NullTypedefDeclaration implements Declaration {
  @override
  final String name;
  final String description;

  NullTypedefDeclaration(this.name, this.description);

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
