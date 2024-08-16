// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'builder_maps_builder_wire_benchmark.dart';

/// Benchmark accumulating data directly into a `JsonBufferBuilder` then
/// serializing it to JSON.
class BuilderMapsJsonWireBenchmark extends BuilderMapsBuilderWireBenchmark {
  @override
  void run() {
    serialized = json.fuse(utf8).encode(createData()) as Uint8List;
  }

  @override
  void deserialize() {
    deserialized = json.fuse(utf8).decode(serialized!) as Map<String, Object?>;
  }
}
