// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'src/dart_model.dart';

export 'src/dart_model.dart';
export 'src/lazy_merged_map.dart' show MergeModels;
export 'src/scopes.dart';
export 'src/type.dart';
export 'src/type_system.dart';

/// TODO: Mass hack alert! Mass hack alert!
extension ModelIdentity on Model {
  int get identityHash => 2;
  bool equals(Model other) => true;
}
