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
  void declareType(String name, Augmentation typeDeclaration) {
    response.newTypeNames!.add(name);
    response.libraryAugmentations!.add(typeDeclaration);
  }
}

base mixin ExtendsClauseBuilderImpl on TypesBuilderBase
    implements ExtendsClauseBuilder {
  /// Sets the `extends` clause to [superclass].
  ///
  /// The type must not already have an `extends` clause.
  @override
  void extendsType(Augmentation superclass) {
    response.extendsTypeAugmentations!.update(
      model.qualifiedNameOf(target.node)!.name,
      // TODO: This should only ever have one thing, but we don't have setters
      // so a list is a hack for lazily adding this field. We should probably
      // throw though if we see more than one.
      (value) => value..add(superclass),
      ifAbsent: () => [superclass],
    );
  }
}

base mixin ImplementsClauseBuilderImpl on TypesBuilderBase
    implements ImplementsClauseBuilder {
  /// Appends [interfaces] to the list of interfaces for this type.
  @override
  void appendInterfaces(Iterable<Augmentation> interfaces) {
    response.interfaceAugmentations!.update(
      model.qualifiedNameOf(target.node)!.name,
      (value) => value..addAll(interfaces),
      ifAbsent: () => [...interfaces],
    );
  }
}

base mixin WithClauseBuilderImpl on TypesBuilderBase
    implements WithClauseBuilder {
  /// Appends [mixins] to the list of mixins for this type.
  @override
  void appendMixins(Iterable<Augmentation> mixins) {
    response.mixinAugmentations!.update(
      model.qualifiedNameOf(target.node)!.name,
      (value) => value..addAll(mixins),
      ifAbsent: () => [...mixins],
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
  void declareInLibrary(Augmentation declaration) {
    response.libraryAugmentations!.add(declaration);
  }
}

abstract base class MemberDeclarationsBuilderBase
    extends DeclarationsBuilderBase implements MemberDeclarationsBuilder {
  MemberDeclarationsBuilderBase(super.host);

  MemberDeclarationsBuilderBase.nested(super.host, super.response)
      : super.nested();

  @override
  void declareInType(Augmentation declaration) {
    response.typeAugmentations!.update(
      model.qualifiedNameOf(target.node)!.name,
      (value) => value..add(declaration),
      ifAbsent: () => [declaration],
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

final class MethodDefinitionsBuilderImpl extends BuilderBase
    implements MethodDefinitionsBuilder {
  @override
  final Member target;

  MethodDefinitionsBuilderImpl(this.target, super.host);

  MethodDefinitionsBuilderImpl.nested(this.target, super.host, super.response)
      : super.nested();

  @override
  void augment({Augmentation? body, Augmentation? docCommentsAndMetadata}) {
    final augmentation = _buildFunctionAugmentation(body, target, model,
        docComments: docCommentsAndMetadata);
    response.typeAugmentations!.update(
        target.parentInterface.name, (value) => value..add(augmentation),
        ifAbsent: () => [augmentation]);
  }
}

final class ConstructorDefinitionsBuilderImpl extends BuilderBase
    implements ConstructorDefinitionsBuilder {
  @override
  final Member target;

  ConstructorDefinitionsBuilderImpl(this.target, super.host);

  ConstructorDefinitionsBuilderImpl.nested(
      this.target, super.host, super.response)
      : super.nested();

  @override
  void augment(
      {Augmentation? body,
      List<Augmentation>? initializers,
      Augmentation? docCommentsAndMetadata}) {
    final augmentation = _buildFunctionAugmentation(body, target, model,
        initializers: initializers, docComments: docCommentsAndMetadata);
    response.typeAugmentations!.update(
        target.parentInterface.name, (value) => value..add(augmentation),
        ifAbsent: () => [augmentation]);
  }
}

abstract base class InterfaceDefinitionsBuilderBase extends BuilderBase
    implements InterfaceDefinitionsBuilder {
  InterfaceDefinitionsBuilderBase(super.host);

  InterfaceDefinitionsBuilderBase.nested(super.host, super.response)
      : super.nested();

  /// Retrieve a [FieldDefinitionsBuilder] for a field with [name] in
  /// [target].
  ///
  /// Throws if [name] does not refer to a field in the [target] interface
  /// declaration.
  @override
  FieldDefinitionsBuilder buildField(QualifiedName name) =>
      throw UnimplementedError();

  /// Retrieve a [MethodDefinitionsBuilder] for a method with [name] in
  /// [target].
  ///
  /// Throws if [name] does not refer to a method in the [target] interface
  /// declaration.
  @override
  MethodDefinitionsBuilder buildMethod(QualifiedName name) =>
      MethodDefinitionsBuilderImpl.nested(
          Member.fromJson(model.lookup(name)!), host, response);

  /// Retrieve a [ConstructorDefinitionsBuilder] for a constructor with [name]
  /// in [target].
  ///
  /// Throws if [name] does not refer to a constructor in the [target]
  /// interface declaration.
  @override
  ConstructorDefinitionsBuilder buildConstructor(QualifiedName name) =>
      ConstructorDefinitionsBuilderImpl.nested(
          Member.fromJson(model.lookup(name)!), host, response);
}

final class ClassDefinitionsBuilderImpl extends InterfaceDefinitionsBuilderBase
    implements ClassDefinitionsBuilder {
  @override
  final Interface target;

  ClassDefinitionsBuilderImpl(this.target, super.host);

  ClassDefinitionsBuilderImpl.nested(this.target, super.host, super.response)
      : super.nested();
}

/// Builds the code to augment a function, method, or constructor with a new
/// body.
///
/// The [initializers] parameter can only be used if [declaration] is a
/// constructor.
Augmentation _buildFunctionAugmentation(
    Augmentation? body, Member declaration, Model model,
    {List<Augmentation>? initializers, Augmentation? docComments}) {
  assert(initializers == null || declaration.properties.isConstructor);
  final properties = declaration.properties;
  final qualifiedName = model.qualifiedNameOf(declaration.node)!;
  final parts = <Object?>[
    if (docComments != null) ...[docComments, '\n'],
    if (declaration.properties.isMethod) '  ',
    'augment ',
    if (properties.isConstructor) ...[
      // TODO: Uncomment once we have `isConst`.
      // if (properties.isConst) 'const ',
      // TODO: Uncomment once we have `isFactory`.
      // if (properties.isFactory) 'factory ',
      declaration.parentInterface.name,
      if (qualifiedName.name.isNotEmpty) '.',
    ] else ...[
      if (properties.isMethod && properties.isStatic) 'static ',
      // TODO: Uncomment once we have support for converting types into code.
      // declaration.returnType.code,
      ' ',
      // TODO: Uncomment once we have `isOperator`.
      // if (properties.isOperator) 'operator ',
    ],
    if (properties.isGetter) 'get ',
    // TODO: Uncomment once we have `isSetter`.
    if (properties.isGetter) 'set ',
    qualifiedName.name,
    if (!properties.isGetter) ...[
      // TODO: Uncomment once we have `typeParameters`.
      // if (declaration.typeParameters.isNotEmpty) ...[
      //   '<',
      //   for (TypeParameterDeclaration typeParam
      //       in declaration.typeParameters) ...[
      //     typeParam.identifier.name,
      //     if (typeParam.bound != null) ...[' extends ', typeParam.bound!.code],
      //     if (typeParam != declaration.typeParameters.last) ', ',
      //   ],
      //   '>',
      // ],
      '(',
      // TODO: Extreme hack alert!!! Parameters only expose their types today
      // which isn't enough, this assumes we are a fromJson method :D.
      if (declaration.requiredPositionalParameters.length == 1)
        'json'
      else if (declaration.requiredPositionalParameters.isNotEmpty)
        throw UnimplementedError(),
      // for (var positionalRequired
      //     in declaration.requiredPositionalParameters) ...[
      //   positionalRequired.code,
      //   ', ',
      // ],
      if (declaration.optionalPositionalParameters.isNotEmpty) ...[
        // TODO: Implement this.
        throw UnimplementedError(),
        // '[',
        // for (var positionalOptional
        //     in declaration.optionalPositionalParameters) ...[
        //   positionalOptional.code,
        //   ', ',
        // ],
        // ']',
      ],
      if (declaration.namedParameters.isNotEmpty) ...[
        // TODO: Implement this.
        throw UnimplementedError(),
        // '{',
        // for (var named in declaration.namedParameters) ...[
        //   named.code,
        //   ', ',
        // ],
        // '}',
      ],
      ')',
    ],
    if (initializers != null && initializers.isNotEmpty) ...[
      '\n      : ',
      ...initializers.first.code,
      for (var initializer in initializers.skip(1)) ...[
        ',\n        ',
        ...initializer.code,
      ],
    ],
    if (body == null)
      ';'
    else ...[
      ' ',
      body,
    ]
  ];
  return Augmentation(code: [
    for (var part in parts)
      switch (part) {
        Code() => part,
        String() => Code.string(part),
        _ => throw StateError('Unexpected code kind $part'),
      },
  ]);
}
