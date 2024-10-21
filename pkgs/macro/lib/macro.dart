// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:dart_model/dart_model.dart';
import 'package:macro_service/macro_service.dart';

/// The macro host.
abstract interface class Host {
  Future<Model> query(Query query);
  // TODO(davidmorgan): introspection methods go here.
}

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
  FutureOr<AugmentResponse> buildTypesForLibrary(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to a library directive, and
/// want to contribute new non-type declarations to the library.
abstract interface class LibraryDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForLibrary(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to a library directive, and
/// want to provide definitions for declarations in the library.
abstract interface class LibraryDefinitionsMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionsForLibrary(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any top level function,
/// instance method, or static method, and want to contribute new type
/// declarations to the program.
abstract interface class FunctionTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForFunction(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any top level function,
/// instance method, or static method, and want to contribute new non-type
/// declarations to the program.
abstract interface class FunctionDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForFunction(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any top level function,
/// instance method, or static method, and want to augment the function
/// definition.
abstract interface class FunctionDefinitionsMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionsForFunction(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any top level variable or
/// instance field, and want to contribute new type declarations to the
/// program.
abstract interface class VariableTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForVariable(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any top level variable or
/// instance field and want to contribute new non-type declarations to the
/// program.
abstract interface class VariableDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForVariable(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any top level variable
/// or instance field, and want to augment the variable definition.
abstract interface class VariableDefinitionsMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionsForVariable(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any class, and want to
/// contribute new type declarations to the program.
abstract interface class ClassTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForClass(
      Interface target, Model model, Host host);
}

/// The interface for [Macro]s that can be applied to any class, and want to
/// contribute new non-type declarations to the program.
abstract interface class ClassDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForClass(
      Interface target, Model model, Host host);
}

/// The interface for [Macro]s that can be applied to any class, and want to
/// augment the definitions of the members of that class.
abstract interface class ClassDefinitionsMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionsForClass(
      Interface target, Model model, Host host);
}

/// The interface for [Macro]s that can be applied to any enum, and want to
/// contribute new type declarations to the program.
abstract interface class EnumTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForEnum(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any enum, and want to
/// contribute new non-type declarations to the program.
abstract interface class EnumDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForEnum(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any enum, and want to
/// augment the definitions of members or values of that enum.
abstract interface class EnumDefinitionsMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionsForEnum(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any enum, and want to
/// contribute new type declarations to the program.
abstract interface class EnumValueTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForEnumValue(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any enum, and want to
/// contribute new non-type declarations to the program.
abstract interface class EnumValueDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForEnumValue(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any enum, and want to
/// augment the definitions of members or values of that enum.
abstract interface class EnumValueDefinitionsMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionsForEnumValue(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any field, and want to
/// contribute new type declarations to the program.
abstract interface class FieldTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForField(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any field, and want to
/// contribute new type declarations to the program.
abstract interface class FieldDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForField(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any field, and want to
/// augment the field definition.
abstract interface class FieldDefinitionsMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionsForField(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any method, and want to
/// contribute new type declarations to the program.
abstract interface class MethodTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForMethod(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any method, and want to
/// contribute new non-type declarations to the program.
abstract interface class MethodDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForMethod(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any method, and want to
/// augment the function definition.
abstract interface class MethodDefinitionsMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionsForMethod(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any constructor, and want
/// to contribute new type declarations to the program.
abstract interface class ConstructorTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForConstructor(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any constructors, and
/// want to contribute new non-type declarations to the program.
abstract interface class ConstructorDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForConstructor(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any constructor, and want
/// to augment the function definition.
abstract interface class ConstructorDefinitionsMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionsForConstructor(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any mixin declaration, and
/// want to contribute new type declarations to the program.
abstract interface class MixinTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForMixin(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any mixin declaration, and
/// want to contribute new non-type declarations to the program.
abstract interface class MixinDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForMixin(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any mixin declaration, and
/// want to augment the definitions of the members of that mixin.
abstract interface class MixinDefinitionsMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionsForMixin(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any extension declaration,
/// and want to contribute new type declarations to the program.
abstract interface class ExtensionTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForExtension(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any extension declaration,
/// and want to contribute new non-type declarations to the program.
abstract interface class ExtensionDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForExtension(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any extension declaration,
/// and want to augment the definitions of the members of that extension.
abstract interface class ExtensionDefinitionsMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionsForExtension(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any extension type
/// declaration, and want to contribute new type declarations to the program.
abstract interface class ExtensionTypeTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForExtensionType(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any extension type
/// declaration, and want to contribute new non-type declarations to the
/// program.
abstract interface class ExtensionTypeDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForExtensionType(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any extension type
/// declaration, and want to augment the definitions of the members of that
/// extension.
abstract interface class ExtensionTypeDefinitionsMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionsForExtensionType(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any type alias
/// declaration, and want to contribute new type declarations to the program.
abstract interface class TypeAliasTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForTypeAlias(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}

/// The interface for [Macro]s that can be applied to any type alias
/// declaration, and want to contribute new non-type declarations to the
/// program.
abstract interface class TypeAliasDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForTypeAlias(
      // TODO: Fill in a real type once we have it
      Object target,
      Model model,
      Host host);
}
