// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'macro_service.g.dart';

/// Service provided by the host to the macro.
abstract interface class HostService {
  /// Handles [request].
  ///
  /// Returns `null` if the request is of a type not handled by this service
  /// instance.
  Future<Response?> handle(MacroRequest request);
}

/// Service provided by the macro to the host.
abstract interface class MacroService {
  /// Handles [request].
  Future<Response> handle(HostRequest request);
}
