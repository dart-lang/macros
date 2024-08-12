// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_macro_host/macro_host.dart';
import 'package:dart_model/dart_model.dart';
import 'package:macro_service/macro_service.dart';
import 'package:macros/macros.dart' hide Library;

// TODO(davidmorgan): using this type requires going via `package:macros`
// types, add a hook so we can go directly to underlying `MacroIntrospection`.
DeclarationPhaseIntrospector? introspector;

class CfeQueryService implements QueryService {
  @override
  Future<QueryResponse> handle(QueryRequest request) async {
    return QueryResponse(
        model: await _evaluateClassQuery(request.query.target));
  }

  Future<Model> _evaluateClassQuery(QualifiedName target) async {
    final uri = target.uri;
    final identifier = await introspector!
        // ignore: deprecated_member_use
        .resolveIdentifier(Uri.parse(target.uri), target.name);
    final declaration = await introspector!.typeDeclarationOf(identifier);
    final fields = await introspector!.fieldsOf(declaration);
    return Model(
      uris: {
        uri: Library(
          scopes: {
            target.name: Interface(members: {
              // TODO(davidmorgan): return more than just fields.
              // TODO(davidmorgan): specify in the query what to return.
              for (final field in fields)
                field.identifier.name: Member(
                    properties: Properties(
                  isAbstract: field.hasAbstract,
                  isGetter: false,
                  isField: true,
                  isMethod: false,
                  isStatic: field.hasStatic,
                )),
            })
          },
        ),
      },
    );
  }
}
