// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'macro_service.g.dart';

/// Macro->host RPCs as methods.
// TODO(davidmorgan): generate this.
abstract interface class MacroHostService {}

/// Host->macro RPCs as methods.
// TODO(davidmorgan): generate this.
abstract interface class MacroClientService {
  Future<AugmentResponse> augment(AugmentRequest request);
}
