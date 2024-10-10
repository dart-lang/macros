// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';

// TODO(davidmorgan): figure out where this should go.
extension TemplatingExtension on QualifiedName {
  String get code => '{{$uri#$name}}';
}

/// Converts [template] to a mix of `Identifier` and `String`.
///
/// References of the form `{{uri#name}}` become [QualifiedName] wrapped in
/// [Code.qualifiedName], everything else becomes `String`.
///
/// TODO(davidmorgan): figure out where this should go.
List<Code> expandTemplate(String template) {
  final result = <Code>[];
  var index = 0;
  while (index < template.length) {
    final start = template.indexOf('{{', index);
    if (start == -1) {
      result.add(Code.string(template.substring(index)));
      break;
    }
    result.add(Code.string(template.substring(index, start)));
    final end = template.indexOf('}}', start);
    if (end == -1) {
      throw ArgumentError('Unmatched opening brace: $template');
    }
    final name = template.substring(start + 2, end);
    final parts = name.split('#');
    if (parts.length != 2) {
      throw ArgumentError('Expected "uri#name" in: $name');
    }
    result
        .add(Code.qualifiedName(QualifiedName(uri: parts[0], name: parts[1])));
    index = end + 2;
  }
  return result;
}
