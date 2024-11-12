// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';
// ignore: implementation_imports
import 'package:dart_model/src/macro_metadata.g.dart';
import 'package:macro/macro.dart';
import 'package:macro_service/macro_service.dart';

import 'templating.dart';

/// Covers macro metadata cases where the params will always be written as
/// literals in the annotation.
///
/// Outputs comments with evaluation results.
///
/// Throws if the annotation has something other than supported literals.
/// TODO(davidmorgan): support diagnostics, make failures diagnostics.
class LiteralParams {
  final int? anInt;
  final num? aNum;
  final double? aDouble;
  final String? aString;
  final Object? anObject;
  final List<int>? ints;
  final List<num>? nums;
  final List<double>? doubles;
  final List<String>? strings;
  final List<Object>? objects;

  const LiteralParams({
    required this.anInt,
    this.aNum,
    this.aDouble,
    this.aString,
    this.anObject,
    this.ints,
    this.nums,
    this.doubles,
    this.strings,
    this.objects,
  });
}

class LiteralParamsImplementation implements ClassDeclarationsMacro {
  // TODO(davidmorgan): this should be injected by the bootstrap script.
  @override
  MacroDescription get description => MacroDescription(
    annotation: QualifiedName(
      uri: 'package:_test_macros/literal_params.dart',
      name: 'LiteralParams',
    ),
    runsInPhases: [2],
  );

  @override
  Future<void> buildDeclarationsForClass(
    ClassDeclarationsBuilder builder,
  ) async {
    // TODO(davidmorgan): need a way to find the correct annotation, this just
    // uses the first.
    final annotation =
        builder
            .target
            .metadataAnnotations
            .first
            .expression
            .asConstructorInvocation;

    final namedArguments = {
      for (final argument in annotation.arguments)
        if (argument.type == ArgumentType.namedArgument)
          argument.asNamedArgument.name:
              argument.asNamedArgument.expression.evaluate,
    };

    builder.declareInType(
      Augmentation(
        code: expandTemplate(
          [
            for (final entry in namedArguments.entries)
              ' // ${entry.key}: ${entry.value}, ${entry.value.runtimeType}',
          ].join('\n'),
        ),
      ),
    );
  }
}

// TODO(davidmorgan): common code for this in `dart_model` so macros don't
// all have to write expression evaluation code.
extension ExpressionExtension on Expression {
  Object get evaluate => switch (type) {
    ExpressionType.integerLiteral => int.parse(asIntegerLiteral.text),
    ExpressionType.doubleLiteral => double.parse(asDoubleLiteral.text),
    ExpressionType.stringLiteral => asStringLiteral.evaluate,
    ExpressionType.booleanLiteral => bool.parse(asBooleanLiteral.text),
    ExpressionType.listLiteral =>
      asListLiteral.elements.map((e) => e.evaluate).toList(),
    // TODO(davidmorgan): need the type name to do something useful here,
    // for now just return the JSON.
    ExpressionType.constructorInvocation => asConstructorInvocation.toString(),
    // TODO(davidmorgan): need to follow references to do something useful
    // here, for now just return the JSON.
    ExpressionType.staticGet => asStaticGet.toString(),
    _ =>
      throw UnsupportedError(
        'Not supported in @LiteralParams annotation: $this',
      ),
  };
}

extension ElementExtension on Element {
  Object get evaluate => switch (type) {
    ElementType.expressionElement => asExpressionElement.expression.evaluate,
    _ =>
      throw UnsupportedError(
        'Not supported in @LiteralParams annotation: $this',
      ),
  };
}

extension StringLiteralExtension on StringLiteral {
  Object get evaluate {
    if (parts.length != 1) {
      throw UnsupportedError(
        'Not supported in @LiteralParams annotation: $this',
      );
    }
    final part = parts.single;
    return switch (part.type) {
      StringLiteralPartType.stringPart => part.asStringPart.text,
      _ =>
        throw UnsupportedError(
          'Not supported in @LiteralParams annotation: $this',
        ),
    };
  }
}
