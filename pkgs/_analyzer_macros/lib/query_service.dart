// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_macro_host/macro_host.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/type_provider.dart';
// ignore: implementation_imports
import 'package:analyzer/src/summary2/linked_element_factory.dart' as analyzer;
import 'package:dart_model/dart_model.dart' hide InterfaceType;
import 'package:macro_service/macro_service.dart';

import 'src/type_translation.dart';

// Hack to access analyzer internals via the introspector that's available.
// TODO(davidmorgan): handle lifecycle, are these equivalent, do they need
// tracking per macro application?
// TODO(davidmorgan): remove hack by injecting an explicit API into the
// analyzer, once we know what's needed.
Object? introspector;
analyzer.LinkedElementFactory get _elementFactory =>
    (introspector as dynamic).elementFactory as analyzer.LinkedElementFactory;

class AnalyzerQueryService implements QueryService {
  @override
  Future<QueryResponse> handle(QueryRequest request) async {
    return QueryResponse(model: _evaluateClassQuery(request.query.target));
  }

  Model _evaluateClassQuery(QualifiedName target) {
    final uri = target.uri;
    final library = _elementFactory.libraryOfUri2(Uri.parse(uri));
    final clazz = library.getClass(target.name)!;
    final types = AnalyzerTypeHierarchy(library.typeProvider)
      ..addInterfaceElement(clazz);

    final interface = Interface();
    for (final constructor in clazz.constructors) {
      interface.members[constructor.name] = Member(
          requiredPositionalParameters: constructor
              .requiredPositionalParameters(types.translator, types.context),
          optionalPositionalParameters: constructor
              .optionalPositionalParameters(types.translator, types.context),
          namedParameters:
              constructor.namedParameters(types.translator, types.context),
          properties: Properties(
            isAbstract: constructor.isAbstract,
            isConstructor: true,
            isGetter: false,
            isField: false,
            isMethod: false,
            isStatic: false,
          ));
    }
    for (final field in clazz.fields) {
      interface.members[field.name] = Member(
          properties: Properties(
            isAbstract: field.isAbstract,
            isConstructor: false,
            isGetter: false,
            isField: true,
            isMethod: false,
            isStatic: field.isStatic,
          ),
          returnType: types.addDartType(field.type));
    }
    for (final method in clazz.methods) {
      interface.members[method.name] = Member(
          requiredPositionalParameters: method.requiredPositionalParameters(
              types.translator, types.context),
          optionalPositionalParameters: method.optionalPositionalParameters(
              types.translator, types.context),
          namedParameters:
              method.namedParameters(types.translator, types.context),
          properties: Properties(
            isAbstract: method.isAbstract,
            isConstructor: false,
            isGetter: false,
            isField: false,
            isMethod: true,
            isStatic: method.isStatic,
          ),
          returnType: types.addDartType(method.returnType));
    }
    return Model(types: types.typeHierarchy)
      ..uris[uri] = (Library()..scopes[clazz.name] = interface);
  }
}

/// Converts between analyzer types and `dart_model` types.
class AnalyzerTypeHierarchy {
  final TypeProvider typeProvider;
  final AnalyzerTypesToMacros translator = const AnalyzerTypesToMacros();
  final TypeHierarchy typeHierarchy = TypeHierarchy();
  final TypeTranslationContext context = TypeTranslationContext();

  AnalyzerTypeHierarchy(this.typeProvider) {
    // Types that are always needed.
    addInterfaceElement(typeProvider.objectElement);
    addInterfaceElement(typeProvider.nullElement);
    addInterfaceElement(typeProvider.futureElement);
  }

  /// Adds [type] to the hierarchy and returns its [StaticTypeDesc].
  StaticTypeDesc addDartType(DartType type) =>
      type.acceptWithArgument(translator, context);

  /// Adds [element] and any supertypes to the hierarchy, if not already
  /// present.
  void addInterfaceElement(InterfaceElement element) {
    final asNamedType = element.thisType
        .acceptWithArgument(translator, context)
        .asNamedTypeDesc;

    final maybeEntry = typeHierarchy.named[asNamedType.name.asString];
    if (maybeEntry != null) {
      return;
    }

    final superTypes = <InterfaceType>[
      if (element.supertype case final supertype?) supertype,
      ...element.interfaces,
      ...element.mixins,
    ];

    for (final type in superTypes) {
      addInterfaceElement(type.element);
    }

    typeHierarchy.named[asNamedType.name.asString] = TypeHierarchyEntry(
      self: asNamedType,
      typeParameters: [
        for (final typeParameter in element.typeParameters)
          translator.translateTypeParameter(typeParameter, context),
      ],
      supertypes: [
        for (final superType in superTypes)
          superType.acceptWithArgument(translator, context).asNamedTypeDesc
      ],
    );
  }
}

extension ExecutableElementExtension on ExecutableElement {
  List<StaticTypeDesc> requiredPositionalParameters(
      AnalyzerTypesToMacros translator, TypeTranslationContext context) {
    return parameters
        .where((p) => p.isRequiredPositional)
        .map((p) => p.type.acceptWithArgument(translator, context))
        .toList();
  }

  List<StaticTypeDesc> optionalPositionalParameters(
      AnalyzerTypesToMacros translator, TypeTranslationContext context) {
    return parameters
        .where((p) => p.isOptionalPositional)
        .map((p) => p.type.acceptWithArgument(translator, context))
        .toList();
  }

  List<NamedFunctionTypeParameter> namedParameters(
      AnalyzerTypesToMacros translator, TypeTranslationContext context) {
    return parameters
        .where((p) => p.isNamed)
        .map((p) => p.type.acceptWithArgument(translator, context))
        .cast<NamedFunctionTypeParameter>()
        .toList();
  }
}
