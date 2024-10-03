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
    final result = _PendingAnalyzerModel();

    for (final entry in request.query.expandMultiple()) {
      switch (entry.type) {
        case QueryType.queryName:
          _evaluateQueryName(entry.asQueryName.target, result);
        case QueryType.queryStaticType:
          _evaluateQueryType(entry.asQueryStaticType.target, result);
        default:
          throw UnsupportedError('Unknown query $entry');
      }
    }

    return QueryResponse(model: _createMacroModel(result));
  }

  InterfaceElement _resolveInterface(QualifiedName name) {
    final uri = name.uri;
    final library = _elementFactory.libraryOfUri2(Uri.parse(uri));
    return library.getClass(name.name)!;
  }

  void _evaluateQueryName(QualifiedName target, _PendingAnalyzerModel model) {
    final interface = _resolveInterface(target);
    model.addQueryNameResult(interface);

    // Queried classes are also added to the type hierarchy.
    model.addQueryStaticTypeResult(interface);
  }

  void _evaluateQueryType(QualifiedName target, _PendingAnalyzerModel model) {
    model.addQueryStaticTypeResult(_resolveInterface(target));
  }

  Model _createMacroModel(_PendingAnalyzerModel model) {
    final librariesByUri = <String, Library>{};
    final types =
        AnalyzerTypeHierarchy(_elementFactory.analysisContext.typeProvider);

    for (final clazz in model.resolvedNames) {
      final interface = Interface();
      for (final field in clazz.fields) {
        interface.members[field.name] = Member(
            properties: Properties(
              isAbstract: field.isAbstract,
              isGetter: false,
              isField: true,
              isMethod: false,
              isStatic: field.isStatic,
            ),
            returnType: types.addDartType(field.type));
      }

      librariesByUri
          .putIfAbsent(clazz.library.source.uri.toString(), Library.new)
          .scopes[clazz.name] = interface;
    }

    for (final type in model.resolvedTypes) {
      types.addInterfaceElement(type);
    }

    return Model(types: types.typeHierarchy)..uris.addAll(librariesByUri);
  }
}

class _PendingAnalyzerModel {
  final Set<InterfaceElement> resolvedNames = {};
  final Set<InterfaceElement> resolvedTypes = {};

  void addQueryNameResult(InterfaceElement element) {
    resolvedNames.add(element);
  }

  void addQueryStaticTypeResult(InterfaceElement element) {
    resolvedTypes.add(element);
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
