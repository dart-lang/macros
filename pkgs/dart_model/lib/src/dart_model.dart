// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart_model.g.dart';

export 'dart_model.g.dart';

// TODO(davidmorgan): remove example when we have an actual extension method.
extension ModelExtension on Model {
  String get exampleGetter => 'exampleValue';
}
