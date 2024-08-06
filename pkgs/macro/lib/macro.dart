// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:macro_service/macro_service.dart';

/// A macro: transforms Dart code into Dart code augmentations to apply to the
/// code.
abstract interface class Macro {
  /// Description of the macro.
  ///
  /// TODO(davidmorgan): where possible the macro information should be
  /// determined by `macro_builder` and injected in the bootstrap script rather
  /// than relying on the user-written macro code to return it.
  ///
  MacroDescription get description;

  /// Generate augmentatations and diagnostics for [request].
  ///
  /// The code can be introspected by sending queries to [host].
  Future<AugmentResponse> augment(Host host, AugmentRequest request);
}

/// The macro host.
abstract interface class Host {
  // TODO(davidmorgan): introspection methods go here.
}
