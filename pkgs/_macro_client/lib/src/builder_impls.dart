// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';
import 'package:macro/macro.dart';
import 'package:macro_service/macro_service.dart';

import '../macro_client.dart';

abstract base class BuilderBase implements Builder {
  @override
  Model get model => MacroScope.current.model;

  final AugmentResponse response;

  final Host host;

  BuilderBase(this.host)
      : response = AugmentResponse(libraryAugmentations: [], newTypeNames: []);

  BuilderBase.nested(this.host, this.response);

  @override
  Future<Model> query(Query query) => host.query(query);
}

abstract base class TypesBuilderBase extends BuilderBase
    implements TypesBuilder {
  TypesBuilderBase(super.host);

  TypesBuilderBase.nested(super.host, super.response) : super.nested();

  @override
  void declareType(String name, Code typeDeclaration) {
    response.newTypeNames!.add(name);
    response.libraryAugmentations!.add(Augmentation(code: [typeDeclaration]));
  }
}

base mixin ExtendsClauseBuilderImpl on TypesBuilderBase
    implements ExtendsClauseBuilder {
  /// Sets the `extends` clause to [superclass].
  ///
  /// The type must not already have an `extends` clause.
  @override
  void extendsType(Code superclass) {
    final augmentation = Augmentation(code: [superclass]);
    response.extendsTypeAugmentations!.update(
      model.qualifiedNameOf(target.node)!.name,
      // TODO: This should only ever have one thing, but we don't have setters
      // so a list is a hack for lazily adding this field. We should probably
      // throw though if we see more than one.
      (value) => value..add(augmentation),
      ifAbsent: () => [augmentation],
    );
  }
}

base mixin ImplementsClauseBuilderImpl on TypesBuilderBase
    implements ImplementsClauseBuilder {
  /// Appends [interfaces] to the list of interfaces for this type.
  @override
  void appendInterfaces(Iterable<Code> interfaces) {
    final augmentation = Augmentation(code: interfaces.toList());
    response.interfaceAugmentations!.update(
      model.qualifiedNameOf(target.node)!.name,
      (value) => value..add(augmentation),
      ifAbsent: () => [augmentation],
    );
  }
}

base mixin WithClauseBuilderImpl on TypesBuilderBase
    implements WithClauseBuilder {
  /// Appends [mixins] to the list of mixins for this type.
  @override
  void appendMixins(Iterable<Code> mixins) {
    final augmentation = Augmentation(code: mixins.toList());
    response.mixinAugmentations!.update(
      model.qualifiedNameOf(target.node)!.name,
      (value) => value..add(augmentation),
      ifAbsent: () => [augmentation],
    );
  }
}

final class ClassTypesBuilderImpl extends TypesBuilderBase
    with
        WithClauseBuilderImpl,
        ImplementsClauseBuilderImpl,
        ExtendsClauseBuilderImpl
    implements ClassTypesBuilder {
  @override
  final Interface target;

  ClassTypesBuilderImpl(this.target, super.host);

  ClassTypesBuilderImpl.nested(this.target, super.host, super.response)
      : super.nested();
}

abstract base class DeclarationsBuilderBase extends BuilderBase
    implements DeclarationsBuilder {
  DeclarationsBuilderBase(super.host);

  DeclarationsBuilderBase.nested(super.host, super.response) : super.nested();

  @override
  void declareInLibrary(Code declaration) {
    response.libraryAugmentations!.add(Augmentation(code: [declaration]));
  }
}

abstract base class MemberDeclarationsBuilderBase
    extends DeclarationsBuilderBase implements MemberDeclarationsBuilder {
  MemberDeclarationsBuilderBase(super.host);

  MemberDeclarationsBuilderBase.nested(super.host, super.response)
      : super.nested();

  @override
  void declareInType(Code declaration) {
    final augmentation = Augmentation(code: [declaration]);
    response.typeAugmentations!.update(
      model.qualifiedNameOf(target.node)!.name,
      (value) => value..add(augmentation),
      ifAbsent: () => [augmentation],
    );
  }
}

final class ClassDeclarationsBuilderImpl extends MemberDeclarationsBuilderBase
    implements ClassDeclarationsBuilder {
  @override
  final Interface target;

  ClassDeclarationsBuilderImpl(this.target, super.host);

  ClassDeclarationsBuilderImpl.nested(this.target, super.host, super.response)
      : super.nested();
}

abstract base class InterfaceDefinitionBuilderBase extends BuilderBase {
  InterfaceDefinitionBuilderBase(super.host);

  InterfaceDefinitionBuilderBase.nested(super.host, super.response)
      : super.nested();

  /// Retrieve a [FieldDefinitionsBuilder] for a field with [name] in
  /// [target].
  ///
  /// Throws if [name] does not refer to a field in the [target] interface
  /// declaration.
  FieldDefinitionsBuilder buildField(QualifiedName name) =>
      throw UnimplementedError();

  /// Retrieve a [MethodDefinitionsBuilder] for a method with [name] in
  /// [target].
  ///
  /// Throws if [name] does not refer to a method in the [target] interface
  /// declaration.
  MethodDefinitionsBuilder buildMethod(QualifiedName name) =>
      throw UnimplementedError();

  /// Retrieve a [ConstructorDefinitionsBuilder] for a constructor with [name]
  /// in [target].
  ///
  /// Throws if [name] does not refer to a constructor in the [target]
  /// interface declaration.
  ConstructorDefinitionsBuilder buildConstructor(QualifiedName name) =>
      throw UnimplementedError();
}

final class ClassDefinitionsBuilderImpl extends InterfaceDefinitionBuilderBase
    implements ClassDefinitionsBuilder {
  @override
  final Interface target;

  ClassDefinitionsBuilderImpl(this.target, super.host);

  ClassDefinitionsBuilderImpl.nested(this.target, super.host, super.response)
      : super.nested();
}
