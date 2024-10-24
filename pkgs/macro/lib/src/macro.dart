// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:macro_service/macro_service.dart';

import 'builders.dart';

/// The marker interface for all types of macros.
abstract interface class Macro {
  /// Description of the macro.
  ///
  /// TODO(davidmorgan): where possible the macro information should be
  /// determined by `macro_builder` and injected in the bootstrap script rather
  /// than relying on the user-written macro code to return it.
  ///
  MacroDescription get description;
}

/// The interface for [Macro]s that can be applied to a library directive, and
/// want to contribute new type declarations to the library.
abstract interface class LibraryTypesMacro implements Macro {
  FutureOr<void> buildTypesForLibrary(LibraryTypesBuilder builder);
}

/// The interface for [Macro]s that can be applied to a library directive, and
/// want to contribute new non-type declarations to the library.
abstract interface class LibraryDeclarationsMacro implements Macro {
  FutureOr<void> buildDeclarationsForLibrary(
      LibraryDeclarationsBuilder builder);
}

/// The interface for [Macro]s that can be applied to a library directive, and
/// want to provide definitions for declarations in the library.
abstract interface class LibraryDefinitionsMacro implements Macro {
  FutureOr<void> buildDefinitionsForLibrary(LibraryDefinitionsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any top level function,
/// instance method, or static method, and want to contribute new type
/// declarations to the program.
abstract interface class FunctionTypesMacro implements Macro {
  FutureOr<void> buildTypesForFunction(FunctionTypesBuilder builder);
}

/// The interface for [Macro]s that can be applied to any top level function,
/// instance method, or static method, and want to contribute new non-type
/// declarations to the program.
abstract interface class FunctionDeclarationsMacro implements Macro {
  FutureOr<void> buildDeclarationsForFunction(
      FunctionDeclarationsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any top level function,
/// instance method, or static method, and want to augment the function
/// definition.
abstract interface class FunctionDefinitionsMacro implements Macro {
  FutureOr<void> buildDefinitionsForFunction(
      FunctionDefinitionsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any top level variable or
/// instance field, and want to contribute new type declarations to the
/// program.
abstract interface class VariableTypesMacro implements Macro {
  FutureOr<void> buildTypesForVariable(VariableTypesBuilder builder);
}

/// The interface for [Macro]s that can be applied to any top level variable or
/// instance field and want to contribute new non-type declarations to the
/// program.
abstract interface class VariableDeclarationsMacro implements Macro {
  FutureOr<void> buildDeclarationsForVariable(
      VariableDeclarationsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any top level variable
/// or instance field, and want to augment the variable definition.
abstract interface class VariableDefinitionsMacro implements Macro {
  FutureOr<void> buildDefinitionsForVariable(
      VariableDefinitionsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any class, and want to
/// contribute new type declarations to the program.
abstract interface class ClassTypesMacro implements Macro {
  FutureOr<void> buildTypesForClass(ClassTypesBuilder builder);
}

/// The interface for [Macro]s that can be applied to any class, and want to
/// contribute new non-type declarations to the program.
abstract interface class ClassDeclarationsMacro implements Macro {
  FutureOr<void> buildDeclarationsForClass(ClassDeclarationsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any class, and want to
/// augment the definitions of the members of that class.
abstract interface class ClassDefinitionsMacro implements Macro {
  FutureOr<void> buildDefinitionsForClass(ClassDefinitionsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any enum, and want to
/// contribute new type declarations to the program.
abstract interface class EnumTypesMacro implements Macro {
  FutureOr<void> buildTypesForEnum(EnumTypesBuilder builder);
}

/// The interface for [Macro]s that can be applied to any enum, and want to
/// contribute new non-type declarations to the program.
abstract interface class EnumDeclarationsMacro implements Macro {
  FutureOr<void> buildDeclarationsForEnum(EnumDeclarationsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any enum, and want to
/// augment the definitions of members or values of that enum.
abstract interface class EnumDefinitionsMacro implements Macro {
  FutureOr<void> buildDefinitionsForEnum(EnumTypesBuilder builder);
}

/// The interface for [Macro]s that can be applied to any enum, and want to
/// contribute new type declarations to the program.
abstract interface class EnumValueTypesMacro implements Macro {
  FutureOr<void> buildTypesForEnumValue(EnumValueTypesBuilder builder);
}

/// The interface for [Macro]s that can be applied to any enum, and want to
/// contribute new non-type declarations to the program.
abstract interface class EnumValueDeclarationsMacro implements Macro {
  FutureOr<void> buildDeclarationsForEnumValue(
      EnumValueDeclarationsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any enum, and want to
/// augment the definitions of members or values of that enum.
abstract interface class EnumValueDefinitionsMacro implements Macro {
  FutureOr<void> buildDefinitionsForEnumValue(
      EnumValueDefinitionsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any field, and want to
/// contribute new type declarations to the program.
abstract interface class FieldTypesMacro implements Macro {
  FutureOr<void> buildTypesForField(FieldTypesBuilder builder);
}

/// The interface for [Macro]s that can be applied to any field, and want to
/// contribute new type declarations to the program.
abstract interface class FieldDeclarationsMacro implements Macro {
  FutureOr<void> buildDeclarationsForField(FieldDeclarationsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any field, and want to
/// augment the field definition.
abstract interface class FieldDefinitionsMacro implements Macro {
  FutureOr<void> buildDefinitionsForField(FieldDefinitionsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any method, and want to
/// contribute new type declarations to the program.
abstract interface class MethodTypesMacro implements Macro {
  FutureOr<void> buildTypesForMethod(MethodTypesBuilder builder);
}

/// The interface for [Macro]s that can be applied to any method, and want to
/// contribute new non-type declarations to the program.
abstract interface class MethodDeclarationsMacro implements Macro {
  FutureOr<void> buildDeclarationsForMethod(MethodDeclarationsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any method, and want to
/// augment the function definition.
abstract interface class MethodDefinitionsMacro implements Macro {
  FutureOr<void> buildDefinitionsForMethod(MethodDefinitionsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any constructor, and want
/// to contribute new type declarations to the program.
abstract interface class ConstructorTypesMacro implements Macro {
  FutureOr<void> buildTypesForConstructor(ConstructorTypesBuilder builder);
}

/// The interface for [Macro]s that can be applied to any constructors, and
/// want to contribute new non-type declarations to the program.
abstract interface class ConstructorDeclarationsMacro implements Macro {
  FutureOr<void> buildDeclarationsForConstructor(
      ConstructorDeclarationsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any constructor, and want
/// to augment the function definition.
abstract interface class ConstructorDefinitionsMacro implements Macro {
  FutureOr<void> buildDefinitionsForConstructor(
      ConstructorDefinitionsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any mixin declaration, and
/// want to contribute new type declarations to the program.
abstract interface class MixinTypesMacro implements Macro {
  FutureOr<void> buildTypesForMixin(MixinTypesBuilder builder);
}

/// The interface for [Macro]s that can be applied to any mixin declaration, and
/// want to contribute new non-type declarations to the program.
abstract interface class MixinDeclarationsMacro implements Macro {
  FutureOr<void> buildDeclarationsForMixin(MixinDeclarationsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any mixin declaration, and
/// want to augment the definitions of the members of that mixin.
abstract interface class MixinDefinitionsMacro implements Macro {
  FutureOr<void> buildDefinitionsForMixin(MixinDefinitionsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any extension declaration,
/// and want to contribute new type declarations to the program.
abstract interface class ExtensionTypesMacro implements Macro {
  FutureOr<void> buildTypesForExtension(ExtensionTypesBuilder builder);
}

/// The interface for [Macro]s that can be applied to any extension declaration,
/// and want to contribute new non-type declarations to the program.
abstract interface class ExtensionDeclarationsMacro implements Macro {
  FutureOr<void> buildDeclarationsForExtension(
      ExtensionDeclarationsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any extension declaration,
/// and want to augment the definitions of the members of that extension.
abstract interface class ExtensionDefinitionsMacro implements Macro {
  FutureOr<void> buildDefinitionsForExtension(
      ExtensionDefinitionsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any extension type
/// declaration, and want to contribute new type declarations to the program.
abstract interface class ExtensionTypeTypesMacro implements Macro {
  FutureOr<void> buildTypesForExtensionType(ExtensionTypeTypesBuilder builder);
}

/// The interface for [Macro]s that can be applied to any extension type
/// declaration, and want to contribute new non-type declarations to the
/// program.
abstract interface class ExtensionTypeDeclarationsMacro implements Macro {
  FutureOr<void> buildDeclarationsForExtensionType(
      ExtensionTypeDeclarationsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any extension type
/// declaration, and want to augment the definitions of the members of that
/// extension.
abstract interface class ExtensionTypeDefinitionsMacro implements Macro {
  FutureOr<void> buildDefinitionsForExtensionType(
      ExtensionTypeDefinitionsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any type alias
/// declaration, and want to contribute new type declarations to the program.
abstract interface class TypeAliasTypesMacro implements Macro {
  FutureOr<void> buildTypesForTypeAlias(TypeAliasTypesBuilder builder);
}

/// The interface for [Macro]s that can be applied to any type alias
/// declaration, and want to contribute new non-type declarations to the
/// program.
abstract interface class TypeAliasDeclarationsMacro implements Macro {
  FutureOr<void> buildDeclarationsForTypeAlias(
      TypeAliasDeclarationsBuilder builder);
}

/// The interface for [Macro]s that can be applied to any type alias
/// declaration, and want to contribute new non-type declarations to the
/// program.
abstract interface class TypeAliasDefinitionsMacro implements Macro {
  FutureOr<void> buildDeclarationsForTypeAlias(
      TypeAliasDeclarationsBuilder builder);
}
