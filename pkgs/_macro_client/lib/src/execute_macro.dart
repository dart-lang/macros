// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:dart_model/dart_model.dart';
import 'package:macro/macro.dart';
import 'package:macro_service/macro_service.dart';

/// Runs [macro] in the types phase and returns an [AugmentResponse].
Future<AugmentResponse> executeTypesMacro(
    Macro macro, Host host, AugmentRequest request) async {
  final target = request.target;
  // TODO: https://github.com/dart-lang/macros/issues/100.
  final queryResult = await host.query(Query(target: target));
  final interface = queryResult.uris[target.uri]!.scopes[target.name]!;

  switch ((interface.properties, macro)) {
    case (Properties(isClass: true), ClassTypesMacro macro):
      return await macro.buildTypesForClass(interface, queryResult, host);
    case (_, LibraryTypesMacro()):
    case (_, ConstructorTypesMacro()):
    case (_, MethodTypesMacro()):
    case (_, FunctionTypesMacro()):
    case (_, FieldTypesMacro()):
    case (_, VariableTypesMacro()):
    case (_, EnumTypesMacro()):
    case (_, ExtensionTypesMacro()):
    case (_, ExtensionTypeTypesMacro()):
    case (_, MixinTypesMacro()):
    case (_, EnumValueTypesMacro()):
    case (_, TypeAliasTypesMacro()):
      throw UnimplementedError('Unimplemented macro target');
    default:
      throw UnsupportedError('Unsupported macro type or invalid target:\n'
          'macro: $macro\ntarget: $target');
  }
}

/// Runs [macro] in the declarations phase and returns an [AugmentResponse].
Future<AugmentResponse> executeDeclarationsMacro(
    Macro macro, Host host, AugmentRequest request) async {
  final target = request.target;
  // TODO: https://github.com/dart-lang/macros/issues/100.
  final queryResult = await host.query(Query(target: target));
  final interface = queryResult.uris[target.uri]!.scopes[target.name]!;

  switch ((interface.properties, macro)) {
    case (Properties(isClass: true), ClassDeclarationsMacro macro):
      return await macro.buildDeclarationsForClass(
          interface, queryResult, host);
    case (_, LibraryDeclarationsMacro()):
    case (_, EnumDeclarationsMacro()):
    case (_, ExtensionDeclarationsMacro()):
    case (_, ExtensionTypeDeclarationsMacro()):
    case (_, MixinDeclarationsMacro()):
    case (_, EnumValueDeclarationsMacro()):
    case (_, ConstructorDeclarationsMacro()):
    case (_, MethodDeclarationsMacro()):
    case (_, FieldDeclarationsMacro()):
    case (_, FunctionDeclarationsMacro()):
    case (_, VariableDeclarationsMacro()):
    case (_, TypeAliasDeclarationsMacro()):
      throw UnimplementedError('Unimplemented macro target');
    default:
      throw UnsupportedError('Unsupported macro type or invalid target:\n'
          'macro: $macro\ntarget: $target');
  }
}

/// Runs [macro] in the definitions phase and returns an [AugmentResponse].
Future<AugmentResponse> executeDefinitionsMacro(
    Macro macro, Host host, AugmentRequest request) async {
  final target = request.target;
  // TODO: https://github.com/dart-lang/macros/issues/100.
  final queryResult = await host.query(Query(target: target));
  final interface = queryResult.uris[target.uri]!.scopes[target.name]!;

  switch ((interface.properties, macro)) {
    case (Properties(isClass: true), ClassDefinitionsMacro macro):
      return await macro.buildDefinitionsForClass(interface, queryResult, host);
    case (_, LibraryDefinitionsMacro()):
    case (_, EnumDefinitionsMacro()):
    case (_, ExtensionDefinitionsMacro()):
    case (_, ExtensionTypeDefinitionsMacro()):
    case (_, MixinDefinitionsMacro()):
    case (_, EnumValueDefinitionsMacro()):
    case (_, ConstructorDefinitionsMacro()):
    case (_, MethodDefinitionsMacro()):
    case (_, FieldDefinitionsMacro()):
    case (_, FunctionDefinitionsMacro()):
    case (_, VariableDefinitionsMacro()):
      throw UnimplementedError('Unimplemented macro target');
    default:
      throw UnsupportedError('Unsupported macro type or invalid target:\n'
          'macro: $macro\ntarget: $target');
  }
}
