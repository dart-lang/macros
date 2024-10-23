// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';

import 'macro.dart';

/// The base interface used to add declarations to the program as well
/// as augment existing ones.
abstract interface class Builder {
  /// The target declaration of this macro application.
  ///
  /// All builder subtypes should override this with a more specific type.
  Object get target;

  /// The current accumulated [Model] for this macro application.
  ///
  /// This will contain all data including the [target] as well as the results
  /// of any queries which have been ran.
  Model get model;

  /// TODO: We eventually want phase specific queries here.
  Future<Model> query(Query query);
}

/// The API used by [Macro]s to contribute new type declarations to the
/// current library.
abstract interface class TypesBuilder implements Builder {
  /// Adds a new type declaration to the surrounding library.
  ///
  /// The [name] must match the name of the new [typeDeclaration] (this does
  /// not include any type parameters, just the name).
  void declareType(
      String name,
      // TODO: Tighten this type https://github.com/dart-lang/macros/issues/111
      Augmentation typeDeclaration);
}

/// The API used by macros in the type phase to add interfaces to [target]s
/// `implements` clause.
abstract interface class ImplementsClauseBuilder implements TypesBuilder {
  @override
  Interface get target;

  /// Appends [interfaces] to the `implements` clause on [target].
  void appendInterfaces(
      // TODO: Tighten this type https://github.com/dart-lang/macros/issues/111
      Iterable<Augmentation> interfaces);
}

/// The API used by macros in the type phase to add mixins to the [target]s
/// `with` clause.
abstract interface class WithClauseBuilder implements TypesBuilder {
  @override
  Interface get target;

  /// Appends [mixins] to the `with` clause on [target].
  void appendMixins(
      // TODO: Tighten this type https://github.com/dart-lang/macros/issues/111
      Iterable<Augmentation> mixins);
}

/// The API used by macros in the type phase to set the `extends` clause
/// on the [target] type.
abstract interface class ExtendsClauseBuilder implements TypesBuilder {
  @override
  Interface get target;

  /// Sets the `extends` clause on [target] to [supertype].
  ///
  /// The [target] type must not already have an `extends` clause.
  void extendsType(
      // TODO: Tighten this type https://github.com/dart-lang/macros/issues/111
      Augmentation supertype);
}

/// The builder API for [LibraryTypesMacro]s.
abstract interface class LibraryTypesBuilder implements TypesBuilder {
  @override
  Library get target;
}

/// The builder API for [FunctionTypesMacro]s.
abstract interface class FunctionTypesBuilder implements TypesBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Object get target;
}

/// The builder API for [MethodTypesMacro]s.
abstract interface class MethodTypesBuilder implements FunctionTypesBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Member get target;
}

/// The builder API for [ConstructorTypesMacro]s.
abstract interface class ConstructorTypesBuilder implements MethodTypesBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Member get target;
}

/// The builder API for [VariableTypesMacro]s.
abstract interface class VariableTypesBuilder implements TypesBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Object get target;
}

/// The builder API for [FieldTypesMacro]s.
abstract interface class FieldTypesBuilder implements VariableTypesBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Member get target;
}

/// The builder API for [ClassTypesMacro]s.
abstract interface class ClassTypesBuilder
    implements
        TypesBuilder,
        ExtendsClauseBuilder,
        ImplementsClauseBuilder,
        WithClauseBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Interface get target;
}

/// The builder API for [EnumTypesMacro]s.
abstract interface class EnumTypesBuilder
    implements TypesBuilder, ImplementsClauseBuilder, WithClauseBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Interface get target;
}

/// The builder API for [EnumValueTypesMacro]s.
abstract interface class EnumValueTypesBuilder implements TypesBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Interface get target;
}

/// The builder API for [ExtensionTypesMacro]s.
///
/// Note that augmentations do not allow altering the `on` clause.
abstract interface class ExtensionTypesBuilder
    implements TypesBuilder, ImplementsClauseBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Interface get target;
}

/// The builder API for [ExtensionTypeTypesMacro]s.
///
// TODO: Should this implement `WithClauseBuilder`, the spec is unclear?
abstract interface class ExtensionTypeTypesBuilder implements TypesBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Interface get target;
}

/// The builder API for [MixinTypesMacro]s.
///
/// Note that mixins don't support mixins, only interfaces.
abstract interface class MixinTypesBuilder
    implements TypesBuilder, ImplementsClauseBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Interface get target;
}

/// The builder API for [TypeAliasTypesMacro]s.
abstract interface class TypeAliasTypesBuilder implements TypesBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Object get target;
}

/// The base API used by all [Macro]s in the declarations phase.
abstract interface class DeclarationsBuilder implements Builder {
  /// Adds a new regular declaration to the library containing (or equal to) the
  /// [target].
  ///
  /// Note that type declarations are not supported.
  void declareInLibrary(
      // TODO: Tighten this type https://github.com/dart-lang/macros/issues/111
      Augmentation declaration);
}

/// The builder API for [LibraryDeclarationsMacro]s.
///
// TODO: Should theses builders be able to get `DeclarationsBuilder`s for the
// nested scopes defined in `target`? What would the ordering behavior of that
// be?
abstract interface class LibraryDeclarationsBuilder
    implements DeclarationsBuilder {
  @override
  Library get target;
}

/// The builder API for [FunctionDeclarationsMacro]s.
abstract interface class FunctionDeclarationsBuilder
    implements DeclarationsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Object get target;
}

/// The builder API for [MethodDeclarationsMacro]s.
abstract interface class MethodDeclarationsBuilder
    implements FunctionDeclarationsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Member get target;
}

/// The builder API for [ConstructorDeclarationsMacro]s.
abstract interface class ConstructorDeclarationsBuilder
    implements MethodDeclarationsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Member get target;
}

/// The builder API for [VariableDeclarationsMacro]s.
abstract interface class VariableDeclarationsBuilder
    implements DeclarationsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Object get target;
}

/// The builder API for [FieldDeclarationsMacro]s.
abstract interface class FieldDeclarationsBuilder
    implements VariableDeclarationsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Member get target;
}

/// The base builder API for [Macro]s which run on any [Interface] in the
/// delarations phase.
abstract interface class MemberDeclarationsBuilder
    implements DeclarationsBuilder {
  @override
  Interface get target;

  /// Adds a new declaration to the [target] interface.
  void declareInType(
      // TODO: Tighten this type https://github.com/dart-lang/macros/issues/111
      Augmentation declaration);
}

/// The builder API for [ClassDeclarationsMacro]s.
abstract interface class ClassDeclarationsBuilder
    implements MemberDeclarationsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Interface get target;
}

/// The builder API for [EnumDeclarationsMacro]s.
abstract interface class EnumDeclarationsBuilder
    implements MemberDeclarationsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Interface get target;

  /// Adds a new enum value declaration to the [target] enum.
  void declareEnumValue(
      // TODO: Tighten this type https://github.com/dart-lang/macros/issues/111
      Augmentation declaration);
}

/// The builder API for [EnumValueDeclarationsMacro]s.
abstract interface class EnumValueDeclarationsBuilder
    implements DeclarationsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Interface get target;
}

/// The builder API for [ExtensionDeclarationsMacro]s.
abstract interface class ExtensionDeclarationsBuilder
    implements MemberDeclarationsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Interface get target;
}

/// The builder API for [ExtensionTypeDeclarationsMacro]s.
abstract interface class ExtensionTypeDeclarationsBuilder
    implements MemberDeclarationsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Interface get target;
}

/// The builder API for [MixinDeclarationsMacro]s.
abstract interface class MixinDeclarationsBuilder
    implements MemberDeclarationsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Interface get target;
}

/// The builder API for [TypeAliasDeclarationsMacro]s.
abstract interface class TypeAliasDeclarationsBuilder
    implements DeclarationsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Object get target;
}

/// The base builder API for [Macro]s which run in the definitions phase.
abstract interface class DefinitionsBuilder implements Builder {}

/// The builder API for [LibraryDefinitionsMacro]s.
abstract interface class LibraryDefinitionsBuilder
    implements DefinitionsBuilder {
  @override
  Library get target;

  /// Retrieve a [InterfaceDefinitionsBuilder] for the interface declaration
  /// with [name] in [target].
  ///
  /// Throws if [name] does not refer to an interface declaration in the
  /// [target] library.
  InterfaceDefinitionsBuilder buildInterface(QualifiedName name);

  /// Retrieve a [FunctionDefinitionsBuilder] for a function declaration with
  /// [name] in [target].
  ///
  /// Throws if [name] does not refer to a top level function declaration in the
  /// [target] library.
  FunctionDefinitionsBuilder buildFunction(QualifiedName name);

  /// Retrieve a [VariableDefinitionsBuilder] for a variable declaration with
  /// [name] in [target].
  ///
  /// Throws if [name] does not refer to a top level variable declaration in the
  /// [target] library.
  VariableDefinitionsBuilder buildVariable(QualifiedName name);
}

/// The builder API for [FunctionDefinitionsMacro]s.
abstract interface class FunctionDefinitionsBuilder
    implements DefinitionsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Object get target;

  /// Augments an existing function.
  ///
  /// If [docCommentsAndMetadata] are supplied, they will be added above this
  /// augment declaration.
  ///
  /// If [body] is supplied it will be used as the body for the augmenting
  /// declaration, otherwise no body will be provided (which will leave the
  /// existing body in tact).
  ///
  /// TODO: Link the library augmentations proposal to describe the semantics.
  void augment({
    // TODO: Tighten this type https://github.com/dart-lang/macros/issues/111
    Augmentation? body,
    // TODO: Tighten this type https://github.com/dart-lang/macros/issues/111
    Augmentation? docCommentsAndMetadata,
  });
}

/// The builder API for [MethodDefinitionsMacro]s.
abstract interface class MethodDefinitionsBuilder
    implements FunctionDefinitionsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Member get target;
}

/// The builder API for [ConstructorDefinitionsMacro]s.
abstract interface class ConstructorDefinitionsBuilder
    implements DefinitionsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Member get target;

  /// Augments an existing constructor body.
  ///
  /// If [body] is supplied it will be used as the body for the augmenting
  /// declaration, otherwise no body will be provided.
  ///
  /// The [initializers] should not contain trailing or preceding commas, but
  /// may include doc comments.
  ///
  /// If [docCommentsAndMetadata] are supplied, they will be added above this
  /// augment declaration.
  ///
  /// TODO: Link the library augmentations proposal to describe the semantics.
  void augment({
    // TODO: Tighten this type https://github.com/dart-lang/macros/issues/111
    Augmentation? body,
    // TODO: Tighten this type https://github.com/dart-lang/macros/issues/111
    List<Augmentation>? initializers,
    // TODO: Tighten this type https://github.com/dart-lang/macros/issues/111
    Augmentation? docCommentsAndMetadata,
  });
}

/// The builder API for [VariableDefinitionsMacro]s.
abstract interface class VariableDefinitionsBuilder
    implements DefinitionsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Object get target;

  /// Augments an existing variable.
  ///
  /// For [getter] and [setter] the full function declaration should be
  /// provided, minus the `augment` keyword (which will be implicitly added).
  ///
  /// To provide doc comments or metadata for [getter] or [setter], just include
  /// them in the [Augmentation] object for those.
  ///
  /// If [docCommentsAndMetadata] or [initializer] are supplied they will be
  /// attached to a standard variable augmentation. If only
  /// [docCommentsAndMetadata] is provided, there will be no augmenting
  /// initializer (which leaves the existing initializer in tact).
  ///
  /// TODO: Link the library augmentations proposal to describe the semantics.
  void augment({
    // TODO: Tighten this type https://github.com/dart-lang/macros/issues/111
    Augmentation? getter,
    // TODO: Tighten this type https://github.com/dart-lang/macros/issues/111
    Augmentation? setter,
    // TODO: Tighten this type https://github.com/dart-lang/macros/issues/111
    Augmentation? initializer,
    // TODO: Tighten this type https://github.com/dart-lang/macros/issues/111
    Augmentation? docCommentsAndMetadata,
  });
}

/// The builder API for [FieldDefinitionsMacro]s.
abstract interface class FieldDefinitionsBuilder
    implements VariableDefinitionsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Object get target;
}

/// The base builder API for [Macro]s which run on any [Interface] in the
/// definitions phase.
abstract interface class InterfaceDefinitionsBuilder
    implements DefinitionsBuilder {
  @override
  Interface get target;

  /// Retrieve a [FieldDefinitionsBuilder] for a field with [name] in
  /// [target].
  ///
  /// Throws if [name] does not refer to a field in the [target] interface
  /// declaration.
  FieldDefinitionsBuilder buildField(QualifiedName name);

  /// Retrieve a [MethodDefinitionsBuilder] for a method with [name] in
  /// [target].
  ///
  /// Throws if [name] does not refer to a method in the [target] interface
  /// declaration.
  MethodDefinitionsBuilder buildMethod(QualifiedName name);

  /// Retrieve a [ConstructorDefinitionsBuilder] for a constructor with [name]
  /// in [target].
  ///
  /// Throws if [name] does not refer to a constructor in the [target]
  /// interface declaration.
  ConstructorDefinitionsBuilder buildConstructor(QualifiedName name);
}

/// The builder API for [ClassDefinitionsMacro]s.
abstract interface class ClassDefinitionsBuilder
    implements InterfaceDefinitionsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Interface get target;
}

/// The builder API for [EnumDefinitionsMacro]s.
abstract interface class EnumDefinitionsBuilder
    implements InterfaceDefinitionsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Interface get target;

  /// Retrieve an [EnumValueDefinitionsBuilder] for an entry with [name] in
  /// [target].
  ///
  /// Throws if [name] does not refer to an entry on the [target] enum
  /// declaration.
  EnumValueDefinitionsBuilder buildEnumValue(QualifiedName name);
}

/// The builder API for [EnumValueDefinitionsMacro]s.
abstract interface class EnumValueDefinitionsBuilder
    implements DefinitionsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Member get target;

  /// Augments an existing enum value entry.
  ///
  /// If [docCommentsAndMetadata] are supplied, they will be added above this
  /// augment declaration.
  void augment({
    // TODO: Tighten this type https://github.com/dart-lang/macros/issues/111
    Augmentation? docCommentsAndMetadata,
  });
}

/// The builder API for [ExtensionDefinitionsMacro]s.
abstract interface class ExtensionDefinitionsBuilder
    implements InterfaceDefinitionsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Interface get target;
}

/// The builder API for [ExtensionTypeDefinitionsMacro]s.
abstract interface class ExtensionTypeDefinitionsBuilder
    implements InterfaceDefinitionsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Interface get target;
}

/// The builder API for [MixinDefinitionsMacro]s.
abstract interface class MixinDefinitionsBuilder
    implements InterfaceDefinitionsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Interface get target;
}

/// The builder API for [TypeAliasDefinitionsMacro]s.
abstract interface class TypeAliasDefinitionsBuilder
    implements DefinitionsBuilder {
  @override
  // TODO: More specific type https://github.com/dart-lang/macros/issues/10
  Object get target;
}
