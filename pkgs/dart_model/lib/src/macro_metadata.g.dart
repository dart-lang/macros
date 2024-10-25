// This file is generated. To make changes edit tool/dart_model_generator
// then run from the repo root: dart tool/dart_model_generator/bin/main.dart

// ignore: implementation_imports,unused_import,prefer_relative_imports
import 'package:dart_model/src/deep_cast_map.dart';
// ignore: implementation_imports,unused_import,prefer_relative_imports
import 'package:dart_model/src/json_buffer/json_buffer_builder.dart';
// ignore: implementation_imports,unused_import,prefer_relative_imports
import 'package:dart_model/src/scopes.dart';

enum ArgumentType {
  // Private so switches must have a default. See `isKnown`.
  _unknown,
  positionalArgument,
  namedArgument;

  bool get isKnown => this != _unknown;
}

extension type Argument.fromJson(Map<String, Object?> node) implements Object {
  static Argument positionalArgument(PositionalArgument positionalArgument) =>
      Argument.fromJson({
        'type': 'PositionalArgument',
        'value': positionalArgument,
      });
  static Argument namedArgument(NamedArgument namedArgument) =>
      Argument.fromJson({
        'type': 'NamedArgument',
        'value': namedArgument,
      });
  ArgumentType get type {
    switch (node['type'] as String) {
      case 'PositionalArgument':
        return ArgumentType.positionalArgument;
      case 'NamedArgument':
        return ArgumentType.namedArgument;
      default:
        return ArgumentType._unknown;
    }
  }

  PositionalArgument get asPositionalArgument {
    if (node['type'] != 'PositionalArgument') {
      throw StateError('Not a PositionalArgument.');
    }
    return PositionalArgument.fromJson(node['value'] as Map<String, Object?>);
  }

  NamedArgument get asNamedArgument {
    if (node['type'] != 'NamedArgument') {
      throw StateError('Not a NamedArgument.');
    }
    return NamedArgument.fromJson(node['value'] as Map<String, Object?>);
  }
}

enum ElementType {
  // Private so switches must have a default. See `isKnown`.
  _unknown,
  expressionElement,
  mapEntryElement,
  spreadElement,
  ifElement;

  bool get isKnown => this != _unknown;
}

extension type Element.fromJson(Map<String, Object?> node) implements Object {
  static Element expressionElement(ExpressionElement expressionElement) =>
      Element.fromJson({
        'type': 'ExpressionElement',
        'value': expressionElement,
      });
  static Element mapEntryElement(MapEntryElement mapEntryElement) =>
      Element.fromJson({
        'type': 'MapEntryElement',
        'value': mapEntryElement,
      });
  static Element spreadElement(SpreadElement spreadElement) =>
      Element.fromJson({
        'type': 'SpreadElement',
        'value': spreadElement,
      });
  static Element ifElement(IfElement ifElement) => Element.fromJson({
        'type': 'IfElement',
        'value': ifElement,
      });
  ElementType get type {
    switch (node['type'] as String) {
      case 'ExpressionElement':
        return ElementType.expressionElement;
      case 'MapEntryElement':
        return ElementType.mapEntryElement;
      case 'SpreadElement':
        return ElementType.spreadElement;
      case 'IfElement':
        return ElementType.ifElement;
      default:
        return ElementType._unknown;
    }
  }

  ExpressionElement get asExpressionElement {
    if (node['type'] != 'ExpressionElement') {
      throw StateError('Not a ExpressionElement.');
    }
    return ExpressionElement.fromJson(node['value'] as Map<String, Object?>);
  }

  MapEntryElement get asMapEntryElement {
    if (node['type'] != 'MapEntryElement') {
      throw StateError('Not a MapEntryElement.');
    }
    return MapEntryElement.fromJson(node['value'] as Map<String, Object?>);
  }

  SpreadElement get asSpreadElement {
    if (node['type'] != 'SpreadElement') {
      throw StateError('Not a SpreadElement.');
    }
    return SpreadElement.fromJson(node['value'] as Map<String, Object?>);
  }

  IfElement get asIfElement {
    if (node['type'] != 'IfElement') {
      throw StateError('Not a IfElement.');
    }
    return IfElement.fromJson(node['value'] as Map<String, Object?>);
  }
}

enum ExpressionType {
  // Private so switches must have a default. See `isKnown`.
  _unknown,
  invalidExpression,
  staticGet,
  functionTearOff,
  constructorTearOff,
  constructorInvocation,
  integerLiteral,
  doubleLiteral,
  booleanLiteral,
  nullLiteral,
  symbolLiteral,
  stringLiteral,
  adjacentStringLiterals,
  implicitInvocation,
  staticInvocation,
  instantiation,
  methodInvocation,
  propertyGet,
  nullAwarePropertyGet,
  typeLiteral,
  parenthesizedExpression,
  conditionalExpression,
  listLiteral,
  setOrMapLiteral,
  recordLiteral,
  ifNull,
  logicalExpression,
  equalityExpression,
  binaryExpression,
  unaryExpression,
  isTest,
  asExpression,
  nullCheck,
  unresolvedExpression;

  bool get isKnown => this != _unknown;
}

extension type Expression.fromJson(Map<String, Object?> node)
    implements Object {
  static Expression invalidExpression(InvalidExpression invalidExpression) =>
      Expression.fromJson({
        'type': 'InvalidExpression',
        'value': invalidExpression,
      });
  static Expression staticGet(StaticGet staticGet) => Expression.fromJson({
        'type': 'StaticGet',
        'value': staticGet,
      });
  static Expression functionTearOff(FunctionTearOff functionTearOff) =>
      Expression.fromJson({
        'type': 'FunctionTearOff',
        'value': functionTearOff,
      });
  static Expression constructorTearOff(ConstructorTearOff constructorTearOff) =>
      Expression.fromJson({
        'type': 'ConstructorTearOff',
        'value': constructorTearOff,
      });
  static Expression constructorInvocation(
          ConstructorInvocation constructorInvocation) =>
      Expression.fromJson({
        'type': 'ConstructorInvocation',
        'value': constructorInvocation,
      });
  static Expression integerLiteral(IntegerLiteral integerLiteral) =>
      Expression.fromJson({
        'type': 'IntegerLiteral',
        'value': integerLiteral,
      });
  static Expression doubleLiteral(DoubleLiteral doubleLiteral) =>
      Expression.fromJson({
        'type': 'DoubleLiteral',
        'value': doubleLiteral,
      });
  static Expression booleanLiteral(BooleanLiteral booleanLiteral) =>
      Expression.fromJson({
        'type': 'BooleanLiteral',
        'value': booleanLiteral,
      });
  static Expression nullLiteral(NullLiteral nullLiteral) =>
      Expression.fromJson({
        'type': 'NullLiteral',
        'value': nullLiteral,
      });
  static Expression symbolLiteral(SymbolLiteral symbolLiteral) =>
      Expression.fromJson({
        'type': 'SymbolLiteral',
        'value': symbolLiteral,
      });
  static Expression stringLiteral(StringLiteral stringLiteral) =>
      Expression.fromJson({
        'type': 'StringLiteral',
        'value': stringLiteral,
      });
  static Expression adjacentStringLiterals(
          AdjacentStringLiterals adjacentStringLiterals) =>
      Expression.fromJson({
        'type': 'AdjacentStringLiterals',
        'value': adjacentStringLiterals,
      });
  static Expression implicitInvocation(ImplicitInvocation implicitInvocation) =>
      Expression.fromJson({
        'type': 'ImplicitInvocation',
        'value': implicitInvocation,
      });
  static Expression staticInvocation(StaticInvocation staticInvocation) =>
      Expression.fromJson({
        'type': 'StaticInvocation',
        'value': staticInvocation,
      });
  static Expression instantiation(Instantiation instantiation) =>
      Expression.fromJson({
        'type': 'Instantiation',
        'value': instantiation,
      });
  static Expression methodInvocation(MethodInvocation methodInvocation) =>
      Expression.fromJson({
        'type': 'MethodInvocation',
        'value': methodInvocation,
      });
  static Expression propertyGet(PropertyGet propertyGet) =>
      Expression.fromJson({
        'type': 'PropertyGet',
        'value': propertyGet,
      });
  static Expression nullAwarePropertyGet(
          NullAwarePropertyGet nullAwarePropertyGet) =>
      Expression.fromJson({
        'type': 'NullAwarePropertyGet',
        'value': nullAwarePropertyGet,
      });
  static Expression typeLiteral(TypeLiteral typeLiteral) =>
      Expression.fromJson({
        'type': 'TypeLiteral',
        'value': typeLiteral,
      });
  static Expression parenthesizedExpression(
          ParenthesizedExpression parenthesizedExpression) =>
      Expression.fromJson({
        'type': 'ParenthesizedExpression',
        'value': parenthesizedExpression,
      });
  static Expression conditionalExpression(
          ConditionalExpression conditionalExpression) =>
      Expression.fromJson({
        'type': 'ConditionalExpression',
        'value': conditionalExpression,
      });
  static Expression listLiteral(ListLiteral listLiteral) =>
      Expression.fromJson({
        'type': 'ListLiteral',
        'value': listLiteral,
      });
  static Expression setOrMapLiteral(SetOrMapLiteral setOrMapLiteral) =>
      Expression.fromJson({
        'type': 'SetOrMapLiteral',
        'value': setOrMapLiteral,
      });
  static Expression recordLiteral(RecordLiteral recordLiteral) =>
      Expression.fromJson({
        'type': 'RecordLiteral',
        'value': recordLiteral,
      });
  static Expression ifNull(IfNull ifNull) => Expression.fromJson({
        'type': 'IfNull',
        'value': ifNull,
      });
  static Expression logicalExpression(LogicalExpression logicalExpression) =>
      Expression.fromJson({
        'type': 'LogicalExpression',
        'value': logicalExpression,
      });
  static Expression equalityExpression(EqualityExpression equalityExpression) =>
      Expression.fromJson({
        'type': 'EqualityExpression',
        'value': equalityExpression,
      });
  static Expression binaryExpression(BinaryExpression binaryExpression) =>
      Expression.fromJson({
        'type': 'BinaryExpression',
        'value': binaryExpression,
      });
  static Expression unaryExpression(UnaryExpression unaryExpression) =>
      Expression.fromJson({
        'type': 'UnaryExpression',
        'value': unaryExpression,
      });
  static Expression isTest(IsTest isTest) => Expression.fromJson({
        'type': 'IsTest',
        'value': isTest,
      });
  static Expression asExpression(AsExpression asExpression) =>
      Expression.fromJson({
        'type': 'AsExpression',
        'value': asExpression,
      });
  static Expression nullCheck(NullCheck nullCheck) => Expression.fromJson({
        'type': 'NullCheck',
        'value': nullCheck,
      });
  static Expression unresolvedExpression(
          UnresolvedExpression unresolvedExpression) =>
      Expression.fromJson({
        'type': 'UnresolvedExpression',
        'value': unresolvedExpression,
      });
  ExpressionType get type {
    switch (node['type'] as String) {
      case 'InvalidExpression':
        return ExpressionType.invalidExpression;
      case 'StaticGet':
        return ExpressionType.staticGet;
      case 'FunctionTearOff':
        return ExpressionType.functionTearOff;
      case 'ConstructorTearOff':
        return ExpressionType.constructorTearOff;
      case 'ConstructorInvocation':
        return ExpressionType.constructorInvocation;
      case 'IntegerLiteral':
        return ExpressionType.integerLiteral;
      case 'DoubleLiteral':
        return ExpressionType.doubleLiteral;
      case 'BooleanLiteral':
        return ExpressionType.booleanLiteral;
      case 'NullLiteral':
        return ExpressionType.nullLiteral;
      case 'SymbolLiteral':
        return ExpressionType.symbolLiteral;
      case 'StringLiteral':
        return ExpressionType.stringLiteral;
      case 'AdjacentStringLiterals':
        return ExpressionType.adjacentStringLiterals;
      case 'ImplicitInvocation':
        return ExpressionType.implicitInvocation;
      case 'StaticInvocation':
        return ExpressionType.staticInvocation;
      case 'Instantiation':
        return ExpressionType.instantiation;
      case 'MethodInvocation':
        return ExpressionType.methodInvocation;
      case 'PropertyGet':
        return ExpressionType.propertyGet;
      case 'NullAwarePropertyGet':
        return ExpressionType.nullAwarePropertyGet;
      case 'TypeLiteral':
        return ExpressionType.typeLiteral;
      case 'ParenthesizedExpression':
        return ExpressionType.parenthesizedExpression;
      case 'ConditionalExpression':
        return ExpressionType.conditionalExpression;
      case 'ListLiteral':
        return ExpressionType.listLiteral;
      case 'SetOrMapLiteral':
        return ExpressionType.setOrMapLiteral;
      case 'RecordLiteral':
        return ExpressionType.recordLiteral;
      case 'IfNull':
        return ExpressionType.ifNull;
      case 'LogicalExpression':
        return ExpressionType.logicalExpression;
      case 'EqualityExpression':
        return ExpressionType.equalityExpression;
      case 'BinaryExpression':
        return ExpressionType.binaryExpression;
      case 'UnaryExpression':
        return ExpressionType.unaryExpression;
      case 'IsTest':
        return ExpressionType.isTest;
      case 'AsExpression':
        return ExpressionType.asExpression;
      case 'NullCheck':
        return ExpressionType.nullCheck;
      case 'UnresolvedExpression':
        return ExpressionType.unresolvedExpression;
      default:
        return ExpressionType._unknown;
    }
  }

  InvalidExpression get asInvalidExpression {
    if (node['type'] != 'InvalidExpression') {
      throw StateError('Not a InvalidExpression.');
    }
    return InvalidExpression.fromJson(node['value'] as Map<String, Object?>);
  }

  StaticGet get asStaticGet {
    if (node['type'] != 'StaticGet') {
      throw StateError('Not a StaticGet.');
    }
    return StaticGet.fromJson(node['value'] as Map<String, Object?>);
  }

  FunctionTearOff get asFunctionTearOff {
    if (node['type'] != 'FunctionTearOff') {
      throw StateError('Not a FunctionTearOff.');
    }
    return FunctionTearOff.fromJson(node['value'] as Map<String, Object?>);
  }

  ConstructorTearOff get asConstructorTearOff {
    if (node['type'] != 'ConstructorTearOff') {
      throw StateError('Not a ConstructorTearOff.');
    }
    return ConstructorTearOff.fromJson(node['value'] as Map<String, Object?>);
  }

  ConstructorInvocation get asConstructorInvocation {
    if (node['type'] != 'ConstructorInvocation') {
      throw StateError('Not a ConstructorInvocation.');
    }
    return ConstructorInvocation.fromJson(
        node['value'] as Map<String, Object?>);
  }

  IntegerLiteral get asIntegerLiteral {
    if (node['type'] != 'IntegerLiteral') {
      throw StateError('Not a IntegerLiteral.');
    }
    return IntegerLiteral.fromJson(node['value'] as Map<String, Object?>);
  }

  DoubleLiteral get asDoubleLiteral {
    if (node['type'] != 'DoubleLiteral') {
      throw StateError('Not a DoubleLiteral.');
    }
    return DoubleLiteral.fromJson(node['value'] as Map<String, Object?>);
  }

  BooleanLiteral get asBooleanLiteral {
    if (node['type'] != 'BooleanLiteral') {
      throw StateError('Not a BooleanLiteral.');
    }
    return BooleanLiteral.fromJson(node['value'] as Map<String, Object?>);
  }

  NullLiteral get asNullLiteral {
    if (node['type'] != 'NullLiteral') {
      throw StateError('Not a NullLiteral.');
    }
    return NullLiteral.fromJson(node['value'] as Map<String, Object?>);
  }

  SymbolLiteral get asSymbolLiteral {
    if (node['type'] != 'SymbolLiteral') {
      throw StateError('Not a SymbolLiteral.');
    }
    return SymbolLiteral.fromJson(node['value'] as Map<String, Object?>);
  }

  StringLiteral get asStringLiteral {
    if (node['type'] != 'StringLiteral') {
      throw StateError('Not a StringLiteral.');
    }
    return StringLiteral.fromJson(node['value'] as Map<String, Object?>);
  }

  AdjacentStringLiterals get asAdjacentStringLiterals {
    if (node['type'] != 'AdjacentStringLiterals') {
      throw StateError('Not a AdjacentStringLiterals.');
    }
    return AdjacentStringLiterals.fromJson(
        node['value'] as Map<String, Object?>);
  }

  ImplicitInvocation get asImplicitInvocation {
    if (node['type'] != 'ImplicitInvocation') {
      throw StateError('Not a ImplicitInvocation.');
    }
    return ImplicitInvocation.fromJson(node['value'] as Map<String, Object?>);
  }

  StaticInvocation get asStaticInvocation {
    if (node['type'] != 'StaticInvocation') {
      throw StateError('Not a StaticInvocation.');
    }
    return StaticInvocation.fromJson(node['value'] as Map<String, Object?>);
  }

  Instantiation get asInstantiation {
    if (node['type'] != 'Instantiation') {
      throw StateError('Not a Instantiation.');
    }
    return Instantiation.fromJson(node['value'] as Map<String, Object?>);
  }

  MethodInvocation get asMethodInvocation {
    if (node['type'] != 'MethodInvocation') {
      throw StateError('Not a MethodInvocation.');
    }
    return MethodInvocation.fromJson(node['value'] as Map<String, Object?>);
  }

  PropertyGet get asPropertyGet {
    if (node['type'] != 'PropertyGet') {
      throw StateError('Not a PropertyGet.');
    }
    return PropertyGet.fromJson(node['value'] as Map<String, Object?>);
  }

  NullAwarePropertyGet get asNullAwarePropertyGet {
    if (node['type'] != 'NullAwarePropertyGet') {
      throw StateError('Not a NullAwarePropertyGet.');
    }
    return NullAwarePropertyGet.fromJson(node['value'] as Map<String, Object?>);
  }

  TypeLiteral get asTypeLiteral {
    if (node['type'] != 'TypeLiteral') {
      throw StateError('Not a TypeLiteral.');
    }
    return TypeLiteral.fromJson(node['value'] as Map<String, Object?>);
  }

  ParenthesizedExpression get asParenthesizedExpression {
    if (node['type'] != 'ParenthesizedExpression') {
      throw StateError('Not a ParenthesizedExpression.');
    }
    return ParenthesizedExpression.fromJson(
        node['value'] as Map<String, Object?>);
  }

  ConditionalExpression get asConditionalExpression {
    if (node['type'] != 'ConditionalExpression') {
      throw StateError('Not a ConditionalExpression.');
    }
    return ConditionalExpression.fromJson(
        node['value'] as Map<String, Object?>);
  }

  ListLiteral get asListLiteral {
    if (node['type'] != 'ListLiteral') {
      throw StateError('Not a ListLiteral.');
    }
    return ListLiteral.fromJson(node['value'] as Map<String, Object?>);
  }

  SetOrMapLiteral get asSetOrMapLiteral {
    if (node['type'] != 'SetOrMapLiteral') {
      throw StateError('Not a SetOrMapLiteral.');
    }
    return SetOrMapLiteral.fromJson(node['value'] as Map<String, Object?>);
  }

  RecordLiteral get asRecordLiteral {
    if (node['type'] != 'RecordLiteral') {
      throw StateError('Not a RecordLiteral.');
    }
    return RecordLiteral.fromJson(node['value'] as Map<String, Object?>);
  }

  IfNull get asIfNull {
    if (node['type'] != 'IfNull') {
      throw StateError('Not a IfNull.');
    }
    return IfNull.fromJson(node['value'] as Map<String, Object?>);
  }

  LogicalExpression get asLogicalExpression {
    if (node['type'] != 'LogicalExpression') {
      throw StateError('Not a LogicalExpression.');
    }
    return LogicalExpression.fromJson(node['value'] as Map<String, Object?>);
  }

  EqualityExpression get asEqualityExpression {
    if (node['type'] != 'EqualityExpression') {
      throw StateError('Not a EqualityExpression.');
    }
    return EqualityExpression.fromJson(node['value'] as Map<String, Object?>);
  }

  BinaryExpression get asBinaryExpression {
    if (node['type'] != 'BinaryExpression') {
      throw StateError('Not a BinaryExpression.');
    }
    return BinaryExpression.fromJson(node['value'] as Map<String, Object?>);
  }

  UnaryExpression get asUnaryExpression {
    if (node['type'] != 'UnaryExpression') {
      throw StateError('Not a UnaryExpression.');
    }
    return UnaryExpression.fromJson(node['value'] as Map<String, Object?>);
  }

  IsTest get asIsTest {
    if (node['type'] != 'IsTest') {
      throw StateError('Not a IsTest.');
    }
    return IsTest.fromJson(node['value'] as Map<String, Object?>);
  }

  AsExpression get asAsExpression {
    if (node['type'] != 'AsExpression') {
      throw StateError('Not a AsExpression.');
    }
    return AsExpression.fromJson(node['value'] as Map<String, Object?>);
  }

  NullCheck get asNullCheck {
    if (node['type'] != 'NullCheck') {
      throw StateError('Not a NullCheck.');
    }
    return NullCheck.fromJson(node['value'] as Map<String, Object?>);
  }

  UnresolvedExpression get asUnresolvedExpression {
    if (node['type'] != 'UnresolvedExpression') {
      throw StateError('Not a UnresolvedExpression.');
    }
    return UnresolvedExpression.fromJson(node['value'] as Map<String, Object?>);
  }
}

enum RecordFieldType {
  // Private so switches must have a default. See `isKnown`.
  _unknown,
  recordNamedField,
  recordPositionalField;

  bool get isKnown => this != _unknown;
}

extension type RecordField.fromJson(Map<String, Object?> node)
    implements Object {
  static RecordField recordNamedField(RecordNamedField recordNamedField) =>
      RecordField.fromJson({
        'type': 'RecordNamedField',
        'value': recordNamedField,
      });
  static RecordField recordPositionalField(
          RecordPositionalField recordPositionalField) =>
      RecordField.fromJson({
        'type': 'RecordPositionalField',
        'value': recordPositionalField,
      });
  RecordFieldType get type {
    switch (node['type'] as String) {
      case 'RecordNamedField':
        return RecordFieldType.recordNamedField;
      case 'RecordPositionalField':
        return RecordFieldType.recordPositionalField;
      default:
        return RecordFieldType._unknown;
    }
  }

  RecordNamedField get asRecordNamedField {
    if (node['type'] != 'RecordNamedField') {
      throw StateError('Not a RecordNamedField.');
    }
    return RecordNamedField.fromJson(node['value'] as Map<String, Object?>);
  }

  RecordPositionalField get asRecordPositionalField {
    if (node['type'] != 'RecordPositionalField') {
      throw StateError('Not a RecordPositionalField.');
    }
    return RecordPositionalField.fromJson(
        node['value'] as Map<String, Object?>);
  }
}

enum ReferenceType {
  // Private so switches must have a default. See `isKnown`.
  _unknown,
  fieldReference,
  functionReference,
  constructorReference,
  typeReference,
  classReference,
  typedefReference,
  extensionReference,
  extensionTypeReference,
  enumReference,
  functionTypeParameterReference;

  bool get isKnown => this != _unknown;
}

extension type Reference.fromJson(Map<String, Object?> node) implements Object {
  static Reference fieldReference(FieldReference fieldReference) =>
      Reference.fromJson({
        'type': 'FieldReference',
        'value': fieldReference,
      });
  static Reference functionReference(FunctionReference functionReference) =>
      Reference.fromJson({
        'type': 'FunctionReference',
        'value': functionReference,
      });
  static Reference constructorReference(
          ConstructorReference constructorReference) =>
      Reference.fromJson({
        'type': 'ConstructorReference',
        'value': constructorReference,
      });
  static Reference typeReference(TypeReference typeReference) =>
      Reference.fromJson({
        'type': 'TypeReference',
        'value': typeReference,
      });
  static Reference classReference(ClassReference classReference) =>
      Reference.fromJson({
        'type': 'ClassReference',
        'value': classReference,
      });
  static Reference typedefReference(TypedefReference typedefReference) =>
      Reference.fromJson({
        'type': 'TypedefReference',
        'value': typedefReference,
      });
  static Reference extensionReference(ExtensionReference extensionReference) =>
      Reference.fromJson({
        'type': 'ExtensionReference',
        'value': extensionReference,
      });
  static Reference extensionTypeReference(
          ExtensionTypeReference extensionTypeReference) =>
      Reference.fromJson({
        'type': 'ExtensionTypeReference',
        'value': extensionTypeReference,
      });
  static Reference enumReference(EnumReference enumReference) =>
      Reference.fromJson({
        'type': 'EnumReference',
        'value': enumReference,
      });
  static Reference functionTypeParameterReference(
          FunctionTypeParameterReference functionTypeParameterReference) =>
      Reference.fromJson({
        'type': 'FunctionTypeParameterReference',
        'value': functionTypeParameterReference,
      });
  ReferenceType get type {
    switch (node['type'] as String) {
      case 'FieldReference':
        return ReferenceType.fieldReference;
      case 'FunctionReference':
        return ReferenceType.functionReference;
      case 'ConstructorReference':
        return ReferenceType.constructorReference;
      case 'TypeReference':
        return ReferenceType.typeReference;
      case 'ClassReference':
        return ReferenceType.classReference;
      case 'TypedefReference':
        return ReferenceType.typedefReference;
      case 'ExtensionReference':
        return ReferenceType.extensionReference;
      case 'ExtensionTypeReference':
        return ReferenceType.extensionTypeReference;
      case 'EnumReference':
        return ReferenceType.enumReference;
      case 'FunctionTypeParameterReference':
        return ReferenceType.functionTypeParameterReference;
      default:
        return ReferenceType._unknown;
    }
  }

  FieldReference get asFieldReference {
    if (node['type'] != 'FieldReference') {
      throw StateError('Not a FieldReference.');
    }
    return FieldReference.fromJson(node['value'] as Map<String, Object?>);
  }

  FunctionReference get asFunctionReference {
    if (node['type'] != 'FunctionReference') {
      throw StateError('Not a FunctionReference.');
    }
    return FunctionReference.fromJson(node['value'] as Map<String, Object?>);
  }

  ConstructorReference get asConstructorReference {
    if (node['type'] != 'ConstructorReference') {
      throw StateError('Not a ConstructorReference.');
    }
    return ConstructorReference.fromJson(node['value'] as Map<String, Object?>);
  }

  TypeReference get asTypeReference {
    if (node['type'] != 'TypeReference') {
      throw StateError('Not a TypeReference.');
    }
    return TypeReference.fromJson(node['value'] as Map<String, Object?>);
  }

  ClassReference get asClassReference {
    if (node['type'] != 'ClassReference') {
      throw StateError('Not a ClassReference.');
    }
    return ClassReference.fromJson(node['value'] as Map<String, Object?>);
  }

  TypedefReference get asTypedefReference {
    if (node['type'] != 'TypedefReference') {
      throw StateError('Not a TypedefReference.');
    }
    return TypedefReference.fromJson(node['value'] as Map<String, Object?>);
  }

  ExtensionReference get asExtensionReference {
    if (node['type'] != 'ExtensionReference') {
      throw StateError('Not a ExtensionReference.');
    }
    return ExtensionReference.fromJson(node['value'] as Map<String, Object?>);
  }

  ExtensionTypeReference get asExtensionTypeReference {
    if (node['type'] != 'ExtensionTypeReference') {
      throw StateError('Not a ExtensionTypeReference.');
    }
    return ExtensionTypeReference.fromJson(
        node['value'] as Map<String, Object?>);
  }

  EnumReference get asEnumReference {
    if (node['type'] != 'EnumReference') {
      throw StateError('Not a EnumReference.');
    }
    return EnumReference.fromJson(node['value'] as Map<String, Object?>);
  }

  FunctionTypeParameterReference get asFunctionTypeParameterReference {
    if (node['type'] != 'FunctionTypeParameterReference') {
      throw StateError('Not a FunctionTypeParameterReference.');
    }
    return FunctionTypeParameterReference.fromJson(
        node['value'] as Map<String, Object?>);
  }
}

enum StringLiteralPartType {
  // Private so switches must have a default. See `isKnown`.
  _unknown,
  stringPart,
  interpolationPart;

  bool get isKnown => this != _unknown;
}

extension type StringLiteralPart.fromJson(Map<String, Object?> node)
    implements Object {
  static StringLiteralPart stringPart(StringPart stringPart) =>
      StringLiteralPart.fromJson({
        'type': 'StringPart',
        'value': stringPart,
      });
  static StringLiteralPart interpolationPart(
          InterpolationPart interpolationPart) =>
      StringLiteralPart.fromJson({
        'type': 'InterpolationPart',
        'value': interpolationPart,
      });
  StringLiteralPartType get type {
    switch (node['type'] as String) {
      case 'StringPart':
        return StringLiteralPartType.stringPart;
      case 'InterpolationPart':
        return StringLiteralPartType.interpolationPart;
      default:
        return StringLiteralPartType._unknown;
    }
  }

  StringPart get asStringPart {
    if (node['type'] != 'StringPart') {
      throw StateError('Not a StringPart.');
    }
    return StringPart.fromJson(node['value'] as Map<String, Object?>);
  }

  InterpolationPart get asInterpolationPart {
    if (node['type'] != 'InterpolationPart') {
      throw StateError('Not a InterpolationPart.');
    }
    return InterpolationPart.fromJson(node['value'] as Map<String, Object?>);
  }
}

enum TypeAnnotationType {
  // Private so switches must have a default. See `isKnown`.
  _unknown,
  namedTypeAnnotation,
  nullableTypeAnnotation,
  voidTypeAnnotation,
  dynamicTypeAnnotation,
  invalidTypeAnnotation,
  unresolvedTypeAnnotation,
  functionTypeAnnotation,
  functionTypeParameterType,
  recordTypeAnnotation;

  bool get isKnown => this != _unknown;
}

extension type TypeAnnotation.fromJson(Map<String, Object?> node)
    implements Object {
  static TypeAnnotation namedTypeAnnotation(
          NamedTypeAnnotation namedTypeAnnotation) =>
      TypeAnnotation.fromJson({
        'type': 'NamedTypeAnnotation',
        'value': namedTypeAnnotation,
      });
  static TypeAnnotation nullableTypeAnnotation(
          NullableTypeAnnotation nullableTypeAnnotation) =>
      TypeAnnotation.fromJson({
        'type': 'NullableTypeAnnotation',
        'value': nullableTypeAnnotation,
      });
  static TypeAnnotation voidTypeAnnotation(
          VoidTypeAnnotation voidTypeAnnotation) =>
      TypeAnnotation.fromJson({
        'type': 'VoidTypeAnnotation',
        'value': voidTypeAnnotation,
      });
  static TypeAnnotation dynamicTypeAnnotation(
          DynamicTypeAnnotation dynamicTypeAnnotation) =>
      TypeAnnotation.fromJson({
        'type': 'DynamicTypeAnnotation',
        'value': dynamicTypeAnnotation,
      });
  static TypeAnnotation invalidTypeAnnotation(
          InvalidTypeAnnotation invalidTypeAnnotation) =>
      TypeAnnotation.fromJson({
        'type': 'InvalidTypeAnnotation',
        'value': invalidTypeAnnotation,
      });
  static TypeAnnotation unresolvedTypeAnnotation(
          UnresolvedTypeAnnotation unresolvedTypeAnnotation) =>
      TypeAnnotation.fromJson({
        'type': 'UnresolvedTypeAnnotation',
        'value': unresolvedTypeAnnotation,
      });
  static TypeAnnotation functionTypeAnnotation(
          FunctionTypeAnnotation functionTypeAnnotation) =>
      TypeAnnotation.fromJson({
        'type': 'FunctionTypeAnnotation',
        'value': functionTypeAnnotation,
      });
  static TypeAnnotation functionTypeParameterType(
          FunctionTypeParameterType functionTypeParameterType) =>
      TypeAnnotation.fromJson({
        'type': 'FunctionTypeParameterType',
        'value': functionTypeParameterType,
      });
  static TypeAnnotation recordTypeAnnotation(
          RecordTypeAnnotation recordTypeAnnotation) =>
      TypeAnnotation.fromJson({
        'type': 'RecordTypeAnnotation',
        'value': recordTypeAnnotation,
      });
  TypeAnnotationType get type {
    switch (node['type'] as String) {
      case 'NamedTypeAnnotation':
        return TypeAnnotationType.namedTypeAnnotation;
      case 'NullableTypeAnnotation':
        return TypeAnnotationType.nullableTypeAnnotation;
      case 'VoidTypeAnnotation':
        return TypeAnnotationType.voidTypeAnnotation;
      case 'DynamicTypeAnnotation':
        return TypeAnnotationType.dynamicTypeAnnotation;
      case 'InvalidTypeAnnotation':
        return TypeAnnotationType.invalidTypeAnnotation;
      case 'UnresolvedTypeAnnotation':
        return TypeAnnotationType.unresolvedTypeAnnotation;
      case 'FunctionTypeAnnotation':
        return TypeAnnotationType.functionTypeAnnotation;
      case 'FunctionTypeParameterType':
        return TypeAnnotationType.functionTypeParameterType;
      case 'RecordTypeAnnotation':
        return TypeAnnotationType.recordTypeAnnotation;
      default:
        return TypeAnnotationType._unknown;
    }
  }

  NamedTypeAnnotation get asNamedTypeAnnotation {
    if (node['type'] != 'NamedTypeAnnotation') {
      throw StateError('Not a NamedTypeAnnotation.');
    }
    return NamedTypeAnnotation.fromJson(node['value'] as Map<String, Object?>);
  }

  NullableTypeAnnotation get asNullableTypeAnnotation {
    if (node['type'] != 'NullableTypeAnnotation') {
      throw StateError('Not a NullableTypeAnnotation.');
    }
    return NullableTypeAnnotation.fromJson(
        node['value'] as Map<String, Object?>);
  }

  VoidTypeAnnotation get asVoidTypeAnnotation {
    if (node['type'] != 'VoidTypeAnnotation') {
      throw StateError('Not a VoidTypeAnnotation.');
    }
    return VoidTypeAnnotation.fromJson(node['value'] as Map<String, Object?>);
  }

  DynamicTypeAnnotation get asDynamicTypeAnnotation {
    if (node['type'] != 'DynamicTypeAnnotation') {
      throw StateError('Not a DynamicTypeAnnotation.');
    }
    return DynamicTypeAnnotation.fromJson(
        node['value'] as Map<String, Object?>);
  }

  InvalidTypeAnnotation get asInvalidTypeAnnotation {
    if (node['type'] != 'InvalidTypeAnnotation') {
      throw StateError('Not a InvalidTypeAnnotation.');
    }
    return InvalidTypeAnnotation.fromJson(
        node['value'] as Map<String, Object?>);
  }

  UnresolvedTypeAnnotation get asUnresolvedTypeAnnotation {
    if (node['type'] != 'UnresolvedTypeAnnotation') {
      throw StateError('Not a UnresolvedTypeAnnotation.');
    }
    return UnresolvedTypeAnnotation.fromJson(
        node['value'] as Map<String, Object?>);
  }

  FunctionTypeAnnotation get asFunctionTypeAnnotation {
    if (node['type'] != 'FunctionTypeAnnotation') {
      throw StateError('Not a FunctionTypeAnnotation.');
    }
    return FunctionTypeAnnotation.fromJson(
        node['value'] as Map<String, Object?>);
  }

  FunctionTypeParameterType get asFunctionTypeParameterType {
    if (node['type'] != 'FunctionTypeParameterType') {
      throw StateError('Not a FunctionTypeParameterType.');
    }
    return FunctionTypeParameterType.fromJson(
        node['value'] as Map<String, Object?>);
  }

  RecordTypeAnnotation get asRecordTypeAnnotation {
    if (node['type'] != 'RecordTypeAnnotation') {
      throw StateError('Not a RecordTypeAnnotation.');
    }
    return RecordTypeAnnotation.fromJson(node['value'] as Map<String, Object?>);
  }
}

///
extension type const BinaryOperator.fromJson(String string) implements Object {
  static const BinaryOperator greaterThan =
      BinaryOperator.fromJson('greaterThan');
  static const BinaryOperator greaterThanOrEqual =
      BinaryOperator.fromJson('greaterThanOrEqual');
  static const BinaryOperator lessThan = BinaryOperator.fromJson('lessThan');
  static const BinaryOperator lessThanOrEqual =
      BinaryOperator.fromJson('lessThanOrEqual');
  static const BinaryOperator shiftLeft = BinaryOperator.fromJson('shiftLeft');
  static const BinaryOperator signedShiftRight =
      BinaryOperator.fromJson('signedShiftRight');
  static const BinaryOperator unsignedShiftRight =
      BinaryOperator.fromJson('unsignedShiftRight');
  static const BinaryOperator plus = BinaryOperator.fromJson('plus');
  static const BinaryOperator minus = BinaryOperator.fromJson('minus');
  static const BinaryOperator times = BinaryOperator.fromJson('times');
  static const BinaryOperator divide = BinaryOperator.fromJson('divide');
  static const BinaryOperator integerDivide =
      BinaryOperator.fromJson('integerDivide');
  static const BinaryOperator modulo = BinaryOperator.fromJson('modulo');
  static const BinaryOperator bitwiseOr = BinaryOperator.fromJson('bitwiseOr');
  static const BinaryOperator bitwiseAnd =
      BinaryOperator.fromJson('bitwiseAnd');
  static const BinaryOperator bitwiseXor =
      BinaryOperator.fromJson('bitwiseXor');
}

///
extension type const LogicalOperator.fromJson(String string) implements Object {
  static const LogicalOperator and = LogicalOperator.fromJson('and');
  static const LogicalOperator or = LogicalOperator.fromJson('or');
}

///
extension type const UnaryOperator.fromJson(String string) implements Object {
  static const UnaryOperator minus = UnaryOperator.fromJson('minus');
  static const UnaryOperator bang = UnaryOperator.fromJson('bang');
  static const UnaryOperator tilde = UnaryOperator.fromJson('tilde');
}

///
extension type AsExpression.fromJson(Map<String, Object?> node)
    implements Object {
  AsExpression({
    Expression? expression,
    TypeAnnotation? type,
  }) : this.fromJson({
          if (expression != null) 'expression': expression,
          if (type != null) 'type': type,
        });

  ///
  Expression get expression => node['expression'] as Expression;

  ///
  TypeAnnotation get type => node['type'] as TypeAnnotation;
}

///
extension type BinaryExpression.fromJson(Map<String, Object?> node)
    implements Object {
  BinaryExpression({
    Expression? left,
    BinaryOperator? operator,
    Expression? right,
  }) : this.fromJson({
          if (left != null) 'left': left,
          if (operator != null) 'operator': operator,
          if (right != null) 'right': right,
        });

  ///
  Expression get left => node['left'] as Expression;

  ///
  BinaryOperator get operator => node['operator'] as BinaryOperator;

  ///
  Expression get right => node['right'] as Expression;
}

///
extension type BooleanLiteral.fromJson(Map<String, Object?> node)
    implements Object {
  BooleanLiteral({
    String? text,
  }) : this.fromJson({
          if (text != null) 'text': text,
        });

  ///
  String get text => node['text'] as String;
}

///
extension type ClassReference.fromJson(Map<String, Object?> node)
    implements Object {
  ClassReference() : this.fromJson({});
}

///
extension type ConditionalExpression.fromJson(Map<String, Object?> node)
    implements Object {
  ConditionalExpression({
    Expression? condition,
    Expression? then,
    Expression? otherwise,
  }) : this.fromJson({
          if (condition != null) 'condition': condition,
          if (then != null) 'then': then,
          if (otherwise != null) 'otherwise': otherwise,
        });

  ///
  Expression get condition => node['condition'] as Expression;

  ///
  Expression get then => node['then'] as Expression;

  ///
  Expression get otherwise => node['otherwise'] as Expression;
}

///
extension type ConstructorInvocation.fromJson(Map<String, Object?> node)
    implements Object {
  ConstructorInvocation({
    TypeAnnotation? type,
    Reference? constructor,
    List<Argument>? arguments,
  }) : this.fromJson({
          if (type != null) 'type': type,
          if (constructor != null) 'constructor': constructor,
          if (arguments != null) 'arguments': arguments,
        });

  ///
  TypeAnnotation get type => node['type'] as TypeAnnotation;

  ///
  Reference get constructor => node['constructor'] as Reference;

  ///
  List<Argument> get arguments => (node['arguments'] as List).cast();
}

///
extension type ConstructorReference.fromJson(Map<String, Object?> node)
    implements Object {
  ConstructorReference() : this.fromJson({});
}

///
extension type ConstructorTearOff.fromJson(Map<String, Object?> node)
    implements Object {
  ConstructorTearOff({
    TypeAnnotation? type,
    ConstructorReference? reference,
  }) : this.fromJson({
          if (type != null) 'type': type,
          if (reference != null) 'reference': reference,
        });

  ///
  TypeAnnotation get type => node['type'] as TypeAnnotation;

  ///
  ConstructorReference get reference =>
      node['reference'] as ConstructorReference;
}

///
extension type DoubleLiteral.fromJson(Map<String, Object?> node)
    implements Object {
  DoubleLiteral({
    String? text,
  }) : this.fromJson({
          if (text != null) 'text': text,
        });

  ///
  String get text => node['text'] as String;
}

///
extension type DynamicTypeAnnotation.fromJson(Map<String, Object?> node)
    implements Object {
  DynamicTypeAnnotation({
    Reference? reference,
  }) : this.fromJson({
          if (reference != null) 'reference': reference,
        });

  ///
  Reference get reference => node['reference'] as Reference;
}

///
extension type EnumReference.fromJson(Map<String, Object?> node)
    implements Object {
  EnumReference() : this.fromJson({});
}

///
extension type EqualityExpression.fromJson(Map<String, Object?> node)
    implements Object {
  EqualityExpression({
    Expression? left,
    Expression? right,
    bool? isNotEquals,
  }) : this.fromJson({
          if (left != null) 'left': left,
          if (right != null) 'right': right,
          if (isNotEquals != null) 'isNotEquals': isNotEquals,
        });

  ///
  Expression get left => node['left'] as Expression;

  ///
  Expression get right => node['right'] as Expression;

  ///
  bool get isNotEquals => node['isNotEquals'] as bool;
}

///
extension type ExpressionElement.fromJson(Map<String, Object?> node)
    implements Object {
  ExpressionElement({
    Expression? expression,
    bool? isNullAware,
  }) : this.fromJson({
          if (expression != null) 'expression': expression,
          if (isNullAware != null) 'isNullAware': isNullAware,
        });

  ///
  Expression get expression => node['expression'] as Expression;

  ///
  bool get isNullAware => node['isNullAware'] as bool;
}

///
extension type ExtensionReference.fromJson(Map<String, Object?> node)
    implements Object {
  ExtensionReference() : this.fromJson({});
}

///
extension type ExtensionTypeReference.fromJson(Map<String, Object?> node)
    implements Object {
  ExtensionTypeReference() : this.fromJson({});
}

///
extension type FieldReference.fromJson(Map<String, Object?> node)
    implements Object {
  FieldReference() : this.fromJson({});
}

///
extension type FormalParameter.fromJson(Map<String, Object?> node)
    implements Object {
  FormalParameter() : this.fromJson({});
}

///
extension type FormalParameterGroup.fromJson(Map<String, Object?> node)
    implements Object {
  FormalParameterGroup() : this.fromJson({});
}

///
extension type FunctionReference.fromJson(Map<String, Object?> node)
    implements Object {
  FunctionReference() : this.fromJson({});
}

///
extension type FunctionTearOff.fromJson(Map<String, Object?> node)
    implements Object {
  FunctionTearOff({
    FunctionReference? reference,
  }) : this.fromJson({
          if (reference != null) 'reference': reference,
        });

  ///
  FunctionReference get reference => node['reference'] as FunctionReference;
}

///
extension type FunctionTypeAnnotation.fromJson(Map<String, Object?> node)
    implements Object {
  FunctionTypeAnnotation({
    TypeAnnotation? returnType,
    List<FunctionTypeParameter>? typeParameters,
    List<FormalParameter>? formalParameters,
  }) : this.fromJson({
          if (returnType != null) 'returnType': returnType,
          if (typeParameters != null) 'typeParameters': typeParameters,
          if (formalParameters != null) 'formalParameters': formalParameters,
        });

  ///
  TypeAnnotation? get returnType => node['returnType'] as TypeAnnotation?;

  ///
  List<FunctionTypeParameter> get typeParameters =>
      (node['typeParameters'] as List).cast();

  ///
  List<FormalParameter> get formalParameters =>
      (node['formalParameters'] as List).cast();
}

///
extension type FunctionTypeParameter.fromJson(Map<String, Object?> node)
    implements Object {
  FunctionTypeParameter() : this.fromJson({});
}

///
extension type FunctionTypeParameterReference.fromJson(
    Map<String, Object?> node) implements Object {
  FunctionTypeParameterReference() : this.fromJson({});
}

///
extension type FunctionTypeParameterType.fromJson(Map<String, Object?> node)
    implements Object {
  FunctionTypeParameterType({
    FunctionTypeParameter? functionTypeParameter,
  }) : this.fromJson({
          if (functionTypeParameter != null)
            'functionTypeParameter': functionTypeParameter,
        });

  ///
  FunctionTypeParameter get functionTypeParameter =>
      node['functionTypeParameter'] as FunctionTypeParameter;
}

///
extension type IfElement.fromJson(Map<String, Object?> node) implements Object {
  IfElement({
    Expression? condition,
    Element? then,
    Element? otherwise,
  }) : this.fromJson({
          if (condition != null) 'condition': condition,
          if (then != null) 'then': then,
          if (otherwise != null) 'otherwise': otherwise,
        });

  ///
  Expression get condition => node['condition'] as Expression;

  ///
  Element get then => node['then'] as Element;

  ///
  Element? get otherwise => node['otherwise'] as Element?;
}

///
extension type IfNull.fromJson(Map<String, Object?> node) implements Object {
  IfNull({
    Expression? left,
    Expression? right,
  }) : this.fromJson({
          if (left != null) 'left': left,
          if (right != null) 'right': right,
        });

  ///
  Expression get left => node['left'] as Expression;

  ///
  Expression get right => node['right'] as Expression;
}

///
extension type ImplicitInvocation.fromJson(Map<String, Object?> node)
    implements Object {
  ImplicitInvocation({
    Expression? receiver,
    List<TypeAnnotation>? typeArguments,
    List<Argument>? arguments,
  }) : this.fromJson({
          if (receiver != null) 'receiver': receiver,
          if (typeArguments != null) 'typeArguments': typeArguments,
          if (arguments != null) 'arguments': arguments,
        });

  ///
  Expression get receiver => node['receiver'] as Expression;

  ///
  List<TypeAnnotation> get typeArguments =>
      (node['typeArguments'] as List).cast();

  ///
  List<Argument> get arguments => (node['arguments'] as List).cast();
}

///
extension type Instantiation.fromJson(Map<String, Object?> node)
    implements Object {
  Instantiation({
    Expression? receiver,
    List<TypeAnnotation>? typeArguments,
  }) : this.fromJson({
          if (receiver != null) 'receiver': receiver,
          if (typeArguments != null) 'typeArguments': typeArguments,
        });

  ///
  Expression get receiver => node['receiver'] as Expression;

  ///
  List<TypeAnnotation> get typeArguments =>
      (node['typeArguments'] as List).cast();
}

///
extension type IntegerLiteral.fromJson(Map<String, Object?> node)
    implements Object {
  IntegerLiteral({
    String? text,
  }) : this.fromJson({
          if (text != null) 'text': text,
        });

  ///
  String get text => node['text'] as String;
}

///
extension type InterpolationPart.fromJson(Map<String, Object?> node)
    implements Object {
  InterpolationPart({
    Expression? expression,
  }) : this.fromJson({
          if (expression != null) 'expression': expression,
        });

  ///
  Expression get expression => node['expression'] as Expression;
}

///
extension type InvalidExpression.fromJson(Map<String, Object?> node)
    implements Object {
  InvalidExpression() : this.fromJson({});
}

///
extension type InvalidTypeAnnotation.fromJson(Map<String, Object?> node)
    implements Object {
  InvalidTypeAnnotation() : this.fromJson({});
}

///
extension type IsTest.fromJson(Map<String, Object?> node) implements Object {
  IsTest({
    Expression? expression,
    TypeAnnotation? type,
    bool? isNot,
  }) : this.fromJson({
          if (expression != null) 'expression': expression,
          if (type != null) 'type': type,
          if (isNot != null) 'isNot': isNot,
        });

  ///
  Expression get expression => node['expression'] as Expression;

  ///
  TypeAnnotation get type => node['type'] as TypeAnnotation;

  ///
  bool get isNot => node['isNot'] as bool;
}

///
extension type ListLiteral.fromJson(Map<String, Object?> node)
    implements Object {
  ListLiteral({
    List<TypeAnnotation>? typeArguments,
    List<Element>? elements,
  }) : this.fromJson({
          if (typeArguments != null) 'typeArguments': typeArguments,
          if (elements != null) 'elements': elements,
        });

  ///
  List<TypeAnnotation> get typeArguments =>
      (node['typeArguments'] as List).cast();

  ///
  List<Element> get elements => (node['elements'] as List).cast();
}

///
extension type LogicalExpression.fromJson(Map<String, Object?> node)
    implements Object {
  LogicalExpression({
    Expression? left,
    LogicalOperator? operator,
    Expression? right,
  }) : this.fromJson({
          if (left != null) 'left': left,
          if (operator != null) 'operator': operator,
          if (right != null) 'right': right,
        });

  ///
  Expression get left => node['left'] as Expression;

  ///
  LogicalOperator get operator => node['operator'] as LogicalOperator;

  ///
  Expression get right => node['right'] as Expression;
}

///
extension type MapEntryElement.fromJson(Map<String, Object?> node)
    implements Object {
  MapEntryElement({
    Expression? key,
    Expression? value,
    bool? isNullAwareKey,
    bool? isNullAwareValue,
  }) : this.fromJson({
          if (key != null) 'key': key,
          if (value != null) 'value': value,
          if (isNullAwareKey != null) 'isNullAwareKey': isNullAwareKey,
          if (isNullAwareValue != null) 'isNullAwareValue': isNullAwareValue,
        });

  ///
  Expression get key => node['key'] as Expression;

  ///
  Expression get value => node['value'] as Expression;

  ///
  bool get isNullAwareKey => node['isNullAwareKey'] as bool;

  ///
  bool get isNullAwareValue => node['isNullAwareValue'] as bool;
}

///
extension type MethodInvocation.fromJson(Map<String, Object?> node)
    implements Object {
  MethodInvocation({
    Expression? receiver,
    String? name,
    List<TypeAnnotation>? typeArguments,
    List<Argument>? arguments,
  }) : this.fromJson({
          if (receiver != null) 'receiver': receiver,
          if (name != null) 'name': name,
          if (typeArguments != null) 'typeArguments': typeArguments,
          if (arguments != null) 'arguments': arguments,
        });

  ///
  Expression get receiver => node['receiver'] as Expression;

  ///
  String get name => node['name'] as String;

  ///
  List<TypeAnnotation> get typeArguments =>
      (node['typeArguments'] as List).cast();

  ///
  List<Argument> get arguments => (node['arguments'] as List).cast();
}

///
extension type NamedArgument.fromJson(Map<String, Object?> node)
    implements Object {
  NamedArgument({
    String? name,
    Expression? expression,
  }) : this.fromJson({
          if (name != null) 'name': name,
          if (expression != null) 'expression': expression,
        });

  ///
  String get name => node['name'] as String;

  ///
  Expression get expression => node['expression'] as Expression;
}

///
extension type NamedTypeAnnotation.fromJson(Map<String, Object?> node)
    implements Object {
  NamedTypeAnnotation({
    Reference? reference,
    List<TypeAnnotation>? typeArguments,
  }) : this.fromJson({
          if (reference != null) 'reference': reference,
          if (typeArguments != null) 'typeArguments': typeArguments,
        });

  ///
  Reference get reference => node['reference'] as Reference;

  ///
  List<TypeAnnotation> get typeArguments =>
      (node['typeArguments'] as List).cast();
}

///
extension type NullableTypeAnnotation.fromJson(Map<String, Object?> node)
    implements Object {
  NullableTypeAnnotation({
    TypeAnnotation? typeAnnotation,
  }) : this.fromJson({
          if (typeAnnotation != null) 'typeAnnotation': typeAnnotation,
        });

  ///
  TypeAnnotation get typeAnnotation => node['typeAnnotation'] as TypeAnnotation;
}

///
extension type NullAwarePropertyGet.fromJson(Map<String, Object?> node)
    implements Object {
  NullAwarePropertyGet({
    Expression? receiver,
    String? name,
  }) : this.fromJson({
          if (receiver != null) 'receiver': receiver,
          if (name != null) 'name': name,
        });

  ///
  Expression get receiver => node['receiver'] as Expression;

  ///
  String get name => node['name'] as String;
}

///
extension type NullCheck.fromJson(Map<String, Object?> node) implements Object {
  NullCheck({
    Expression? expression,
  }) : this.fromJson({
          if (expression != null) 'expression': expression,
        });

  ///
  Expression get expression => node['expression'] as Expression;
}

///
extension type NullLiteral.fromJson(Map<String, Object?> node)
    implements Object {
  NullLiteral() : this.fromJson({});
}

///
extension type ParenthesizedExpression.fromJson(Map<String, Object?> node)
    implements Object {
  ParenthesizedExpression({
    Expression? expression,
  }) : this.fromJson({
          if (expression != null) 'expression': expression,
        });

  ///
  Expression get expression => node['expression'] as Expression;
}

///
extension type PositionalArgument.fromJson(Map<String, Object?> node)
    implements Object {
  PositionalArgument({
    Expression? expression,
  }) : this.fromJson({
          if (expression != null) 'expression': expression,
        });

  ///
  Expression get expression => node['expression'] as Expression;
}

///
extension type PropertyGet.fromJson(Map<String, Object?> node)
    implements Object {
  PropertyGet({
    Expression? receiver,
    String? name,
  }) : this.fromJson({
          if (receiver != null) 'receiver': receiver,
          if (name != null) 'name': name,
        });

  ///
  Expression get receiver => node['receiver'] as Expression;

  ///
  String get name => node['name'] as String;
}

///
extension type RecordLiteral.fromJson(Map<String, Object?> node)
    implements Object {
  RecordLiteral({
    List<RecordField>? fields,
  }) : this.fromJson({
          if (fields != null) 'fields': fields,
        });

  ///
  List<RecordField> get fields => (node['fields'] as List).cast();
}

///
extension type RecordNamedField.fromJson(Map<String, Object?> node)
    implements Object {
  RecordNamedField({
    String? name,
    Expression? expression,
  }) : this.fromJson({
          if (name != null) 'name': name,
          if (expression != null) 'expression': expression,
        });

  ///
  String get name => node['name'] as String;

  ///
  Expression get expression => node['expression'] as Expression;
}

///
extension type RecordPositionalField.fromJson(Map<String, Object?> node)
    implements Object {
  RecordPositionalField({
    Expression? expression,
  }) : this.fromJson({
          if (expression != null) 'expression': expression,
        });

  ///
  Expression get expression => node['expression'] as Expression;
}

///
extension type RecordTypeAnnotation.fromJson(Map<String, Object?> node)
    implements Object {
  RecordTypeAnnotation({
    List<RecordTypeEntry>? positional,
    List<RecordTypeEntry>? named,
  }) : this.fromJson({
          if (positional != null) 'positional': positional,
          if (named != null) 'named': named,
        });

  ///
  List<RecordTypeEntry> get positional => (node['positional'] as List).cast();

  ///
  List<RecordTypeEntry> get named => (node['named'] as List).cast();
}

///
extension type RecordTypeEntry.fromJson(Map<String, Object?> node)
    implements Object {
  RecordTypeEntry() : this.fromJson({});
}

///
extension type References.fromJson(Map<String, Object?> node)
    implements Object {
  References() : this.fromJson({});
}

///
extension type SetOrMapLiteral.fromJson(Map<String, Object?> node)
    implements Object {
  SetOrMapLiteral({
    List<TypeAnnotation>? typeArguments,
    List<Element>? elements,
  }) : this.fromJson({
          if (typeArguments != null) 'typeArguments': typeArguments,
          if (elements != null) 'elements': elements,
        });

  ///
  List<TypeAnnotation> get typeArguments =>
      (node['typeArguments'] as List).cast();

  ///
  List<Element> get elements => (node['elements'] as List).cast();
}

///
extension type SpreadElement.fromJson(Map<String, Object?> node)
    implements Object {
  SpreadElement({
    Expression? expression,
    bool? isNullAware,
  }) : this.fromJson({
          if (expression != null) 'expression': expression,
          if (isNullAware != null) 'isNullAware': isNullAware,
        });

  ///
  Expression get expression => node['expression'] as Expression;

  ///
  bool get isNullAware => node['isNullAware'] as bool;
}

///
extension type StaticGet.fromJson(Map<String, Object?> node) implements Object {
  StaticGet({
    FieldReference? reference,
  }) : this.fromJson({
          if (reference != null) 'reference': reference,
        });

  ///
  FieldReference get reference => node['reference'] as FieldReference;
}

///
extension type StaticInvocation.fromJson(Map<String, Object?> node)
    implements Object {
  StaticInvocation({
    FunctionReference? function,
    List<TypeAnnotation>? typeArguments,
    List<Argument>? arguments,
  }) : this.fromJson({
          if (function != null) 'function': function,
          if (typeArguments != null) 'typeArguments': typeArguments,
          if (arguments != null) 'arguments': arguments,
        });

  ///
  FunctionReference get function => node['function'] as FunctionReference;

  ///
  List<TypeAnnotation> get typeArguments =>
      (node['typeArguments'] as List).cast();

  ///
  List<Argument> get arguments => (node['arguments'] as List).cast();
}

///
extension type AdjacentStringLiterals.fromJson(Map<String, Object?> node)
    implements Object {
  AdjacentStringLiterals({
    List<Expression>? expressions,
  }) : this.fromJson({
          if (expressions != null) 'expressions': expressions,
        });

  ///
  List<Expression> get expressions => (node['expressions'] as List).cast();
}

///
extension type StringLiteral.fromJson(Map<String, Object?> node)
    implements Object {
  StringLiteral({
    List<StringLiteralPart>? parts,
  }) : this.fromJson({
          if (parts != null) 'parts': parts,
        });

  ///
  List<StringLiteralPart> get parts => (node['parts'] as List).cast();
}

///
extension type StringPart.fromJson(Map<String, Object?> node)
    implements Object {
  StringPart({
    String? text,
  }) : this.fromJson({
          if (text != null) 'text': text,
        });

  ///
  String get text => node['text'] as String;
}

///
extension type SymbolLiteral.fromJson(Map<String, Object?> node)
    implements Object {
  SymbolLiteral({
    List<String>? parts,
  }) : this.fromJson({
          if (parts != null) 'parts': parts,
        });

  ///
  List<String> get parts => (node['parts'] as List).cast();
}

///
extension type TypedefReference.fromJson(Map<String, Object?> node)
    implements Object {
  TypedefReference() : this.fromJson({});
}

///
extension type TypeLiteral.fromJson(Map<String, Object?> node)
    implements Object {
  TypeLiteral({
    TypeAnnotation? typeAnnotation,
  }) : this.fromJson({
          if (typeAnnotation != null) 'typeAnnotation': typeAnnotation,
        });

  ///
  TypeAnnotation get typeAnnotation => node['typeAnnotation'] as TypeAnnotation;
}

///
extension type TypeReference.fromJson(Map<String, Object?> node)
    implements Object {
  TypeReference() : this.fromJson({});
}

///
extension type UnaryExpression.fromJson(Map<String, Object?> node)
    implements Object {
  UnaryExpression({
    UnaryOperator? operator,
    Expression? expression,
  }) : this.fromJson({
          if (operator != null) 'operator': operator,
          if (expression != null) 'expression': expression,
        });

  ///
  UnaryOperator get operator => node['operator'] as UnaryOperator;

  ///
  Expression get expression => node['expression'] as Expression;
}

///
extension type UnresolvedExpression.fromJson(Map<String, Object?> node)
    implements Object {
  UnresolvedExpression() : this.fromJson({});
}

///
extension type UnresolvedTypeAnnotation.fromJson(Map<String, Object?> node)
    implements Object {
  UnresolvedTypeAnnotation() : this.fromJson({});
}

///
extension type VoidTypeAnnotation.fromJson(Map<String, Object?> node)
    implements Object {
  VoidTypeAnnotation({
    Reference? reference,
  }) : this.fromJson({
          if (reference != null) 'reference': reference,
        });

  ///
  Reference get reference => node['reference'] as Reference;
}
