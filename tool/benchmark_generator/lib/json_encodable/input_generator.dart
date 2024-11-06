// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:benchmark_generator/workspace.dart';

enum Strategy {
  manual,
  macro,
  none;

  String annotation(String name) {
    switch (this) {
      case Strategy.manual:
      case Strategy.none:
        return '';
      case Strategy.macro:
        return '@m.$name()';
    }
  }
}

class JsonEncodableInputGenerator {
  final int fieldsPerClass;
  final int classesPerLibrary;
  final int librariesPerCycle;
  final Strategy strategy;

  JsonEncodableInputGenerator(
      {required this.fieldsPerClass,
      required this.classesPerLibrary,
      required this.librariesPerCycle,
      required this.strategy});

  void generate(Workspace workspace) {
    for (var i = 0; i != librariesPerCycle; ++i) {
      workspace.write('a$i.dart', source: _generateLibrary(i));
    }
  }

  String _generateLibrary(int index,
      {bool topLevelCacheBuster = false, bool fieldCacheBuster = false}) {
    final buffer = StringBuffer();

    if (strategy == Strategy.macro) {
      buffer.writeln("import 'package:_test_macros/json_codable.dart';");
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

    final result =
        StringBuffer(strategy == Strategy.macro ? '@JsonCodable()' : '');

    result.writeln('class $className {');
    result.writeln('''
  // TODO(davidmorgan): see https://github.com/dart-lang/macros/issues/80.
  external $className.fromJson(Map<String, Object?> json);
  external Map<String, Object?> toJson();''');

    for (var i = 0; i != fieldsPerClass; ++i) {
      result.writeln('int? ${fieldName(i)};');
    }

    if (strategy == Strategy.manual) {
      result.writeln('$className._({');
      for (var i = 0; i != fieldsPerClass; ++i) {
        result.writeln('required this.${fieldName(i)},');
      }
      result.writeln('});');

      result.writeln('Map<String, Object?> toJson() {');
      result.writeln('  final result = <String, Object?>{};');
      for (var i = 0; i != fieldsPerClass; ++i) {
        result.writeln(
            "if (${fieldName(i)} != null) result['${fieldName(i)}'] = ${fieldName(i)};");
      }
      result.writeln('return result;');
      result.writeln('}');
      result
          .writeln('factory $className.fromJson(Map<String, Object?> json) {');
      result.writeln('return $className._(');
      for (var i = 0; i != fieldsPerClass; ++i) {
        result.writeln("${fieldName(i)}: json['${fieldName(i)}'] as int,");
      }
      result.writeln(');');
      result.writeln('}');
    }

    result.writeln('}');
    return result.toString();
  }

  void changeIrrelevantInput(Workspace workspace) {
    workspace.write('a0.dart',
        source: _generateLibrary(0, topLevelCacheBuster: true));
  }

  void changeRevelantInput(Workspace workspace) {
    workspace.write('a0.dart',
        source: _generateLibrary(0, fieldCacheBuster: true));
  }
}
