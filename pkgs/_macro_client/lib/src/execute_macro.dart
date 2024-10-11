// Copyright (c) 2022, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:dart_model/dart_model.dart';
import 'package:macro/macro.dart';
import 'package:macro_service/macro_service.dart';

/// Runs [macro] in the types phase and returns a  [AugmentResponse].
Future<AugmentResponse> executeTypesMacro(
    Macro macro, Host host, AugmentRequest request) async {
  final target = request.target;
  // TODO: https://github.com/dart-lang/macros/issues/100.
  final queryResult = await host.query(Query(target: target));
  final properties =
      queryResult.uris[target.uri]!.scopes[target.name]!.properties;
  switch ((properties, macro)) {
    case (Properties(isClass: true), ClassTypesMacro macro):
      return await macro.buildTypesForClass(host, request);
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

/// Runs [macro] in the declaration phase and returns a  [AugmentResponse].
Future<AugmentResponse> executeDeclarationsMacro(
    Macro macro, Host host, AugmentRequest request) async {
  final target = request.target;
  // TODO: https://github.com/dart-lang/macros/issues/100.
  final queryResult = await host.query(Query(target: target));
  final properties =
      queryResult.uris[target.uri]!.scopes[target.name]!.properties;

  switch ((properties, macro)) {
    case (Properties(isClass: true), ClassDeclarationsMacro macro):
      return await macro.buildDeclarationsForClass(host, request);
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

/// Runs [macro] in the definition phase and returns a  [AugmentResponse].
Future<AugmentResponse> executeDefinitionMacro(
    Macro macro, Host host, AugmentRequest request) async {
  final target = request.target;
  // TODO: https://github.com/dart-lang/macros/issues/100.
  final queryResult = await host.query(Query(target: target));
  final properties =
      queryResult.uris[target.uri]!.scopes[target.name]!.properties;

  switch ((properties, macro)) {
    case (Properties(isClass: true), ClassDefinitionsMacro macro):
      return await macro.buildDefinitionsForClass(host, request);
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
