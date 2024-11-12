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
  static final TypedMapSchema _schema = TypedMapSchema({
    'type': Type.stringPointer,
    'value': Type.anyPointer,
  });
  static Argument positionalArgument(PositionalArgument positionalArgument) =>
      Argument.fromJson(
        Scope.createMap(_schema, 'PositionalArgument', positionalArgument),
      );
  static Argument namedArgument(NamedArgument namedArgument) =>
      Argument.fromJson(
        Scope.createMap(_schema, 'NamedArgument', namedArgument),
      );
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
  static final TypedMapSchema _schema = TypedMapSchema({
    'type': Type.stringPointer,
    'value': Type.anyPointer,
  });
  static Element expressionElement(ExpressionElement expressionElement) =>
      Element.fromJson(
        Scope.createMap(_schema, 'ExpressionElement', expressionElement),
      );
  static Element mapEntryElement(MapEntryElement mapEntryElement) =>
      Element.fromJson(
        Scope.createMap(_schema, 'MapEntryElement', mapEntryElement),
      );
  static Element spreadElement(SpreadElement spreadElement) => Element.fromJson(
    Scope.createMap(_schema, 'SpreadElement', spreadElement),
  );
  static Element ifElement(IfElement ifElement) =>
      Element.fromJson(Scope.createMap(_schema, 'IfElement', ifElement));
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
  static final TypedMapSchema _schema = TypedMapSchema({
    'type': Type.stringPointer,
    'value': Type.anyPointer,
  });
  static Expression invalidExpression(InvalidExpression invalidExpression) =>
      Expression.fromJson(
        Scope.createMap(_schema, 'InvalidExpression', invalidExpression),
      );
  static Expression staticGet(StaticGet staticGet) =>
      Expression.fromJson(Scope.createMap(_schema, 'StaticGet', staticGet));
  static Expression functionTearOff(FunctionTearOff functionTearOff) =>
      Expression.fromJson(
        Scope.createMap(_schema, 'FunctionTearOff', functionTearOff),
      );
  static Expression constructorTearOff(ConstructorTearOff constructorTearOff) =>
      Expression.fromJson(
        Scope.createMap(_schema, 'ConstructorTearOff', constructorTearOff),
      );
  static Expression constructorInvocation(
    ConstructorInvocation constructorInvocation,
  ) => Expression.fromJson(
    Scope.createMap(_schema, 'ConstructorInvocation', constructorInvocation),
  );
  static Expression integerLiteral(IntegerLiteral integerLiteral) =>
      Expression.fromJson(
        Scope.createMap(_schema, 'IntegerLiteral', integerLiteral),
      );
  static Expression doubleLiteral(DoubleLiteral doubleLiteral) =>
      Expression.fromJson(
        Scope.createMap(_schema, 'DoubleLiteral', doubleLiteral),
      );
  static Expression booleanLiteral(BooleanLiteral booleanLiteral) =>
      Expression.fromJson(
        Scope.createMap(_schema, 'BooleanLiteral', booleanLiteral),
      );
  static Expression nullLiteral(NullLiteral nullLiteral) =>
      Expression.fromJson(Scope.createMap(_schema, 'NullLiteral', nullLiteral));
  static Expression symbolLiteral(SymbolLiteral symbolLiteral) =>
      Expression.fromJson(
        Scope.createMap(_schema, 'SymbolLiteral', symbolLiteral),
      );
  static Expression stringLiteral(StringLiteral stringLiteral) =>
      Expression.fromJson(
        Scope.createMap(_schema, 'StringLiteral', stringLiteral),
      );
  static Expression adjacentStringLiterals(
    AdjacentStringLiterals adjacentStringLiterals,
  ) => Expression.fromJson(
    Scope.createMap(_schema, 'AdjacentStringLiterals', adjacentStringLiterals),
  );
  static Expression implicitInvocation(ImplicitInvocation implicitInvocation) =>
      Expression.fromJson(
        Scope.createMap(_schema, 'ImplicitInvocation', implicitInvocation),
      );
  static Expression staticInvocation(StaticInvocation staticInvocation) =>
      Expression.fromJson(
        Scope.createMap(_schema, 'StaticInvocation', staticInvocation),
      );
  static Expression instantiation(Instantiation instantiation) =>
      Expression.fromJson(
        Scope.createMap(_schema, 'Instantiation', instantiation),
      );
  static Expression methodInvocation(MethodInvocation methodInvocation) =>
      Expression.fromJson(
        Scope.createMap(_schema, 'MethodInvocation', methodInvocation),
      );
  static Expression propertyGet(PropertyGet propertyGet) =>
      Expression.fromJson(Scope.createMap(_schema, 'PropertyGet', propertyGet));
  static Expression nullAwarePropertyGet(
    NullAwarePropertyGet nullAwarePropertyGet,
  ) => Expression.fromJson(
    Scope.createMap(_schema, 'NullAwarePropertyGet', nullAwarePropertyGet),
  );
  static Expression typeLiteral(TypeLiteral typeLiteral) =>
      Expression.fromJson(Scope.createMap(_schema, 'TypeLiteral', typeLiteral));
  static Expression parenthesizedExpression(
    ParenthesizedExpression parenthesizedExpression,
  ) => Expression.fromJson(
    Scope.createMap(
      _schema,
      'ParenthesizedExpression',
      parenthesizedExpression,
    ),
  );
  static Expression conditionalExpression(
    ConditionalExpression conditionalExpression,
  ) => Expression.fromJson(
    Scope.createMap(_schema, 'ConditionalExpression', conditionalExpression),
  );
  static Expression listLiteral(ListLiteral listLiteral) =>
      Expression.fromJson(Scope.createMap(_schema, 'ListLiteral', listLiteral));
  static Expression setOrMapLiteral(SetOrMapLiteral setOrMapLiteral) =>
      Expression.fromJson(
        Scope.createMap(_schema, 'SetOrMapLiteral', setOrMapLiteral),
      );
  static Expression recordLiteral(RecordLiteral recordLiteral) =>
      Expression.fromJson(
        Scope.createMap(_schema, 'RecordLiteral', recordLiteral),
      );
  static Expression ifNull(IfNull ifNull) =>
      Expression.fromJson(Scope.createMap(_schema, 'IfNull', ifNull));
  static Expression logicalExpression(LogicalExpression logicalExpression) =>
      Expression.fromJson(
        Scope.createMap(_schema, 'LogicalExpression', logicalExpression),
      );
  static Expression equalityExpression(EqualityExpression equalityExpression) =>
      Expression.fromJson(
        Scope.createMap(_schema, 'EqualityExpression', equalityExpression),
      );
  static Expression binaryExpression(BinaryExpression binaryExpression) =>
      Expression.fromJson(
        Scope.createMap(_schema, 'BinaryExpression', binaryExpression),
      );
  static Expression unaryExpression(UnaryExpression unaryExpression) =>
      Expression.fromJson(
        Scope.createMap(_schema, 'UnaryExpression', unaryExpression),
      );
  static Expression isTest(IsTest isTest) =>
      Expression.fromJson(Scope.createMap(_schema, 'IsTest', isTest));
  static Expression asExpression(AsExpression asExpression) =>
      Expression.fromJson(
        Scope.createMap(_schema, 'AsExpression', asExpression),
      );
  static Expression nullCheck(NullCheck nullCheck) =>
      Expression.fromJson(Scope.createMap(_schema, 'NullCheck', nullCheck));
  static Expression unresolvedExpression(
    UnresolvedExpression unresolvedExpression,
  ) => Expression.fromJson(
    Scope.createMap(_schema, 'UnresolvedExpression', unresolvedExpression),
  );
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
      node['value'] as Map<String, Object?>,
    );
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
      node['value'] as Map<String, Object?>,
    );
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
      node['value'] as Map<String, Object?>,
    );
  }

  ConditionalExpression get asConditionalExpression {
    if (node['type'] != 'ConditionalExpression') {
      throw StateError('Not a ConditionalExpression.');
    }
    return ConditionalExpression.fromJson(
      node['value'] as Map<String, Object?>,
    );
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
  static final TypedMapSchema _schema = TypedMapSchema({
    'type': Type.stringPointer,
    'value': Type.anyPointer,
  });
  static RecordField recordNamedField(RecordNamedField recordNamedField) =>
      RecordField.fromJson(
        Scope.createMap(_schema, 'RecordNamedField', recordNamedField),
      );
  static RecordField recordPositionalField(
    RecordPositionalField recordPositionalField,
  ) => RecordField.fromJson(
    Scope.createMap(_schema, 'RecordPositionalField', recordPositionalField),
  );
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
      node['value'] as Map<String, Object?>,
    );
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
  static final TypedMapSchema _schema = TypedMapSchema({
    'type': Type.stringPointer,
    'value': Type.anyPointer,
  });
  static Reference fieldReference(FieldReference fieldReference) =>
      Reference.fromJson(
        Scope.createMap(_schema, 'FieldReference', fieldReference),
      );
  static Reference functionReference(FunctionReference functionReference) =>
      Reference.fromJson(
        Scope.createMap(_schema, 'FunctionReference', functionReference),
      );
  static Reference constructorReference(
    ConstructorReference constructorReference,
  ) => Reference.fromJson(
    Scope.createMap(_schema, 'ConstructorReference', constructorReference),
  );
  static Reference typeReference(TypeReference typeReference) =>
      Reference.fromJson(
        Scope.createMap(_schema, 'TypeReference', typeReference),
      );
  static Reference classReference(ClassReference classReference) =>
      Reference.fromJson(
        Scope.createMap(_schema, 'ClassReference', classReference),
      );
  static Reference typedefReference(TypedefReference typedefReference) =>
      Reference.fromJson(
        Scope.createMap(_schema, 'TypedefReference', typedefReference),
      );
  static Reference extensionReference(ExtensionReference extensionReference) =>
      Reference.fromJson(
        Scope.createMap(_schema, 'ExtensionReference', extensionReference),
      );
  static Reference extensionTypeReference(
    ExtensionTypeReference extensionTypeReference,
  ) => Reference.fromJson(
    Scope.createMap(_schema, 'ExtensionTypeReference', extensionTypeReference),
  );
  static Reference enumReference(EnumReference enumReference) =>
      Reference.fromJson(
        Scope.createMap(_schema, 'EnumReference', enumReference),
      );
  static Reference functionTypeParameterReference(
    FunctionTypeParameterReference functionTypeParameterReference,
  ) => Reference.fromJson(
    Scope.createMap(
      _schema,
      'FunctionTypeParameterReference',
      functionTypeParameterReference,
    ),
  );
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
      node['value'] as Map<String, Object?>,
    );
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
      node['value'] as Map<String, Object?>,
    );
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
  static final TypedMapSchema _schema = TypedMapSchema({
    'type': Type.stringPointer,
    'value': Type.anyPointer,
  });
  static StringLiteralPart stringPart(StringPart stringPart) =>
      StringLiteralPart.fromJson(
        Scope.createMap(_schema, 'StringPart', stringPart),
      );
  static StringLiteralPart interpolationPart(
    InterpolationPart interpolationPart,
  ) => StringLiteralPart.fromJson(
    Scope.createMap(_schema, 'InterpolationPart', interpolationPart),
  );
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
  static final TypedMapSchema _schema = TypedMapSchema({
    'type': Type.stringPointer,
    'value': Type.anyPointer,
  });
  static TypeAnnotation namedTypeAnnotation(
    NamedTypeAnnotation namedTypeAnnotation,
  ) => TypeAnnotation.fromJson(
    Scope.createMap(_schema, 'NamedTypeAnnotation', namedTypeAnnotation),
  );
  static TypeAnnotation nullableTypeAnnotation(
    NullableTypeAnnotation nullableTypeAnnotation,
  ) => TypeAnnotation.fromJson(
    Scope.createMap(_schema, 'NullableTypeAnnotation', nullableTypeAnnotation),
  );
  static TypeAnnotation voidTypeAnnotation(
    VoidTypeAnnotation voidTypeAnnotation,
  ) => TypeAnnotation.fromJson(
    Scope.createMap(_schema, 'VoidTypeAnnotation', voidTypeAnnotation),
  );
  static TypeAnnotation dynamicTypeAnnotation(
    DynamicTypeAnnotation dynamicTypeAnnotation,
  ) => TypeAnnotation.fromJson(
    Scope.createMap(_schema, 'DynamicTypeAnnotation', dynamicTypeAnnotation),
  );
  static TypeAnnotation invalidTypeAnnotation(
    InvalidTypeAnnotation invalidTypeAnnotation,
  ) => TypeAnnotation.fromJson(
    Scope.createMap(_schema, 'InvalidTypeAnnotation', invalidTypeAnnotation),
  );
  static TypeAnnotation unresolvedTypeAnnotation(
    UnresolvedTypeAnnotation unresolvedTypeAnnotation,
  ) => TypeAnnotation.fromJson(
    Scope.createMap(
      _schema,
      'UnresolvedTypeAnnotation',
      unresolvedTypeAnnotation,
    ),
  );
  static TypeAnnotation functionTypeAnnotation(
    FunctionTypeAnnotation functionTypeAnnotation,
  ) => TypeAnnotation.fromJson(
    Scope.createMap(_schema, 'FunctionTypeAnnotation', functionTypeAnnotation),
  );
  static TypeAnnotation functionTypeParameterType(
    FunctionTypeParameterType functionTypeParameterType,
  ) => TypeAnnotation.fromJson(
    Scope.createMap(
      _schema,
      'FunctionTypeParameterType',
      functionTypeParameterType,
    ),
  );
  static TypeAnnotation recordTypeAnnotation(
    RecordTypeAnnotation recordTypeAnnotation,
  ) => TypeAnnotation.fromJson(
    Scope.createMap(_schema, 'RecordTypeAnnotation', recordTypeAnnotation),
  );
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
      node['value'] as Map<String, Object?>,
    );
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
      node['value'] as Map<String, Object?>,
    );
  }

  InvalidTypeAnnotation get asInvalidTypeAnnotation {
    if (node['type'] != 'InvalidTypeAnnotation') {
      throw StateError('Not a InvalidTypeAnnotation.');
    }
    return InvalidTypeAnnotation.fromJson(
      node['value'] as Map<String, Object?>,
    );
  }

  UnresolvedTypeAnnotation get asUnresolvedTypeAnnotation {
    if (node['type'] != 'UnresolvedTypeAnnotation') {
      throw StateError('Not a UnresolvedTypeAnnotation.');
    }
    return UnresolvedTypeAnnotation.fromJson(
      node['value'] as Map<String, Object?>,
    );
  }

  FunctionTypeAnnotation get asFunctionTypeAnnotation {
    if (node['type'] != 'FunctionTypeAnnotation') {
      throw StateError('Not a FunctionTypeAnnotation.');
    }
    return FunctionTypeAnnotation.fromJson(
      node['value'] as Map<String, Object?>,
    );
  }

  FunctionTypeParameterType get asFunctionTypeParameterType {
    if (node['type'] != 'FunctionTypeParameterType') {
      throw StateError('Not a FunctionTypeParameterType.');
    }
    return FunctionTypeParameterType.fromJson(
      node['value'] as Map<String, Object?>,
    );
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
  static const BinaryOperator greaterThan = BinaryOperator.fromJson(
    'greaterThan',
  );
  static const BinaryOperator greaterThanOrEqual = BinaryOperator.fromJson(
    'greaterThanOrEqual',
  );
  static const BinaryOperator lessThan = BinaryOperator.fromJson('lessThan');
  static const BinaryOperator lessThanOrEqual = BinaryOperator.fromJson(
    'lessThanOrEqual',
  );
  static const BinaryOperator shiftLeft = BinaryOperator.fromJson('shiftLeft');
  static const BinaryOperator signedShiftRight = BinaryOperator.fromJson(
    'signedShiftRight',
  );
  static const BinaryOperator unsignedShiftRight = BinaryOperator.fromJson(
    'unsignedShiftRight',
  );
  static const BinaryOperator plus = BinaryOperator.fromJson('plus');
  static const BinaryOperator minus = BinaryOperator.fromJson('minus');
  static const BinaryOperator times = BinaryOperator.fromJson('times');
  static const BinaryOperator divide = BinaryOperator.fromJson('divide');
  static const BinaryOperator integerDivide = BinaryOperator.fromJson(
    'integerDivide',
  );
  static const BinaryOperator modulo = BinaryOperator.fromJson('modulo');
  static const BinaryOperator bitwiseOr = BinaryOperator.fromJson('bitwiseOr');
  static const BinaryOperator bitwiseAnd = BinaryOperator.fromJson(
    'bitwiseAnd',
  );
  static const BinaryOperator bitwiseXor = BinaryOperator.fromJson(
    'bitwiseXor',
  );
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
  static final TypedMapSchema _schema = TypedMapSchema({
    'expression': Type.typedMapPointer,
    'type': Type.typedMapPointer,
  });
  AsExpression({Expression? expression, TypeAnnotation? type})
    : this.fromJson(Scope.createMap(_schema, expression, type));

  ///
  Expression get expression => node['expression'] as Expression;

  ///
  TypeAnnotation get type => node['type'] as TypeAnnotation;
}

///
extension type BinaryExpression.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'left': Type.typedMapPointer,
    'operator': Type.stringPointer,
    'right': Type.typedMapPointer,
  });
  BinaryExpression({
    Expression? left,
    BinaryOperator? operator,
    Expression? right,
  }) : this.fromJson(Scope.createMap(_schema, left, operator, right));

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
  static final TypedMapSchema _schema = TypedMapSchema({
    'text': Type.stringPointer,
  });
  BooleanLiteral({String? text})
    : this.fromJson(Scope.createMap(_schema, text));

  ///
  String get text => node['text'] as String;
}

///
extension type ClassReference.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({});
  ClassReference() : this.fromJson(Scope.createMap(_schema));
}

///
extension type ConditionalExpression.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'condition': Type.typedMapPointer,
    'then': Type.typedMapPointer,
    'otherwise': Type.typedMapPointer,
  });
  ConditionalExpression({
    Expression? condition,
    Expression? then,
    Expression? otherwise,
  }) : this.fromJson(Scope.createMap(_schema, condition, then, otherwise));

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
  static final TypedMapSchema _schema = TypedMapSchema({
    'type': Type.typedMapPointer,
    'constructor': Type.typedMapPointer,
    'arguments': Type.closedListPointer,
  });
  ConstructorInvocation({
    TypeAnnotation? type,
    Reference? constructor,
    List<Argument>? arguments,
  }) : this.fromJson(Scope.createMap(_schema, type, constructor, arguments));

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
  static final TypedMapSchema _schema = TypedMapSchema({});
  ConstructorReference() : this.fromJson(Scope.createMap(_schema));
}

///
extension type ConstructorTearOff.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'type': Type.typedMapPointer,
    'reference': Type.typedMapPointer,
  });
  ConstructorTearOff({TypeAnnotation? type, ConstructorReference? reference})
    : this.fromJson(Scope.createMap(_schema, type, reference));

  ///
  TypeAnnotation get type => node['type'] as TypeAnnotation;

  ///
  ConstructorReference get reference =>
      node['reference'] as ConstructorReference;
}

///
extension type DoubleLiteral.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'text': Type.stringPointer,
  });
  DoubleLiteral({String? text}) : this.fromJson(Scope.createMap(_schema, text));

  ///
  String get text => node['text'] as String;
}

///
extension type DynamicTypeAnnotation.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'reference': Type.typedMapPointer,
  });
  DynamicTypeAnnotation({Reference? reference})
    : this.fromJson(Scope.createMap(_schema, reference));

  ///
  Reference get reference => node['reference'] as Reference;
}

///
extension type EnumReference.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({});
  EnumReference() : this.fromJson(Scope.createMap(_schema));
}

///
extension type EqualityExpression.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'left': Type.typedMapPointer,
    'right': Type.typedMapPointer,
    'isNotEquals': Type.boolean,
  });
  EqualityExpression({Expression? left, Expression? right, bool? isNotEquals})
    : this.fromJson(Scope.createMap(_schema, left, right, isNotEquals));

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
  static final TypedMapSchema _schema = TypedMapSchema({
    'expression': Type.typedMapPointer,
    'isNullAware': Type.boolean,
  });
  ExpressionElement({Expression? expression, bool? isNullAware})
    : this.fromJson(Scope.createMap(_schema, expression, isNullAware));

  ///
  Expression get expression => node['expression'] as Expression;

  ///
  bool get isNullAware => node['isNullAware'] as bool;
}

///
extension type ExtensionReference.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({});
  ExtensionReference() : this.fromJson(Scope.createMap(_schema));
}

///
extension type ExtensionTypeReference.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({});
  ExtensionTypeReference() : this.fromJson(Scope.createMap(_schema));
}

///
extension type FieldReference.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({});
  FieldReference() : this.fromJson(Scope.createMap(_schema));
}

///
extension type FormalParameter.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({});
  FormalParameter() : this.fromJson(Scope.createMap(_schema));
}

///
extension type FormalParameterGroup.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({});
  FormalParameterGroup() : this.fromJson(Scope.createMap(_schema));
}

///
extension type FunctionReference.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({});
  FunctionReference() : this.fromJson(Scope.createMap(_schema));
}

///
extension type FunctionTearOff.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'reference': Type.typedMapPointer,
  });
  FunctionTearOff({FunctionReference? reference})
    : this.fromJson(Scope.createMap(_schema, reference));

  ///
  FunctionReference get reference => node['reference'] as FunctionReference;
}

///
extension type FunctionTypeAnnotation.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'returnType': Type.typedMapPointer,
    'typeParameters': Type.closedListPointer,
    'formalParameters': Type.closedListPointer,
  });
  FunctionTypeAnnotation({
    TypeAnnotation? returnType,
    List<FunctionTypeParameter>? typeParameters,
    List<FormalParameter>? formalParameters,
  }) : this.fromJson(
         Scope.createMap(_schema, returnType, typeParameters, formalParameters),
       );

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
  static final TypedMapSchema _schema = TypedMapSchema({});
  FunctionTypeParameter() : this.fromJson(Scope.createMap(_schema));
}

///
extension type FunctionTypeParameterReference.fromJson(
  Map<String, Object?> node
)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({});
  FunctionTypeParameterReference() : this.fromJson(Scope.createMap(_schema));
}

///
extension type FunctionTypeParameterType.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'functionTypeParameter': Type.typedMapPointer,
  });
  FunctionTypeParameterType({FunctionTypeParameter? functionTypeParameter})
    : this.fromJson(Scope.createMap(_schema, functionTypeParameter));

  ///
  FunctionTypeParameter get functionTypeParameter =>
      node['functionTypeParameter'] as FunctionTypeParameter;
}

///
extension type IfElement.fromJson(Map<String, Object?> node) implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'condition': Type.typedMapPointer,
    'then': Type.typedMapPointer,
    'otherwise': Type.typedMapPointer,
  });
  IfElement({Expression? condition, Element? then, Element? otherwise})
    : this.fromJson(Scope.createMap(_schema, condition, then, otherwise));

  ///
  Expression get condition => node['condition'] as Expression;

  ///
  Element get then => node['then'] as Element;

  ///
  Element? get otherwise => node['otherwise'] as Element?;
}

///
extension type IfNull.fromJson(Map<String, Object?> node) implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'left': Type.typedMapPointer,
    'right': Type.typedMapPointer,
  });
  IfNull({Expression? left, Expression? right})
    : this.fromJson(Scope.createMap(_schema, left, right));

  ///
  Expression get left => node['left'] as Expression;

  ///
  Expression get right => node['right'] as Expression;
}

///
extension type ImplicitInvocation.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'receiver': Type.typedMapPointer,
    'typeArguments': Type.closedListPointer,
    'arguments': Type.closedListPointer,
  });
  ImplicitInvocation({
    Expression? receiver,
    List<TypeAnnotation>? typeArguments,
    List<Argument>? arguments,
  }) : this.fromJson(
         Scope.createMap(_schema, receiver, typeArguments, arguments),
       );

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
  static final TypedMapSchema _schema = TypedMapSchema({
    'receiver': Type.typedMapPointer,
    'typeArguments': Type.closedListPointer,
  });
  Instantiation({Expression? receiver, List<TypeAnnotation>? typeArguments})
    : this.fromJson(Scope.createMap(_schema, receiver, typeArguments));

  ///
  Expression get receiver => node['receiver'] as Expression;

  ///
  List<TypeAnnotation> get typeArguments =>
      (node['typeArguments'] as List).cast();
}

///
extension type IntegerLiteral.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'text': Type.stringPointer,
  });
  IntegerLiteral({String? text})
    : this.fromJson(Scope.createMap(_schema, text));

  ///
  String get text => node['text'] as String;
}

///
extension type InterpolationPart.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'expression': Type.typedMapPointer,
  });
  InterpolationPart({Expression? expression})
    : this.fromJson(Scope.createMap(_schema, expression));

  ///
  Expression get expression => node['expression'] as Expression;
}

///
extension type InvalidExpression.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({});
  InvalidExpression() : this.fromJson(Scope.createMap(_schema));
}

///
extension type InvalidTypeAnnotation.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({});
  InvalidTypeAnnotation() : this.fromJson(Scope.createMap(_schema));
}

///
extension type IsTest.fromJson(Map<String, Object?> node) implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'expression': Type.typedMapPointer,
    'type': Type.typedMapPointer,
    'isNot': Type.boolean,
  });
  IsTest({Expression? expression, TypeAnnotation? type, bool? isNot})
    : this.fromJson(Scope.createMap(_schema, expression, type, isNot));

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
  static final TypedMapSchema _schema = TypedMapSchema({
    'typeArguments': Type.closedListPointer,
    'elements': Type.closedListPointer,
  });
  ListLiteral({List<TypeAnnotation>? typeArguments, List<Element>? elements})
    : this.fromJson(Scope.createMap(_schema, typeArguments, elements));

  ///
  List<TypeAnnotation> get typeArguments =>
      (node['typeArguments'] as List).cast();

  ///
  List<Element> get elements => (node['elements'] as List).cast();
}

///
extension type LogicalExpression.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'left': Type.typedMapPointer,
    'operator': Type.stringPointer,
    'right': Type.typedMapPointer,
  });
  LogicalExpression({
    Expression? left,
    LogicalOperator? operator,
    Expression? right,
  }) : this.fromJson(Scope.createMap(_schema, left, operator, right));

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
  static final TypedMapSchema _schema = TypedMapSchema({
    'key': Type.typedMapPointer,
    'value': Type.typedMapPointer,
    'isNullAwareKey': Type.boolean,
    'isNullAwareValue': Type.boolean,
  });
  MapEntryElement({
    Expression? key,
    Expression? value,
    bool? isNullAwareKey,
    bool? isNullAwareValue,
  }) : this.fromJson(
         Scope.createMap(_schema, key, value, isNullAwareKey, isNullAwareValue),
       );

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
  static final TypedMapSchema _schema = TypedMapSchema({
    'receiver': Type.typedMapPointer,
    'name': Type.stringPointer,
    'typeArguments': Type.closedListPointer,
    'arguments': Type.closedListPointer,
  });
  MethodInvocation({
    Expression? receiver,
    String? name,
    List<TypeAnnotation>? typeArguments,
    List<Argument>? arguments,
  }) : this.fromJson(
         Scope.createMap(_schema, receiver, name, typeArguments, arguments),
       );

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
  static final TypedMapSchema _schema = TypedMapSchema({
    'name': Type.stringPointer,
    'expression': Type.typedMapPointer,
  });
  NamedArgument({String? name, Expression? expression})
    : this.fromJson(Scope.createMap(_schema, name, expression));

  ///
  String get name => node['name'] as String;

  ///
  Expression get expression => node['expression'] as Expression;
}

///
extension type NamedTypeAnnotation.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'reference': Type.typedMapPointer,
    'typeArguments': Type.closedListPointer,
  });
  NamedTypeAnnotation({
    Reference? reference,
    List<TypeAnnotation>? typeArguments,
  }) : this.fromJson(Scope.createMap(_schema, reference, typeArguments));

  ///
  Reference get reference => node['reference'] as Reference;

  ///
  List<TypeAnnotation> get typeArguments =>
      (node['typeArguments'] as List).cast();
}

///
extension type NullableTypeAnnotation.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'typeAnnotation': Type.typedMapPointer,
  });
  NullableTypeAnnotation({TypeAnnotation? typeAnnotation})
    : this.fromJson(Scope.createMap(_schema, typeAnnotation));

  ///
  TypeAnnotation get typeAnnotation => node['typeAnnotation'] as TypeAnnotation;
}

///
extension type NullAwarePropertyGet.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'receiver': Type.typedMapPointer,
    'name': Type.stringPointer,
  });
  NullAwarePropertyGet({Expression? receiver, String? name})
    : this.fromJson(Scope.createMap(_schema, receiver, name));

  ///
  Expression get receiver => node['receiver'] as Expression;

  ///
  String get name => node['name'] as String;
}

///
extension type NullCheck.fromJson(Map<String, Object?> node) implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'expression': Type.typedMapPointer,
  });
  NullCheck({Expression? expression})
    : this.fromJson(Scope.createMap(_schema, expression));

  ///
  Expression get expression => node['expression'] as Expression;
}

///
extension type NullLiteral.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({});
  NullLiteral() : this.fromJson(Scope.createMap(_schema));
}

///
extension type ParenthesizedExpression.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'expression': Type.typedMapPointer,
  });
  ParenthesizedExpression({Expression? expression})
    : this.fromJson(Scope.createMap(_schema, expression));

  ///
  Expression get expression => node['expression'] as Expression;
}

///
extension type PositionalArgument.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'expression': Type.typedMapPointer,
  });
  PositionalArgument({Expression? expression})
    : this.fromJson(Scope.createMap(_schema, expression));

  ///
  Expression get expression => node['expression'] as Expression;
}

///
extension type PropertyGet.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'receiver': Type.typedMapPointer,
    'name': Type.stringPointer,
  });
  PropertyGet({Expression? receiver, String? name})
    : this.fromJson(Scope.createMap(_schema, receiver, name));

  ///
  Expression get receiver => node['receiver'] as Expression;

  ///
  String get name => node['name'] as String;
}

///
extension type RecordLiteral.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'fields': Type.closedListPointer,
  });
  RecordLiteral({List<RecordField>? fields})
    : this.fromJson(Scope.createMap(_schema, fields));

  ///
  List<RecordField> get fields => (node['fields'] as List).cast();
}

///
extension type RecordNamedField.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'name': Type.stringPointer,
    'expression': Type.typedMapPointer,
  });
  RecordNamedField({String? name, Expression? expression})
    : this.fromJson(Scope.createMap(_schema, name, expression));

  ///
  String get name => node['name'] as String;

  ///
  Expression get expression => node['expression'] as Expression;
}

///
extension type RecordPositionalField.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'expression': Type.typedMapPointer,
  });
  RecordPositionalField({Expression? expression})
    : this.fromJson(Scope.createMap(_schema, expression));

  ///
  Expression get expression => node['expression'] as Expression;
}

///
extension type RecordTypeAnnotation.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'positional': Type.closedListPointer,
    'named': Type.closedListPointer,
  });
  RecordTypeAnnotation({
    List<RecordTypeEntry>? positional,
    List<RecordTypeEntry>? named,
  }) : this.fromJson(Scope.createMap(_schema, positional, named));

  ///
  List<RecordTypeEntry> get positional => (node['positional'] as List).cast();

  ///
  List<RecordTypeEntry> get named => (node['named'] as List).cast();
}

///
extension type RecordTypeEntry.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({});
  RecordTypeEntry() : this.fromJson(Scope.createMap(_schema));
}

///
extension type References.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({});
  References() : this.fromJson(Scope.createMap(_schema));
}

///
extension type SetOrMapLiteral.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'typeArguments': Type.closedListPointer,
    'elements': Type.closedListPointer,
  });
  SetOrMapLiteral({
    List<TypeAnnotation>? typeArguments,
    List<Element>? elements,
  }) : this.fromJson(Scope.createMap(_schema, typeArguments, elements));

  ///
  List<TypeAnnotation> get typeArguments =>
      (node['typeArguments'] as List).cast();

  ///
  List<Element> get elements => (node['elements'] as List).cast();
}

///
extension type SpreadElement.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'expression': Type.typedMapPointer,
    'isNullAware': Type.boolean,
  });
  SpreadElement({Expression? expression, bool? isNullAware})
    : this.fromJson(Scope.createMap(_schema, expression, isNullAware));

  ///
  Expression get expression => node['expression'] as Expression;

  ///
  bool get isNullAware => node['isNullAware'] as bool;
}

///
extension type StaticGet.fromJson(Map<String, Object?> node) implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'reference': Type.typedMapPointer,
  });
  StaticGet({FieldReference? reference})
    : this.fromJson(Scope.createMap(_schema, reference));

  ///
  FieldReference get reference => node['reference'] as FieldReference;
}

///
extension type StaticInvocation.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'function': Type.typedMapPointer,
    'typeArguments': Type.closedListPointer,
    'arguments': Type.closedListPointer,
  });
  StaticInvocation({
    FunctionReference? function,
    List<TypeAnnotation>? typeArguments,
    List<Argument>? arguments,
  }) : this.fromJson(
         Scope.createMap(_schema, function, typeArguments, arguments),
       );

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
  static final TypedMapSchema _schema = TypedMapSchema({
    'expressions': Type.closedListPointer,
  });
  AdjacentStringLiterals({List<Expression>? expressions})
    : this.fromJson(Scope.createMap(_schema, expressions));

  ///
  List<Expression> get expressions => (node['expressions'] as List).cast();
}

///
extension type StringLiteral.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'parts': Type.closedListPointer,
  });
  StringLiteral({List<StringLiteralPart>? parts})
    : this.fromJson(Scope.createMap(_schema, parts));

  ///
  List<StringLiteralPart> get parts => (node['parts'] as List).cast();
}

///
extension type StringPart.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'text': Type.stringPointer,
  });
  StringPart({String? text}) : this.fromJson(Scope.createMap(_schema, text));

  ///
  String get text => node['text'] as String;
}

///
extension type SymbolLiteral.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'parts': Type.closedListPointer,
  });
  SymbolLiteral({List<String>? parts})
    : this.fromJson(Scope.createMap(_schema, parts));

  ///
  List<String> get parts => (node['parts'] as List).cast();
}

///
extension type TypedefReference.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({});
  TypedefReference() : this.fromJson(Scope.createMap(_schema));
}

///
extension type TypeLiteral.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'typeAnnotation': Type.typedMapPointer,
  });
  TypeLiteral({TypeAnnotation? typeAnnotation})
    : this.fromJson(Scope.createMap(_schema, typeAnnotation));

  ///
  TypeAnnotation get typeAnnotation => node['typeAnnotation'] as TypeAnnotation;
}

///
extension type TypeReference.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({});
  TypeReference() : this.fromJson(Scope.createMap(_schema));
}

///
extension type UnaryExpression.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'operator': Type.stringPointer,
    'expression': Type.typedMapPointer,
  });
  UnaryExpression({UnaryOperator? operator, Expression? expression})
    : this.fromJson(Scope.createMap(_schema, operator, expression));

  ///
  UnaryOperator get operator => node['operator'] as UnaryOperator;

  ///
  Expression get expression => node['expression'] as Expression;
}

///
extension type UnresolvedExpression.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({});
  UnresolvedExpression() : this.fromJson(Scope.createMap(_schema));
}

///
extension type UnresolvedTypeAnnotation.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({});
  UnresolvedTypeAnnotation() : this.fromJson(Scope.createMap(_schema));
}

///
extension type VoidTypeAnnotation.fromJson(Map<String, Object?> node)
    implements Object {
  static final TypedMapSchema _schema = TypedMapSchema({
    'reference': Type.typedMapPointer,
  });
  VoidTypeAnnotation({Reference? reference})
    : this.fromJson(Scope.createMap(_schema, reference));

  ///
  Reference get reference => node['reference'] as Reference;
}
