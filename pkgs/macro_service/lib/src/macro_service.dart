// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Service interface.
abstract interface class MacroService {
  /// Handles [request].
  ///
  /// Returns `null` if the request is of a type not handled by this service
  /// instance.
  Future<Object?> handle(Object request);
}
