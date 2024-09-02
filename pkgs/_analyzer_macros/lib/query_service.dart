// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_macro_host/macro_host.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
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
    return Model(
      uris: {
        uri: Library(
          scopes: {
            clazz.name: Interface(members: {
              // TODO(davidmorgan): return more than just fields.
              // TODO(davidmorgan): specify in the query what to return.
              for (final field in clazz.fields)
                field.name: Member(
                    properties: Properties(
                  isAbstract: field.isAbstract,
                  isGetter: false,
                  isField: true,
                  isMethod: false,
                  isStatic: field.isStatic,
                )),
            })
          },
        ),
      },
      types: _buildTypeHierarchy(library, {clazz}),
    );
  }

  TypeHierarchy _buildTypeHierarchy(
      LibraryElement library, Set<InterfaceElement> classes) {
    // These classes need to be present in every type hierarchy due to their
    // special role. Other types are only relevant if reachable from [classes].
    final typeProvider = library.typeProvider;
    classes.add(typeProvider.objectElement);
    classes.add(typeProvider.nullElement);
    classes.add(typeProvider.futureElement);

    // Make sure we include all supertypes of involved classes to close the
    // type hierarchy.
    for (final included in classes.toList()) {
      for (final superType in included.allSupertypes) {
        classes.add(superType.element);
      }
    }

    final serialized = <String, TypeHierarchyEntry>{};
    final context = TypeTranslationContext();
    const translator = AnalyzerTypesToMacros();

    for (final element in classes) {
      final asNamedType = element.thisType
          .acceptWithArgument(translator, context)
          .asNamedTypeDesc;

      final superTypes = <InterfaceType>[
        if (element.supertype case final supertype?) supertype,
        ...element.interfaces,
        ...element.mixins,
      ];

      serialized[asNamedType.name.string] = TypeHierarchyEntry(
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

    return TypeHierarchy(named: serialized);
  }
}
