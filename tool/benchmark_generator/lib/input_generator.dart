// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:benchmark_generator/workspace.dart';
import 'package:dart_model/dart_model.dart';

class ClassesAndFieldsInputGenerator {
  final List<QualifiedName> macros;
  final int fieldsPerClass;
  final int classesPerLibrary;
  final int librariesPerCycle;

  ClassesAndFieldsInputGenerator({
    required this.macros,
    required this.fieldsPerClass,
    required this.classesPerLibrary,
    required this.librariesPerCycle,
  });

  void generate(Workspace workspace) {
    for (var i = 0; i != librariesPerCycle; ++i) {
      workspace.write('a$i.dart', source: _generateLibrary(i));
    }
  }

  String _generateLibrary(int index) {
    final buffer = StringBuffer();

    for (final qualifiedName in macros) {
      buffer.writeln("import '${qualifiedName.uri}';");
    }

    if (librariesPerCycle != 1) {
      final nextLibrary = (index + 1) % librariesPerCycle;
      buffer.writeln('import "a$nextLibrary.dart" as next_in_cycle;');
      buffer.writeln('next_in_cycle.A0? referenceOther;');
    }

    for (var j = 0; j != classesPerLibrary; ++j) {
      buffer.write(_generateClass(index, j));
    }

    return buffer.toString();
  }

  String _generateClass(int libraryIndex, int index) {
    final className = 'A$index';
    String fieldName(int fieldIndex) {
      if (libraryIndex == 0 && index == 0 && fieldIndex == 0) {
        return 'aCACHEBUSTER';
      }
      return 'a$fieldIndex';
    }

    final result = StringBuffer();
    for (final qualifiedName in macros) {
      result.writeln('@${qualifiedName.name}()');
    }

    result.writeln('class $className {');

    if (macros.any(
      (m) => m.asString == 'package:_test_macros/json_codable.dart#JsonCodable',
    )) {
      result.writeln('''
  // TODO(davidmorgan): see https://github.com/dart-lang/macros/issues/80.
  external $className.fromJson(Map<String, Object?> json);
  external Map<String, Object?> toJson();''');
    }

    for (var i = 0; i != fieldsPerClass; ++i) {
      result.writeln('int? ${fieldName(i)};');
    }

    result.writeln('}');
    return result.toString();
  }
}
