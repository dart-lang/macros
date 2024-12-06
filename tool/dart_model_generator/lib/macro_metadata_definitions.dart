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
    description: '',
    types: ['PositionalArgument', 'NamedArgument'],
    properties: [],
  ),
  Definition.union(
    'Element',
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
    description: '',
    types: ['RecordNamedField', 'RecordPositionalField'],
    properties: [],
  ),
  Definition.union(
    'Reference',
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
      'MixinReference',
      'FunctionTypeParameterReference',
    ],
    properties: [],
  ),
  Definition.union(
    'StringLiteralPart',
    description: '',
    types: ['StringPart', 'InterpolationPart'],
    properties: [],
  ),
  Definition.union(
    'TypeAnnotation',
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
  Definition.$enum('LogicalOperator', description: '', values: ['and', 'or']),
  Definition.$enum(
    'UnaryOperator',
    description: '',
    values: ['minus', 'bang', 'tilde'],
  ),
  Definition.clazz(
    'AdjacentStringLiterals',
    description: '',
    properties: [
      Property('expressions', type: 'List<Expression>', description: ''),
    ],
  ),
  Definition.clazz(
    'AsExpression',
    description: '',
    properties: [
      Property('expression', type: 'Expression', description: ''),
      Property('type', type: 'TypeAnnotation', description: ''),
    ],
  ),
  Definition.clazz(
    'BinaryExpression',
    description: '',
    properties: [
      Property('left', type: 'Expression', description: ''),
      Property('operator', type: 'BinaryOperator', description: ''),
      Property('right', type: 'Expression', description: ''),
    ],
  ),
  Definition.clazz(
    'BooleanLiteral',
    description: '',
    properties: [Property('value', type: 'bool', description: '')],
  ),
  Definition.clazz(
    'ClassReference',
    description: '',
    properties: [Property('name', type: 'String', description: '')],
  ),
  Definition.clazz(
    'ConditionalExpression',
    description: '',
    properties: [
      Property('condition', type: 'Expression', description: ''),
      Property('then', type: 'Expression', description: ''),
      Property('otherwise', type: 'Expression', description: ''),
    ],
  ),
  Definition.clazz(
    'ConstructorInvocation',
    description: '',
    properties: [
      Property('type', type: 'TypeAnnotation', description: ''),
      Property('constructor', type: 'Reference', description: ''),
      Property('arguments', type: 'List<Argument>', description: ''),
    ],
  ),
  Definition.clazz(
    'ConstructorReference',
    description: '',
    properties: [Property('name', type: 'String', description: '')],
  ),
  Definition.clazz(
    'ConstructorTearOff',
    description: '',
    properties: [
      Property('type', type: 'TypeAnnotation', description: ''),
      Property('reference', type: 'ConstructorReference', description: ''),
    ],
  ),
  Definition.clazz(
    'DoubleLiteral',
    description: '',
    properties: [
      Property('text', type: 'String', description: ''),
      Property('value', type: 'double', description: ''),
    ],
  ),
  Definition.clazz(
    'DynamicTypeAnnotation',
    description: '',
    properties: [Property('reference', type: 'Reference', description: '')],
  ),
  Definition.clazz(
    'EnumReference',
    description: '',
    properties: [Property('name', type: 'String', description: '')],
  ),
  Definition.clazz(
    'EqualityExpression',
    description: '',
    properties: [
      Property('left', type: 'Expression', description: ''),
      Property('right', type: 'Expression', description: ''),
      Property('isNotEquals', type: 'bool', description: ''),
    ],
  ),
  Definition.clazz(
    'ExpressionElement',
    description: '',
    properties: [
      Property('expression', type: 'Expression', description: ''),
      Property('isNullAware', type: 'bool', description: ''),
    ],
  ),
  Definition.clazz(
    'ExtensionReference',
    description: '',
    properties: [Property('name', type: 'String', description: '')],
  ),
  Definition.clazz(
    'ExtensionTypeReference',
    description: '',
    properties: [Property('name', type: 'String', description: '')],
  ),
  Definition.clazz(
    'FieldReference',
    description: '',
    properties: [Property('name', type: 'String', description: '')],
  ),
  Definition.clazz('FormalParameter', description: '', properties: [
  ],
),
  Definition.clazz('FormalParameterGroup', description: '', properties: [
  ],
),
  Definition.clazz(
    'FunctionReference',
    description: '',
    properties: [Property('name', type: 'String', description: '')],
  ),
  Definition.clazz(
    'FunctionTearOff',
    description: '',
    properties: [
      Property('reference', type: 'FunctionReference', description: ''),
    ],
  ),
  Definition.clazz(
    'FunctionTypeAnnotation',
    description: '',
    properties: [
      Property(
        'returnType',
        type: 'TypeAnnotation',
        description: '',
        nullable: true,
      ),
      Property(
        'typeParameters',
        type: 'List<FunctionTypeParameter>',
        description: '',
      ),
      Property(
        'formalParameters',
        type: 'List<FormalParameter>',
        description: '',
      ),
    ],
  ),
  Definition.clazz('FunctionTypeParameter', description: '', properties: [
  ],
),
  Definition.clazz(
    'FunctionTypeParameterReference',
    description: '',
    properties: [Property('name', type: 'String', description: '')],
  ),
  Definition.clazz(
    'FunctionTypeParameterType',
    description: '',
    properties: [
      Property(
        'functionTypeParameter',
        type: 'FunctionTypeParameter',
        description: '',
      ),
    ],
  ),
  Definition.clazz(
    'IfElement',
    description: '',
    properties: [
      Property('condition', type: 'Expression', description: ''),
      Property('then', type: 'Element', description: ''),
      Property('otherwise', type: 'Element', description: '', nullable: true),
    ],
  ),
  Definition.clazz(
    'IfNull',
    description: '',
    properties: [
      Property('left', type: 'Expression', description: ''),
      Property('right', type: 'Expression', description: ''),
    ],
  ),
  Definition.clazz(
    'ImplicitInvocation',
    description: '',
    properties: [
      Property('receiver', type: 'Expression', description: ''),
      Property('typeArguments', type: 'List<TypeAnnotation>', description: ''),
      Property('arguments', type: 'List<Argument>', description: ''),
    ],
  ),
  Definition.clazz(
    'Instantiation',
    description: '',
    properties: [
      Property('receiver', type: 'Expression', description: ''),
      Property('typeArguments', type: 'List<TypeAnnotation>', description: ''),
    ],
  ),
  Definition.clazz(
    'IntegerLiteral',
    description: '',
    properties: [
      Property('text', type: 'String', description: '', nullable: true),
      Property('value', type: 'int', description: '', nullable: true),
    ],
  ),
  Definition.clazz(
    'InterpolationPart',
    description: '',
    properties: [Property('expression', type: 'Expression', description: '')],
  ),
  Definition.clazz('InvalidExpression', description: '', properties: [
  ],
),
  Definition.clazz('InvalidTypeAnnotation', description: '', properties: [
  ],
),
  Definition.clazz(
    'IsTest',
    description: '',
    properties: [
      Property('expression', type: 'Expression', description: ''),
      Property('type', type: 'TypeAnnotation', description: ''),
      Property('isNot', type: 'bool', description: ''),
    ],
  ),
  Definition.clazz(
    'ListLiteral',
    description: '',
    properties: [
      Property('typeArguments', type: 'List<TypeAnnotation>', description: ''),
      Property('elements', type: 'List<Element>', description: ''),
    ],
  ),
  Definition.clazz(
    'LogicalExpression',
    description: '',
    properties: [
      Property('left', type: 'Expression', description: ''),
      Property('operator', type: 'LogicalOperator', description: ''),
      Property('right', type: 'Expression', description: ''),
    ],
  ),
  Definition.clazz(
    'MapEntryElement',
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
    description: '',
    properties: [
      Property('receiver', type: 'Expression', description: ''),
      Property('name', type: 'String', description: ''),
      Property('typeArguments', type: 'List<TypeAnnotation>', description: ''),
      Property('arguments', type: 'List<Argument>', description: ''),
    ],
  ),
  Definition.clazz(
    'MixinReference',
    description: '',
    properties: [Property('name', type: 'String', description: '')],
  ),
  Definition.clazz(
    'NamedArgument',
    description: '',
    properties: [
      Property('name', type: 'String', description: ''),
      Property('expression', type: 'Expression', description: ''),
    ],
  ),
  Definition.clazz(
    'NamedTypeAnnotation',
    description: '',
    properties: [
      Property('reference', type: 'Reference', description: ''),
      Property('typeArguments', type: 'List<TypeAnnotation>', description: ''),
    ],
  ),
  Definition.clazz(
    'NullableTypeAnnotation',
    description: '',
    properties: [
      Property('typeAnnotation', type: 'TypeAnnotation', description: ''),
    ],
  ),
  Definition.clazz(
    'NullAwarePropertyGet',
    description: '',
    properties: [
      Property('receiver', type: 'Expression', description: ''),
      Property('name', type: 'String', description: ''),
    ],
  ),
  Definition.clazz(
    'NullCheck',
    description: '',
    properties: [Property('expression', type: 'Expression', description: '')],
  ),
  Definition.clazz('NullLiteral', description: '', properties: [
  ],
),
  Definition.clazz(
    'ParenthesizedExpression',
    description: '',
    properties: [Property('expression', type: 'Expression', description: '')],
  ),
  Definition.clazz(
    'PositionalArgument',
    description: '',
    properties: [Property('expression', type: 'Expression', description: '')],
  ),
  Definition.clazz(
    'PropertyGet',
    description: '',
    properties: [
      Property('receiver', type: 'Expression', description: ''),
      Property('name', type: 'String', description: ''),
    ],
  ),
  Definition.clazz(
    'RecordLiteral',
    description: '',
    properties: [
      Property('fields', type: 'List<RecordField>', description: ''),
    ],
  ),
  Definition.clazz(
    'RecordNamedField',
    description: '',
    properties: [
      Property('name', type: 'String', description: ''),
      Property('expression', type: 'Expression', description: ''),
    ],
  ),
  Definition.clazz(
    'RecordPositionalField',
    description: '',
    properties: [Property('expression', type: 'Expression', description: '')],
  ),
  Definition.clazz(
    'RecordTypeAnnotation',
    description: '',
    properties: [
      Property('positional', type: 'List<RecordTypeEntry>', description: ''),
      Property('named', type: 'List<RecordTypeEntry>', description: ''),
    ],
  ),
  Definition.clazz('RecordTypeEntry', description: '', properties: [
  ],
),
  Definition.clazz('References', description: '', properties: [
  ],
),
  Definition.clazz(
    'SetOrMapLiteral',
    description: '',
    properties: [
      Property('typeArguments', type: 'List<TypeAnnotation>', description: ''),
      Property('elements', type: 'List<Element>', description: ''),
    ],
  ),
  Definition.clazz(
    'SpreadElement',
    description: '',
    properties: [
      Property('expression', type: 'Expression', description: ''),
      Property('isNullAware', type: 'bool', description: ''),
    ],
  ),
  Definition.clazz(
    'StaticGet',
    description: '',
    properties: [
      Property('reference', type: 'FieldReference', description: ''),
    ],
  ),
  Definition.clazz(
    'StaticInvocation',
    description: '',
    properties: [
      Property('function', type: 'FunctionReference', description: ''),
      Property('typeArguments', type: 'List<TypeAnnotation>', description: ''),
      Property('arguments', type: 'List<Argument>', description: ''),
    ],
  ),
  Definition.clazz(
    'StringLiteral',
    description: '',
    properties: [
      Property('parts', type: 'List<StringLiteralPart>', description: ''),
    ],
  ),
  Definition.clazz(
    'StringPart',
    description: '',
    properties: [Property('text', type: 'String', description: '')],
  ),
  Definition.clazz(
    'SymbolLiteral',
    description: '',
    properties: [Property('parts', type: 'List<String>', description: '')],
  ),
  Definition.clazz(
    'TypedefReference',
    description: '',
    properties: [Property('name', type: 'String', description: '')],
  ),
  Definition.clazz(
    'TypeLiteral',
    description: '',
    properties: [
      Property('typeAnnotation', type: 'TypeAnnotation', description: ''),
    ],
  ),
  Definition.clazz('TypeReference', description: '', properties: [
  ],
),
  Definition.clazz(
    'UnaryExpression',
    description: '',
    properties: [
      Property('operator', type: 'UnaryOperator', description: ''),
      Property('expression', type: 'Expression', description: ''),
    ],
  ),
  Definition.clazz('UnresolvedExpression', description: '', properties: [
  ],
),
  Definition.clazz('UnresolvedTypeAnnotation', description: '', properties: [
  ],
),
  Definition.clazz(
    'VoidTypeAnnotation',
    description: '',
    properties: [Property('reference', type: 'Reference', description: '')],
  ),
];
