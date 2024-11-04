// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_macro_host/macro_host.dart';
import 'package:dart_model/dart_model.dart';
// ignore: implementation_imports
import 'package:front_end/src/source/source_class_builder.dart' as cfe;
// ignore: implementation_imports
import 'package:front_end/src/source/source_field_builder.dart' as cfe;
// ignore: implementation_imports
import 'package:front_end/src/source/source_loader.dart' as cfe;
import 'package:kernel/kernel.dart' as kernel;
import 'package:macro_service/macro_service.dart';
import 'package:macros/macros.dart' hide Library;

import 'src/type_translation.dart';

// Hack to access CFE internals via the introspector that's available.
// TODO(davidmorgan): remove hack by injecting an explicit API into the
// CFE, once we know what's needed.
TypePhaseIntrospector? introspector;
cfe.SourceLoader get sourceLoader =>
    (introspector as dynamic).sourceLoader as cfe.SourceLoader;

final class CfeQueryService extends QueryService {
  @override
  Future<QueryResponse> handle(QueryRequest request) async {
    return QueryResponse(
        model: await _evaluateClassQuery(request.query.target));
  }

  Future<Model> _evaluateClassQuery(QualifiedName target) async {
    final uri = target.uri;
    final libraryBuilder = sourceLoader.sourceLibraryBuilders
        .singleWhere((l) => l.importUri.toString() == target.uri);
    final classBuilderIterator =
        libraryBuilder.fullMemberIterator<cfe.SourceClassBuilder>();
    cfe.SourceClassBuilder? classBuilder;
    while (classBuilderIterator.moveNext()) {
      if (classBuilderIterator.current.name == target.name) {
        classBuilder = classBuilderIterator.current;
      }
    }
    if (classBuilder == null) throw StateError('Not found $target');
    final fieldIterator =
        classBuilder.fullMemberIterator<cfe.SourceFieldBuilder>();
    final interface = Interface(properties: Properties(isClass: true));
    while (fieldIterator.moveNext()) {
      final current = fieldIterator.current;
      interface.members[current.name] = Member(
          properties: Properties(
        isAbstract: current.isAbstract,
        isGetter: current.isGetter,
        isField: true,
        isMethod: false,
        isStatic: current.isStatic,
      ));
    }
    TypeHierarchy? types;
    try {
      types = _buildTypeHierarchy({classBuilder.actualCls});
    } catch (_) {
      // TODO: Fails in types phase, implement fine grained queries.
    }
    return Model(types: types)
      ..uris[uri] = (Library()
        ..
            // TODO(davidmorgan): return more than just fields.
            // TODO(davidmorgan): specify in the query what to return.

            scopes[target.name] = interface);
  }

  TypeHierarchy _buildTypeHierarchy(Set<kernel.Class> classes) {
    // These classes need to be present in every type hierarchy due to their
    // special role. Other types are only relevant if reachable from [classes].
    final coreTypes = sourceLoader.coreTypes;
    classes.add(coreTypes.objectClass);
    classes.add(coreTypes.deprecatedNullClass);
    classes.add(coreTypes.futureClass);

    // Make sure we include all supertypes of involved classes to close the
    // type hierarchy.
    var pending = <kernel.Class>[...classes];

    while (pending.isNotEmpty) {
      final clazz = pending.removeLast();

      for (final superType in clazz.supers) {
        if (!classes.contains(superType.classNode) &&
            !pending.contains(superType.classNode)) {
          classes.add(clazz);
          pending.add(clazz);
        }
      }
    }

    final context = TypeTranslationContext();
    const translator = KernelTypeToMacros();
    final result = TypeHierarchy();
    for (final element in classes) {
      final asNamedType = element
          .getThisType(coreTypes, kernel.Nullability.nonNullable)
          .accept1(translator, context)
          .asNamedTypeDesc;

      result.named[asNamedType.name.asString] = TypeHierarchyEntry(
        self: asNamedType,
        typeParameters: [
          for (final typeParameter in element.typeParameters)
            translator.translateTypeParameter(typeParameter, context),
        ],
        supertypes: [
          for (final superType in element.supers)
            superType.asInterfaceType
                .accept1(translator, context)
                .asNamedTypeDesc
        ],
      );
    }

    return result;
  }
}
