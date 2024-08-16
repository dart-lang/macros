// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/src/json_buffer/json_buffer_builder.dart';

import 'sdk_maps_json_wire_benchmark.dart';

/// Benchmark accumulating data into SDK maps then serializing it via
/// [JsonBufferBuilder].
class SdkMapsBuilderWireBenchmark extends SdkMapsJsonWireBenchmark {
  @override
  void run() {
    final builder = JsonBufferBuilder();
    builder.map.addAll(createData());
    serialized = builder.serialize();
  }

  @override
  void deserialize() {
    deserialized = JsonBufferBuilder.deserialize(serialized!).map;
  }
}
