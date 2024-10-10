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
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to a library directive, and
/// want to contribute new non-type declarations to the library.
abstract interface class LibraryDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForLibrary(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to a library directive, and
/// want to provide definitions for declarations in the library.
abstract interface class LibraryDefinitionMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionForLibrary(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any top level function,
/// instance method, or static method, and want to contribute new type
/// declarations to the program.
abstract interface class FunctionTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForFunction(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any top level function,
/// instance method, or static method, and want to contribute new non-type
/// declarations to the program.
abstract interface class FunctionDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForFunction(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any top level function,
/// instance method, or static method, and want to augment the function
/// definition.
abstract interface class FunctionDefinitionMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionForFunction(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any top level variable or
/// instance field, and want to contribute new type declarations to the
/// program.
abstract interface class VariableTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForVariable(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any top level variable or
/// instance field and want to contribute new non-type declarations to the
/// program.
abstract interface class VariableDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForVariable(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any top level variable
/// or instance field, and want to augment the variable definition.
abstract interface class VariableDefinitionMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionForVariable(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any class, and want to
/// contribute new type declarations to the program.
abstract interface class ClassTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForClass(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any class, and want to
/// contribute new non-type declarations to the program.
abstract interface class ClassDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForClass(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any class, and want to
/// augment the definitions of the members of that class.
abstract interface class ClassDefinitionMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionForClass(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any enum, and want to
/// contribute new type declarations to the program.
abstract interface class EnumTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForEnum(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any enum, and want to
/// contribute new non-type declarations to the program.
abstract interface class EnumDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForEnum(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any enum, and want to
/// augment the definitions of members or values of that enum.
abstract interface class EnumDefinitionMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionForEnum(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any enum, and want to
/// contribute new type declarations to the program.
abstract interface class EnumValueTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForEnumValue(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any enum, and want to
/// contribute new non-type declarations to the program.
abstract interface class EnumValueDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForEnumValue(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any enum, and want to
/// augment the definitions of members or values of that enum.
abstract interface class EnumValueDefinitionMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionForEnumValue(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any field, and want to
/// contribute new type declarations to the program.
abstract interface class FieldTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForField(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any field, and want to
/// contribute new type declarations to the program.
abstract interface class FieldDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForField(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any field, and want to
/// augment the field definition.
abstract interface class FieldDefinitionMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionForField(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any method, and want to
/// contribute new type declarations to the program.
abstract interface class MethodTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForMethod(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any method, and want to
/// contribute new non-type declarations to the program.
abstract interface class MethodDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForMethod(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any method, and want to
/// augment the function definition.
abstract interface class MethodDefinitionMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionForMethod(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any constructor, and want
/// to contribute new type declarations to the program.
abstract interface class ConstructorTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForConstructor(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any constructors, and
/// want to contribute new non-type declarations to the program.
abstract interface class ConstructorDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForConstructor(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any constructor, and want
/// to augment the function definition.
abstract interface class ConstructorDefinitionMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionForConstructor(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any mixin declaration, and
/// want to contribute new type declarations to the program.
abstract interface class MixinTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForMixin(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any mixin declaration, and
/// want to contribute new non-type declarations to the program.
abstract interface class MixinDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForMixin(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any mixin declaration, and
/// want to augment the definitions of the members of that mixin.
abstract interface class MixinDefinitionMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionForMixin(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any extension declaration,
/// and want to contribute new type declarations to the program.
abstract interface class ExtensionTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForExtension(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any extension declaration,
/// and want to contribute new non-type declarations to the program.
abstract interface class ExtensionDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForExtension(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any extension declaration,
/// and want to augment the definitions of the members of that extension.
abstract interface class ExtensionDefinitionMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionForExtension(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any extension type
/// declaration, and want to contribute new type declarations to the program.
abstract interface class ExtensionTypeTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForExtensionType(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any extension type
/// declaration, and want to contribute new non-type declarations to the
/// program.
abstract interface class ExtensionTypeDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForExtensionType(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any extension type
/// declaration, and want to augment the definitions of the members of that
/// extension.
abstract interface class ExtensionTypeDefinitionMacro implements Macro {
  FutureOr<AugmentResponse> buildDefinitionForExtensionType(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any type alias
/// declaration, and want to contribute new type declarations to the program.
abstract interface class TypeAliasTypesMacro implements Macro {
  FutureOr<AugmentResponse> buildTypesForTypeAlias(
      Host host, AugmentRequest request);
}

/// The interface for [Macro]s that can be applied to any type alias
/// declaration, and want to contribute new non-type declarations to the
/// program.
abstract interface class TypeAliasDeclarationsMacro implements Macro {
  FutureOr<AugmentResponse> buildDeclarationsForTypeAlias(
      Host host, AugmentRequest request);
}
