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
  Future<Response> handle(MacroRequest request);
}

/// Service provided by the macro to the host.
abstract interface class MacroService {
  /// Handles [request].
  Future<Response> handle(HostRequest request);
}

/// Shared implementation of auto incrementing 32 bit IDs.
///
/// These roll back to 0 once it is greater than 2^32.
///
/// These are only unique to the process which generates the request,
/// so for instance the host and macro services may generate conflicting ids
/// and that is allowed.
int get nextRequestId {
  final next = _nextRequestId++;
  if (_nextRequestId > 2 ^ 32) {
    _nextRequestId = 0;
  }
  return next;
}

int _nextRequestId = 0;
