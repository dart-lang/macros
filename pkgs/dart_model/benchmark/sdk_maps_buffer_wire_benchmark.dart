// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'json_buffer.dart';
import 'sdk_maps_json_wire_benchmark.dart';

/// Benchmark accumulating data into SDK maps then serializing it via
/// [JsonBuffer].
class SdkMapsBufferWireBenchmark extends SdkMapsJsonWireBenchmark {
  @override
  Uint8List serialize(Map<String, Object?> data) =>
      JsonBuffer(data).serialize();

  @override
  Map<String, Object?> deserialize(Uint8List serialized) =>
      JsonBuffer.deserialize(serialized).asMap;
}
