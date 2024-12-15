// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_analyzer_cfe_macros/metadata_converter.dart';
import 'package:_fe_analyzer_shared/src/metadata/ast.dart';
import 'package:dart_model/dart_model.dart';
import 'package:test/test.dart';

void main() {
  test('converts with unions', () {
    final invocation = MethodInvocation(
      DoubleLiteral('1.23', 1.23),
      'round',
      [],
      [],
    );

    Scope.query.run(() {
      expect(convert<Object>(invocation), <String, Object?>{
        'receiver': {
          'type': 'DoubleLiteral',
          'value': {'text': '1.23', 'value': 1.23},
        },
        'name': 'round',
        'typeArguments': [],
        'arguments': [],
      });
    });
  });

  test('converts with enums', () {
    final expression = BinaryExpression(
      DoubleLiteral('1.23', 1.23),
      BinaryOperator.minus,
      DoubleLiteral('1.24', 1.24),
    );

    Scope.query.run(() {
      expect(convert<Object>(expression), <String, Object?>{
        'left': {
          'type': 'DoubleLiteral',
          'value': {'text': '1.23', 'value': 1.23},
        },
        'operator': 'minus',
        'right': {
          'type': 'DoubleLiteral',
          'value': {'text': '1.24', 'value': 1.24},
        },
      });
    });
  });

  test('converts with lists', () {
    final invocation = MethodInvocation(
      DoubleLiteral('1.23', 1.23),
      'round',
      [],
      [PositionalArgument(IntegerLiteral.fromText('4'))],
    );

    Scope.query.run(() {
      expect(convert<Object>(invocation), <String, Object?>{
        'receiver': {
          'type': 'DoubleLiteral',
          'value': {'text': '1.23', 'value': 1.23},
        },
        'name': 'round',
        'typeArguments': [],
        'arguments': [
          {
            'type': 'PositionalArgument',
            'value': {
              'expression': {
                'type': 'IntegerLiteral',
                'value': {'text': '4'},
              },
            },
          },
        ],
      });
    });
  });

  test('converts a type literal', () {
    final invocation = TypeLiteral(NamedTypeAnnotation(TestClassReference()));

    Scope.query.run(() {
      expect(convert<Object>(invocation), <String, Object?>{
        'typeAnnotation': {
          'type': 'NamedTypeAnnotation',
          'value': {
            'reference': {
              'type': 'ClassReference',
              'value': {'name': 'Test'},
            },
            'typeArguments': <Object>[],
          },
        },
      });
    });
  });
}

class TestClassReference implements ClassReference {
  @override
  String get name => 'Test';
}
