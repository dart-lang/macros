// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart_model.g.dart';

export 'dart_model.g.dart';

extension QualifiedNameExtension on QualifiedName {
  String get asString => '$uri#$name';

  bool equals(QualifiedName other) => other.uri == uri && other.name == name;
}

extension QueryExtension on Query {
  /// Recursively replaces [QueryMultiple] queries with their inner queries.
  Iterable<Query> expandMultiple() sync* {
    if (type == QueryType.queryMultiple) {
      for (final entry in asQueryMultiple.queries) {
        yield* entry.expandMultiple();
      }
    } else {
      yield this;
    }
  }
}
