// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'generate_dart_model.dart';

// These definitions are generated and experimental, talk to davidmorgan@
// before making any manual changes.
// TODO(davidmorgan): determine how this will be maintained.

final definitions = [
  Definition.union(
    'Argument',
    createInBuffer: true,
    description: '',
    types: [
      'PositionalArgument',
      'NamedArgument',
    ],
    properties: [],
  ),
  Definition.union(
    'Element',
    createInBuffer: true,
    description: '',
    types: [
      'ExpressionElement',
      'MapEntryElement',
      'SpreadElement',
      'IfElement',
    ],
    properties: [],
  ),
  Definition.union(
    'Expression',
    createInBuffer: true,
    description: '',
    types: [
      'InvalidExpression',
      'StaticGet',
      'FunctionTearOff',
      'ConstructorTearOff',
      'ConstructorInvocation',
      'IntegerLiteral',
      'DoubleLiteral',
      'BooleanLiteral',
      'NullLiteral',
      'SymbolLiteral',
      'StringLiteral',
      'AdjacentStringLiterals',
      'ImplicitInvocation',
      'StaticInvocation',
      'Instantiation',
      'MethodInvocation',
      'PropertyGet',
      'NullAwarePropertyGet',
      'TypeLiteral',
      'ParenthesizedExpression',
      'ConditionalExpression',
      'ListLiteral',
      'SetOrMapLiteral',
      'RecordLiteral',
      'IfNull',
      'LogicalExpression',
      'EqualityExpression',
      'BinaryExpression',
      'UnaryExpression',
      'IsTest',
      'AsExpression',
      'NullCheck',
      'UnresolvedExpression',
    ],
    properties: [],
  ),
  Definition.union(
    'RecordField',
    createInBuffer: true,
    description: '',
    types: [
      'RecordNamedField',
      'RecordPositionalField',
    ],
    properties: [],
  ),
  Definition.union(
    'Reference',
    createInBuffer: true,
    description: '',
    types: [
      'FieldReference',
      'FunctionReference',
      'ConstructorReference',
      'TypeReference',
      'ClassReference',
      'TypedefReference',
      'ExtensionReference',
      'ExtensionTypeReference',
      'EnumReference',
      'FunctionTypeParameterReference',
    ],
    properties: [],
  ),
  Definition.union(
    'StringLiteralPart',
    createInBuffer: true,
    description: '',
    types: [
      'StringPart',
      'InterpolationPart',
    ],
    properties: [],
  ),
  Definition.union(
    'TypeAnnotation',
    createInBuffer: true,
    description: '',
    types: [
      'NamedTypeAnnotation',
      'NullableTypeAnnotation',
      'VoidTypeAnnotation',
      'DynamicTypeAnnotation',
      'InvalidTypeAnnotation',
      'UnresolvedTypeAnnotation',
      'FunctionTypeAnnotation',
      'FunctionTypeParameterType',
      'RecordTypeAnnotation',
    ],
    properties: [],
  ),
  Definition.$enum(
    'BinaryOperator',
    description: '',
    values: [
      'greaterThan',
      'greaterThanOrEqual',
      'lessThan',
      'lessThanOrEqual',
      'shiftLeft',
      'signedShiftRight',
      'unsignedShiftRight',
      'plus',
      'minus',
      'times',
      'divide',
      'integerDivide',
      'modulo',
      'bitwiseOr',
      'bitwiseAnd',
      'bitwiseXor',
    ],
  ),
  Definition.$enum(
    'LogicalOperator',
    description: '',
    values: [
      'and',
      'or',
    ],
  ),
  Definition.$enum(
    'UnaryOperator',
    description: '',
    values: [
      'minus',
      'bang',
      'tilde',
    ],
  ),
  Definition.clazz(
    'AsExpression',
    createInBuffer: true,
    description: '',
    properties: [
      Property('expression', type: 'Expression', description: ''),
      Property('type', type: 'TypeAnnotation', description: ''),
    ],
  ),
  Definition.clazz(
    'BinaryExpression',
    createInBuffer: true,
    description: '',
    properties: [
      Property('left', type: 'Expression', description: ''),
      Property('operator', type: 'BinaryOperator', description: ''),
      Property('right', type: 'Expression', description: ''),
    ],
  ),
  Definition.clazz(
    'BooleanLiteral',
    createInBuffer: true,
    description: '',
    properties: [
      Property('text', type: 'String', description: ''),
    ],
  ),
  Definition.clazz(
    'ClassReference',
    createInBuffer: true,
    description: '',
    properties: [],
  ),
  Definition.clazz(
    'ConditionalExpression',
    createInBuffer: true,
    description: '',
    properties: [
      Property('condition', type: 'Expression', description: ''),
      Property('then', type: 'Expression', description: ''),
      Property('otherwise', type: 'Expression', description: ''),
    ],
  ),
  Definition.clazz(
    'ConstructorInvocation',
    createInBuffer: true,
    description: '',
    properties: [
      Property('type', type: 'TypeAnnotation', description: ''),
      Property('constructor', type: 'Reference', description: ''),
      Property('arguments', type: 'List<Argument>', description: ''),
    ],
  ),
  Definition.clazz(
    'ConstructorReference',
    createInBuffer: true,
    description: '',
    properties: [],
  ),
  Definition.clazz(
    'ConstructorTearOff',
    createInBuffer: true,
    description: '',
    properties: [
      Property('type', type: 'TypeAnnotation', description: ''),
      Property('reference', type: 'ConstructorReference', description: ''),
    ],
  ),
  Definition.clazz(
    'DoubleLiteral',
    createInBuffer: true,
    description: '',
    properties: [
      Property('text', type: 'String', description: ''),
    ],
  ),
  Definition.clazz(
    'DynamicTypeAnnotation',
    createInBuffer: true,
    description: '',
    properties: [
      Property('reference', type: 'Reference', description: ''),
    ],
  ),
  Definition.clazz(
    'EnumReference',
    createInBuffer: true,
    description: '',
    properties: [],
  ),
  Definition.clazz(
    'EqualityExpression',
    createInBuffer: true,
    description: '',
    properties: [
      Property('left', type: 'Expression', description: ''),
      Property('right', type: 'Expression', description: ''),
      Property('isNotEquals', type: 'bool', description: ''),
    ],
  ),
  Definition.clazz(
    'ExpressionElement',
    createInBuffer: true,
    description: '',
    properties: [
      Property('expression', type: 'Expression', description: ''),
      Property('isNullAware', type: 'bool', description: ''),
    ],
  ),
  Definition.clazz(
    'ExtensionReference',
    createInBuffer: true,
    description: '',
    properties: [],
  ),
  Definition.clazz(
    'ExtensionTypeReference',
    createInBuffer: true,
    description: '',
    properties: [],
  ),
  Definition.clazz(
    'FieldReference',
    createInBuffer: true,
    description: '',
    properties: [],
  ),
  Definition.clazz(
    'FormalParameter',
    createInBuffer: true,
    description: '',
    properties: [],
  ),
  Definition.clazz(
    'FormalParameterGroup',
    createInBuffer: true,
    description: '',
    properties: [],
  ),
  Definition.clazz(
    'FunctionReference',
    createInBuffer: true,
    description: '',
    properties: [],
  ),
  Definition.clazz(
    'FunctionTearOff',
    createInBuffer: true,
    description: '',
    properties: [
      Property('reference', type: 'FunctionReference', description: ''),
    ],
  ),
  Definition.clazz(
    'FunctionTypeAnnotation',
    createInBuffer: true,
    description: '',
    properties: [
      Property('returnType',
          type: 'TypeAnnotation', description: '', nullable: true),
      Property('typeParameters',
          type: 'List<FunctionTypeParameter>', description: ''),
      Property('formalParameters',
          type: 'List<FormalParameter>', description: ''),
    ],
  ),
  Definition.clazz(
    'FunctionTypeParameter',
    createInBuffer: true,
    description: '',
    properties: [],
  ),
  Definition.clazz(
    'FunctionTypeParameterReference',
    createInBuffer: true,
    description: '',
    properties: [],
  ),
  Definition.clazz(
    'FunctionTypeParameterType',
    createInBuffer: true,
    description: '',
    properties: [
      Property('functionTypeParameter',
          type: 'FunctionTypeParameter', description: ''),
    ],
  ),
  Definition.clazz(
    'IfElement',
    createInBuffer: true,
    description: '',
    properties: [
      Property('condition', type: 'Expression', description: ''),
      Property('then', type: 'Element', description: ''),
      Property('otherwise', type: 'Element', description: '', nullable: true),
    ],
  ),
  Definition.clazz(
    'IfNull',
    createInBuffer: true,
    description: '',
    properties: [
      Property('left', type: 'Expression', description: ''),
      Property('right', type: 'Expression', description: ''),
    ],
  ),
  Definition.clazz(
    'ImplicitInvocation',
    createInBuffer: true,
    description: '',
    properties: [
      Property('receiver', type: 'Expression', description: ''),
      Property('typeArguments', type: 'List<TypeAnnotation>', description: ''),
      Property('arguments', type: 'List<Argument>', description: ''),
    ],
  ),
  Definition.clazz(
    'Instantiation',
    createInBuffer: true,
    description: '',
    properties: [
      Property('receiver', type: 'Expression', description: ''),
      Property('typeArguments', type: 'List<TypeAnnotation>', description: ''),
    ],
  ),
  Definition.clazz(
    'IntegerLiteral',
    createInBuffer: true,
    description: '',
    properties: [
      Property('text', type: 'String', description: ''),
    ],
  ),
  Definition.clazz(
    'InterpolationPart',
    createInBuffer: true,
    description: '',
    properties: [
      Property('expression', type: 'Expression', description: ''),
    ],
  ),
  Definition.clazz(
    'InvalidExpression',
    createInBuffer: true,
    description: '',
    properties: [],
  ),
  Definition.clazz(
    'InvalidTypeAnnotation',
    createInBuffer: true,
    description: '',
    properties: [],
  ),
  Definition.clazz(
    'IsTest',
    createInBuffer: true,
    description: '',
    properties: [
      Property('expression', type: 'Expression', description: ''),
      Property('type', type: 'TypeAnnotation', description: ''),
      Property('isNot', type: 'bool', description: ''),
    ],
  ),
  Definition.clazz(
    'ListLiteral',
    createInBuffer: true,
    description: '',
    properties: [
      Property('typeArguments', type: 'List<TypeAnnotation>', description: ''),
      Property('elements', type: 'List<Element>', description: ''),
    ],
  ),
  Definition.clazz(
    'LogicalExpression',
    createInBuffer: true,
    description: '',
    properties: [
      Property('left', type: 'Expression', description: ''),
      Property('operator', type: 'LogicalOperator', description: ''),
      Property('right', type: 'Expression', description: ''),
    ],
  ),
  Definition.clazz(
    'MapEntryElement',
    createInBuffer: true,
    description: '',
    properties: [
      Property('key', type: 'Expression', description: ''),
      Property('value', type: 'Expression', description: ''),
      Property('isNullAwareKey', type: 'bool', description: ''),
      Property('isNullAwareValue', type: 'bool', description: ''),
    ],
  ),
  Definition.clazz(
    'MethodInvocation',
    createInBuffer: true,
    description: '',
    properties: [
      Property('receiver', type: 'Expression', description: ''),
      Property('name', type: 'String', description: ''),
      Property('typeArguments', type: 'List<TypeAnnotation>', description: ''),
      Property('arguments', type: 'List<Argument>', description: ''),
    ],
  ),
  Definition.clazz(
    'NamedArgument',
    createInBuffer: true,
    description: '',
    properties: [
      Property('name', type: 'String', description: ''),
      Property('expression', type: 'Expression', description: ''),
    ],
  ),
  Definition.clazz(
    'NamedTypeAnnotation',
    createInBuffer: true,
    description: '',
    properties: [
      Property('reference', type: 'Reference', description: ''),
      Property('typeArguments', type: 'List<TypeAnnotation>', description: ''),
    ],
  ),
  Definition.clazz(
    'NullableTypeAnnotation',
    createInBuffer: true,
    description: '',
    properties: [
      Property('typeAnnotation', type: 'TypeAnnotation', description: ''),
    ],
  ),
  Definition.clazz(
    'NullAwarePropertyGet',
    createInBuffer: true,
    description: '',
    properties: [
      Property('receiver', type: 'Expression', description: ''),
      Property('name', type: 'String', description: ''),
    ],
  ),
  Definition.clazz(
    'NullCheck',
    createInBuffer: true,
    description: '',
    properties: [
      Property('expression', type: 'Expression', description: ''),
    ],
  ),
  Definition.clazz(
    'NullLiteral',
    createInBuffer: true,
    description: '',
    properties: [],
  ),
  Definition.clazz(
    'ParenthesizedExpression',
    createInBuffer: true,
    description: '',
    properties: [
      Property('expression', type: 'Expression', description: ''),
    ],
  ),
  Definition.clazz(
    'PositionalArgument',
    createInBuffer: true,
    description: '',
    properties: [
      Property('expression', type: 'Expression', description: ''),
    ],
  ),
  Definition.clazz(
    'PropertyGet',
    createInBuffer: true,
    description: '',
    properties: [
      Property('receiver', type: 'Expression', description: ''),
      Property('name', type: 'String', description: ''),
    ],
  ),
  Definition.clazz(
    'RecordLiteral',
    createInBuffer: true,
    description: '',
    properties: [
      Property('fields', type: 'List<RecordField>', description: ''),
    ],
  ),
  Definition.clazz(
    'RecordNamedField',
    createInBuffer: true,
    description: '',
    properties: [
      Property('name', type: 'String', description: ''),
      Property('expression', type: 'Expression', description: ''),
    ],
  ),
  Definition.clazz(
    'RecordPositionalField',
    createInBuffer: true,
    description: '',
    properties: [
      Property('expression', type: 'Expression', description: ''),
    ],
  ),
  Definition.clazz(
    'RecordTypeAnnotation',
    createInBuffer: true,
    description: '',
    properties: [
      Property('positional', type: 'List<RecordTypeEntry>', description: ''),
      Property('named', type: 'List<RecordTypeEntry>', description: ''),
    ],
  ),
  Definition.clazz(
    'RecordTypeEntry',
    createInBuffer: true,
    description: '',
    properties: [],
  ),
  Definition.clazz(
    'References',
    createInBuffer: true,
    description: '',
    properties: [],
  ),
  Definition.clazz(
    'SetOrMapLiteral',
    createInBuffer: true,
    description: '',
    properties: [
      Property('typeArguments', type: 'List<TypeAnnotation>', description: ''),
      Property('elements', type: 'List<Element>', description: ''),
    ],
  ),
  Definition.clazz(
    'SpreadElement',
    createInBuffer: true,
    description: '',
    properties: [
      Property('expression', type: 'Expression', description: ''),
      Property('isNullAware', type: 'bool', description: ''),
    ],
  ),
  Definition.clazz(
    'StaticGet',
    createInBuffer: true,
    description: '',
    properties: [
      Property('reference', type: 'FieldReference', description: ''),
    ],
  ),
  Definition.clazz(
    'StaticInvocation',
    createInBuffer: true,
    description: '',
    properties: [
      Property('function', type: 'FunctionReference', description: ''),
      Property('typeArguments', type: 'List<TypeAnnotation>', description: ''),
      Property('arguments', type: 'List<Argument>', description: ''),
    ],
  ),
  Definition.clazz(
    'AdjacentStringLiterals',
    createInBuffer: true,
    description: '',
    properties: [
      Property('expressions', type: 'List<Expression>', description: ''),
    ],
  ),
  Definition.clazz(
    'StringLiteral',
    createInBuffer: true,
    description: '',
    properties: [
      Property('parts', type: 'List<StringLiteralPart>', description: ''),
    ],
  ),
  Definition.clazz(
    'StringPart',
    createInBuffer: true,
    description: '',
    properties: [
      Property('text', type: 'String', description: ''),
    ],
  ),
  Definition.clazz(
    'SymbolLiteral',
    createInBuffer: true,
    description: '',
    properties: [
      Property('parts', type: 'List<String>', description: ''),
    ],
  ),
  Definition.clazz(
    'TypedefReference',
    createInBuffer: true,
    description: '',
    properties: [],
  ),
  Definition.clazz(
    'TypeLiteral',
    createInBuffer: true,
    description: '',
    properties: [
      Property('typeAnnotation', type: 'TypeAnnotation', description: ''),
    ],
  ),
  Definition.clazz(
    'TypeReference',
    createInBuffer: true,
    description: '',
    properties: [],
  ),
  Definition.clazz(
    'UnaryExpression',
    createInBuffer: true,
    description: '',
    properties: [
      Property('operator', type: 'UnaryOperator', description: ''),
      Property('expression', type: 'Expression', description: ''),
    ],
  ),
  Definition.clazz(
    'UnresolvedExpression',
    createInBuffer: true,
    description: '',
    properties: [],
  ),
  Definition.clazz(
    'UnresolvedTypeAnnotation',
    createInBuffer: true,
    description: '',
    properties: [],
  ),
  Definition.clazz(
    'VoidTypeAnnotation',
    createInBuffer: true,
    description: '',
    properties: [
      Property('reference', type: 'Reference', description: ''),
    ],
  ),
];
