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
import 'package:macro_service/macro_service.dart';
import 'package:macros/macros.dart' hide Library;

// Hack to access CFE internals via the introspector that's available.
// TODO(davidmorgan): remove hack by injecting an explicit API into the
// CFE, once we know what's needed.
TypePhaseIntrospector? introspector;
cfe.SourceLoader get sourceLoader =>
    (introspector as dynamic).sourceLoader as cfe.SourceLoader;

class CfeQueryService implements QueryService {
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
    final fields = <String, Member>{};
    while (fieldIterator.moveNext()) {
      final current = fieldIterator.current;
      fields[current.name] = Member(
          properties: Properties(
        isAbstract: current.isAbstract,
        isGetter: current.isGetter,
        isField: true,
        isMethod: false,
        isStatic: current.isStatic,
      ));
    }

    return Model(
      uris: {
        uri: Library(
          scopes: {
            // TODO(davidmorgan): return more than just fields.
            // TODO(davidmorgan): specify in the query what to return.
            target.name: Interface(members: fields)
          },
        ),
      },
    );
  }
}
