// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: implementation_imports, unused_local_variable
import 'package:_fe_analyzer_shared/src/metadata/ast.dart' as front_end;
import 'package:dart_model/src/macro_metadata.g.dart' as dart_model;

// This code is generated and experimental, talk to davidmorgan@ before making
// any manual changes.
// TODO(davidmorgan): determine how this will be maintained.

dart_model.Argument? convertToArgument(Object? object) => switch (object) {
  front_end.PositionalArgument o => dart_model.Argument.positionalArgument(
    convert<dart_model.PositionalArgument>(o)!,
  ),
  front_end.NamedArgument o => dart_model.Argument.namedArgument(
    convert<dart_model.NamedArgument>(o)!,
  ),
  null => null,
  _ => throw ArgumentError(object),
};
dart_model.Element? convertToElement(Object? object) => switch (object) {
  front_end.ExpressionElement o => dart_model.Element.expressionElement(
    convert<dart_model.ExpressionElement>(o)!,
  ),
  front_end.MapEntryElement o => dart_model.Element.mapEntryElement(
    convert<dart_model.MapEntryElement>(o)!,
  ),
  front_end.SpreadElement o => dart_model.Element.spreadElement(
    convert<dart_model.SpreadElement>(o)!,
  ),
  front_end.IfElement o => dart_model.Element.ifElement(
    convert<dart_model.IfElement>(o)!,
  ),
  null => null,
  _ => throw ArgumentError(object),
};
dart_model.Expression? convertToExpression(Object? object) => switch (object) {
  front_end.InvalidExpression o => dart_model.Expression.invalidExpression(
    convert<dart_model.InvalidExpression>(o)!,
  ),
  front_end.StaticGet o => dart_model.Expression.staticGet(
    convert<dart_model.StaticGet>(o)!,
  ),
  front_end.FunctionTearOff o => dart_model.Expression.functionTearOff(
    convert<dart_model.FunctionTearOff>(o)!,
  ),
  front_end.ConstructorTearOff o => dart_model.Expression.constructorTearOff(
    convert<dart_model.ConstructorTearOff>(o)!,
  ),
  front_end.ConstructorInvocation o => dart_model
      .Expression.constructorInvocation(
    convert<dart_model.ConstructorInvocation>(o)!,
  ),
  front_end.IntegerLiteral o => dart_model.Expression.integerLiteral(
    convert<dart_model.IntegerLiteral>(o)!,
  ),
  front_end.DoubleLiteral o => dart_model.Expression.doubleLiteral(
    convert<dart_model.DoubleLiteral>(o)!,
  ),
  front_end.BooleanLiteral o => dart_model.Expression.booleanLiteral(
    convert<dart_model.BooleanLiteral>(o)!,
  ),
  front_end.NullLiteral o => dart_model.Expression.nullLiteral(
    convert<dart_model.NullLiteral>(o)!,
  ),
  front_end.SymbolLiteral o => dart_model.Expression.symbolLiteral(
    convert<dart_model.SymbolLiteral>(o)!,
  ),
  front_end.StringLiteral o => dart_model.Expression.stringLiteral(
    convert<dart_model.StringLiteral>(o)!,
  ),
  front_end.AdjacentStringLiterals o => dart_model
      .Expression.adjacentStringLiterals(
    convert<dart_model.AdjacentStringLiterals>(o)!,
  ),
  front_end.ImplicitInvocation o => dart_model.Expression.implicitInvocation(
    convert<dart_model.ImplicitInvocation>(o)!,
  ),
  front_end.StaticInvocation o => dart_model.Expression.staticInvocation(
    convert<dart_model.StaticInvocation>(o)!,
  ),
  front_end.Instantiation o => dart_model.Expression.instantiation(
    convert<dart_model.Instantiation>(o)!,
  ),
  front_end.MethodInvocation o => dart_model.Expression.methodInvocation(
    convert<dart_model.MethodInvocation>(o)!,
  ),
  front_end.PropertyGet o => dart_model.Expression.propertyGet(
    convert<dart_model.PropertyGet>(o)!,
  ),
  front_end.NullAwarePropertyGet o => dart_model
      .Expression.nullAwarePropertyGet(
    convert<dart_model.NullAwarePropertyGet>(o)!,
  ),
  front_end.TypeLiteral o => dart_model.Expression.typeLiteral(
    convert<dart_model.TypeLiteral>(o)!,
  ),
  front_end.ParenthesizedExpression o => dart_model
      .Expression.parenthesizedExpression(
    convert<dart_model.ParenthesizedExpression>(o)!,
  ),
  front_end.ConditionalExpression o => dart_model
      .Expression.conditionalExpression(
    convert<dart_model.ConditionalExpression>(o)!,
  ),
  front_end.ListLiteral o => dart_model.Expression.listLiteral(
    convert<dart_model.ListLiteral>(o)!,
  ),
  front_end.SetOrMapLiteral o => dart_model.Expression.setOrMapLiteral(
    convert<dart_model.SetOrMapLiteral>(o)!,
  ),
  front_end.RecordLiteral o => dart_model.Expression.recordLiteral(
    convert<dart_model.RecordLiteral>(o)!,
  ),
  front_end.IfNull o => dart_model.Expression.ifNull(
    convert<dart_model.IfNull>(o)!,
  ),
  front_end.LogicalExpression o => dart_model.Expression.logicalExpression(
    convert<dart_model.LogicalExpression>(o)!,
  ),
  front_end.EqualityExpression o => dart_model.Expression.equalityExpression(
    convert<dart_model.EqualityExpression>(o)!,
  ),
  front_end.BinaryExpression o => dart_model.Expression.binaryExpression(
    convert<dart_model.BinaryExpression>(o)!,
  ),
  front_end.UnaryExpression o => dart_model.Expression.unaryExpression(
    convert<dart_model.UnaryExpression>(o)!,
  ),
  front_end.IsTest o => dart_model.Expression.isTest(
    convert<dart_model.IsTest>(o)!,
  ),
  front_end.AsExpression o => dart_model.Expression.asExpression(
    convert<dart_model.AsExpression>(o)!,
  ),
  front_end.NullCheck o => dart_model.Expression.nullCheck(
    convert<dart_model.NullCheck>(o)!,
  ),
  front_end.UnresolvedExpression o => dart_model
      .Expression.unresolvedExpression(
    convert<dart_model.UnresolvedExpression>(o)!,
  ),
  null => null,
  _ => throw ArgumentError(object),
};
dart_model.RecordField? convertToRecordField(Object? object) =>
    switch (object) {
      front_end.RecordNamedField o => dart_model.RecordField.recordNamedField(
        convert<dart_model.RecordNamedField>(o)!,
      ),
      front_end.RecordPositionalField o => dart_model
          .RecordField.recordPositionalField(
        convert<dart_model.RecordPositionalField>(o)!,
      ),
      null => null,
      _ => throw ArgumentError(object),
    };
dart_model.Reference? convertToReference(Object? object) => switch (object) {
  front_end.FieldReference o => dart_model.Reference.fieldReference(
    convert<dart_model.FieldReference>(o)!,
  ),
  front_end.FunctionReference o => dart_model.Reference.functionReference(
    convert<dart_model.FunctionReference>(o)!,
  ),
  front_end.ConstructorReference o => dart_model.Reference.constructorReference(
    convert<dart_model.ConstructorReference>(o)!,
  ),
  front_end.TypeReference o => dart_model.Reference.typeReference(
    convert<dart_model.TypeReference>(o)!,
  ),
  front_end.ClassReference o => dart_model.Reference.classReference(
    convert<dart_model.ClassReference>(o)!,
  ),
  front_end.TypedefReference o => dart_model.Reference.typedefReference(
    convert<dart_model.TypedefReference>(o)!,
  ),
  front_end.ExtensionReference o => dart_model.Reference.extensionReference(
    convert<dart_model.ExtensionReference>(o)!,
  ),
  front_end.ExtensionTypeReference o => dart_model
      .Reference.extensionTypeReference(
    convert<dart_model.ExtensionTypeReference>(o)!,
  ),
  front_end.EnumReference o => dart_model.Reference.enumReference(
    convert<dart_model.EnumReference>(o)!,
  ),
  front_end.MixinReference o => dart_model.Reference.mixinReference(
    convert<dart_model.MixinReference>(o)!,
  ),
  front_end.FunctionTypeParameterReference o => dart_model
      .Reference.functionTypeParameterReference(
    convert<dart_model.FunctionTypeParameterReference>(o)!,
  ),
  null => null,
  _ => throw ArgumentError(object),
};
dart_model.StringLiteralPart? convertToStringLiteralPart(Object? object) =>
    switch (object) {
      front_end.StringPart o => dart_model.StringLiteralPart.stringPart(
        convert<dart_model.StringPart>(o)!,
      ),
      front_end.InterpolationPart o => dart_model
          .StringLiteralPart.interpolationPart(
        convert<dart_model.InterpolationPart>(o)!,
      ),
      null => null,
      _ => throw ArgumentError(object),
    };
dart_model.TypeAnnotation? convertToTypeAnnotation(Object? object) =>
    switch (object) {
      front_end.NamedTypeAnnotation o => dart_model
          .TypeAnnotation.namedTypeAnnotation(
        convert<dart_model.NamedTypeAnnotation>(o)!,
      ),
      front_end.NullableTypeAnnotation o => dart_model
          .TypeAnnotation.nullableTypeAnnotation(
        convert<dart_model.NullableTypeAnnotation>(o)!,
      ),
      front_end.VoidTypeAnnotation o => dart_model
          .TypeAnnotation.voidTypeAnnotation(
        convert<dart_model.VoidTypeAnnotation>(o)!,
      ),
      front_end.DynamicTypeAnnotation o => dart_model
          .TypeAnnotation.dynamicTypeAnnotation(
        convert<dart_model.DynamicTypeAnnotation>(o)!,
      ),
      front_end.InvalidTypeAnnotation o => dart_model
          .TypeAnnotation.invalidTypeAnnotation(
        convert<dart_model.InvalidTypeAnnotation>(o)!,
      ),
      front_end.UnresolvedTypeAnnotation o => dart_model
          .TypeAnnotation.unresolvedTypeAnnotation(
        convert<dart_model.UnresolvedTypeAnnotation>(o)!,
      ),
      front_end.FunctionTypeAnnotation o => dart_model
          .TypeAnnotation.functionTypeAnnotation(
        convert<dart_model.FunctionTypeAnnotation>(o)!,
      ),
      front_end.FunctionTypeParameterType o => dart_model
          .TypeAnnotation.functionTypeParameterType(
        convert<dart_model.FunctionTypeParameterType>(o)!,
      ),
      front_end.RecordTypeAnnotation o => dart_model
          .TypeAnnotation.recordTypeAnnotation(
        convert<dart_model.RecordTypeAnnotation>(o)!,
      ),
      null => null,
      _ => throw ArgumentError(object),
    };
T? convert<T>(Object? object) => switch (object) {
  front_end.BinaryOperator o => o.name as T,
  front_end.LogicalOperator o => o.name as T,
  front_end.UnaryOperator o => o.name as T,
  front_end.AdjacentStringLiterals o =>
    dart_model.AdjacentStringLiterals(expressions: convert(o.expressions)) as T,
  front_end.AsExpression o =>
    dart_model.AsExpression(
          expression: convertToExpression(o.expression),
          type: convert(o.type),
        )
        as T,
  front_end.BinaryExpression o =>
    dart_model.BinaryExpression(
          left: convertToExpression(o.left),
          operator: convert(o.operator),
          right: convertToExpression(o.right),
        )
        as T,
  front_end.BooleanLiteral o =>
    dart_model.BooleanLiteral(value: convert(o.value)) as T,
  front_end.ClassReference o =>
    dart_model.ClassReference(name: convert(o.name)) as T,
  front_end.ConditionalExpression o =>
    dart_model.ConditionalExpression(
          condition: convertToExpression(o.condition),
          then: convertToExpression(o.then),
          otherwise: convertToExpression(o.otherwise),
        )
        as T,
  front_end.ConstructorInvocation o =>
    dart_model.ConstructorInvocation(
          type: convert(o.type),
          constructor: convertToReference(o.constructor),
          arguments: convert(o.arguments),
        )
        as T,
  front_end.ConstructorReference o =>
    dart_model.ConstructorReference(name: convert(o.name)) as T,
  front_end.ConstructorTearOff o =>
    dart_model.ConstructorTearOff(
          type: convert(o.type),
          reference: convert(o.reference),
        )
        as T,
  front_end.DoubleLiteral o =>
    dart_model.DoubleLiteral(text: convert(o.text), value: convert(o.value))
        as T,
  front_end.DynamicTypeAnnotation o =>
    dart_model.DynamicTypeAnnotation(reference: convertToReference(o.reference))
        as T,
  front_end.EnumReference o =>
    dart_model.EnumReference(name: convert(o.name)) as T,
  front_end.EqualityExpression o =>
    dart_model.EqualityExpression(
          left: convertToExpression(o.left),
          right: convertToExpression(o.right),
          isNotEquals: convert(o.isNotEquals),
        )
        as T,
  front_end.ExpressionElement o =>
    dart_model.ExpressionElement(
          expression: convertToExpression(o.expression),
          isNullAware: convert(o.isNullAware),
        )
        as T,
  front_end.ExtensionReference o =>
    dart_model.ExtensionReference(name: convert(o.name)) as T,
  front_end.ExtensionTypeReference o =>
    dart_model.ExtensionTypeReference(name: convert(o.name)) as T,
  front_end.FieldReference o =>
    dart_model.FieldReference(name: convert(o.name)) as T,
  front_end.FormalParameter o => dart_model.FormalParameter() as T,
  front_end.FormalParameterGroup o => dart_model.FormalParameterGroup() as T,
  front_end.FunctionReference o =>
    dart_model.FunctionReference(name: convert(o.name)) as T,
  front_end.FunctionTearOff o =>
    dart_model.FunctionTearOff(reference: convert(o.reference)) as T,
  front_end.FunctionTypeAnnotation o =>
    dart_model.FunctionTypeAnnotation(
          returnType: convert(o.returnType),
          typeParameters: convert(o.typeParameters),
          formalParameters: convert(o.formalParameters),
        )
        as T,
  front_end.FunctionTypeParameter o => dart_model.FunctionTypeParameter() as T,
  front_end.FunctionTypeParameterReference o =>
    dart_model.FunctionTypeParameterReference(name: convert(o.name)) as T,
  front_end.FunctionTypeParameterType o =>
    dart_model.FunctionTypeParameterType(
          functionTypeParameter: convert(o.functionTypeParameter),
        )
        as T,
  front_end.IfElement o =>
    dart_model.IfElement(
          condition: convertToExpression(o.condition),
          then: convertToElement(o.then),
          otherwise: convert(o.otherwise),
        )
        as T,
  front_end.IfNull o =>
    dart_model.IfNull(
          left: convertToExpression(o.left),
          right: convertToExpression(o.right),
        )
        as T,
  front_end.ImplicitInvocation o =>
    dart_model.ImplicitInvocation(
          receiver: convertToExpression(o.receiver),
          typeArguments: convert(o.typeArguments),
          arguments: convert(o.arguments),
        )
        as T,
  front_end.Instantiation o =>
    dart_model.Instantiation(
          receiver: convertToExpression(o.receiver),
          typeArguments: convert(o.typeArguments),
        )
        as T,
  front_end.IntegerLiteral o =>
    dart_model.IntegerLiteral(text: convert(o.text), value: convert(o.value))
        as T,
  front_end.InterpolationPart o =>
    dart_model.InterpolationPart(expression: convertToExpression(o.expression))
        as T,
  front_end.InvalidExpression o => dart_model.InvalidExpression() as T,
  front_end.InvalidTypeAnnotation o => dart_model.InvalidTypeAnnotation() as T,
  front_end.IsTest o =>
    dart_model.IsTest(
          expression: convertToExpression(o.expression),
          type: convert(o.type),
          isNot: convert(o.isNot),
        )
        as T,
  front_end.ListLiteral o =>
    dart_model.ListLiteral(
          typeArguments: convert(o.typeArguments),
          elements: convert(o.elements),
        )
        as T,
  front_end.LogicalExpression o =>
    dart_model.LogicalExpression(
          left: convertToExpression(o.left),
          operator: convert(o.operator),
          right: convertToExpression(o.right),
        )
        as T,
  front_end.MapEntryElement o =>
    dart_model.MapEntryElement(
          key: convertToExpression(o.key),
          value: convertToExpression(o.value),
          isNullAwareKey: convert(o.isNullAwareKey),
          isNullAwareValue: convert(o.isNullAwareValue),
        )
        as T,
  front_end.MethodInvocation o =>
    dart_model.MethodInvocation(
          receiver: convertToExpression(o.receiver),
          name: convert(o.name),
          typeArguments: convert(o.typeArguments),
          arguments: convert(o.arguments),
        )
        as T,
  front_end.MixinReference o =>
    dart_model.MixinReference(name: convert(o.name)) as T,
  front_end.NamedArgument o =>
    dart_model.NamedArgument(
          name: convert(o.name),
          expression: convertToExpression(o.expression),
        )
        as T,
  front_end.NamedTypeAnnotation o =>
    dart_model.NamedTypeAnnotation(
          reference: convertToReference(o.reference),
          typeArguments: convert(o.typeArguments),
        )
        as T,
  front_end.NullableTypeAnnotation o =>
    dart_model.NullableTypeAnnotation(typeAnnotation: convert(o.typeAnnotation))
        as T,
  front_end.NullAwarePropertyGet o =>
    dart_model.NullAwarePropertyGet(
          receiver: convertToExpression(o.receiver),
          name: convert(o.name),
        )
        as T,
  front_end.NullCheck o =>
    dart_model.NullCheck(expression: convertToExpression(o.expression)) as T,
  front_end.NullLiteral o => dart_model.NullLiteral() as T,
  front_end.ParenthesizedExpression o =>
    dart_model.ParenthesizedExpression(
          expression: convertToExpression(o.expression),
        )
        as T,
  front_end.PositionalArgument o =>
    dart_model.PositionalArgument(expression: convertToExpression(o.expression))
        as T,
  front_end.PropertyGet o =>
    dart_model.PropertyGet(
          receiver: convertToExpression(o.receiver),
          name: convert(o.name),
        )
        as T,
  front_end.RecordLiteral o =>
    dart_model.RecordLiteral(fields: convert(o.fields)) as T,
  front_end.RecordNamedField o =>
    dart_model.RecordNamedField(
          name: convert(o.name),
          expression: convertToExpression(o.expression),
        )
        as T,
  front_end.RecordPositionalField o =>
    dart_model.RecordPositionalField(
          expression: convertToExpression(o.expression),
        )
        as T,
  front_end.RecordTypeAnnotation o =>
    dart_model.RecordTypeAnnotation(
          positional: convert(o.positional),
          named: convert(o.named),
        )
        as T,
  front_end.RecordTypeEntry o => dart_model.RecordTypeEntry() as T,
  front_end.References o => dart_model.References() as T,
  front_end.SetOrMapLiteral o =>
    dart_model.SetOrMapLiteral(
          typeArguments: convert(o.typeArguments),
          elements: convert(o.elements),
        )
        as T,
  front_end.SpreadElement o =>
    dart_model.SpreadElement(
          expression: convertToExpression(o.expression),
          isNullAware: convert(o.isNullAware),
        )
        as T,
  front_end.StaticGet o =>
    dart_model.StaticGet(reference: convert(o.reference)) as T,
  front_end.StaticInvocation o =>
    dart_model.StaticInvocation(
          function: convert(o.function),
          typeArguments: convert(o.typeArguments),
          arguments: convert(o.arguments),
        )
        as T,
  front_end.StringLiteral o =>
    dart_model.StringLiteral(parts: convert(o.parts)) as T,
  front_end.StringPart o => dart_model.StringPart(text: convert(o.text)) as T,
  front_end.SymbolLiteral o =>
    dart_model.SymbolLiteral(parts: convert(o.parts)) as T,
  front_end.TypedefReference o =>
    dart_model.TypedefReference(name: convert(o.name)) as T,
  front_end.TypeLiteral o =>
    dart_model.TypeLiteral(typeAnnotation: convert(o.typeAnnotation)) as T,
  front_end.TypeReference o => dart_model.TypeReference() as T,
  front_end.UnaryExpression o =>
    dart_model.UnaryExpression(
          operator: convert(o.operator),
          expression: convertToExpression(o.expression),
        )
        as T,
  front_end.UnresolvedExpression o => dart_model.UnresolvedExpression() as T,
  front_end.UnresolvedTypeAnnotation o =>
    dart_model.UnresolvedTypeAnnotation() as T,
  front_end.VoidTypeAnnotation o =>
    dart_model.VoidTypeAnnotation(reference: convertToReference(o.reference))
        as T,
  String o => o as T,
  int o => o as T,
  bool o => o as T,
  double o => o as T,
  // Manually added converters for lists of union types.
  List<front_end.Argument> o =>
    o.map((i) => convertToArgument(i)!).toList() as T,
  List<front_end.Element> o => o.map((i) => convertToElement(i)!).toList() as T,
  List<front_end.Expression> o =>
    o.map((i) => convertToExpression(i)!).toList() as T,
  List<front_end.RecordField> o =>
    o.map((i) => convertToRecordField(i)!).toList() as T,
  List<front_end.StringLiteralPart> o =>
    o.map((i) => convertToStringLiteralPart(i)!).toList() as T,
  List<front_end.TypeAnnotation> o =>
    o.map((i) => convertToTypeAnnotation(i)!).toList() as T,
  List o => o.map((i) => convert<Map<String, Object?>>(i)!).toList() as T,
  null => null,
  _ => throw ArgumentError(object),
};
