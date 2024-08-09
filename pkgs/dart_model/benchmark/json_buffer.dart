// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';
import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:dart_model/src/json_buffer.dart';

Uint8List? serialized;
JsonBuffer? deserialized;
const mapSize = 1000000;
final mapKeys = List.generate(mapSize, (i) => i.toString());

void main() {
  JsonBufferSerializeBenchmark().report();
  // See note below, this is not measuring anything right now.
  JsonBufferDeserializeBenchmark().report();
  if (deserialized!.asMap.keys.length != mapSize) {
    throw StateError('Benchmark invalid, map was not of expected size');
  }
}

class JsonBufferSerializeBenchmark extends BenchmarkBase {
  JsonBufferSerializeBenchmark() : super('JsonBufferSerialize');

  @override
  void run() {
    serialized = JsonBuffer(LazyMap(mapKeys, (key) => key)).serialize();
  }
}

class JsonBufferDeserializeBenchmark extends BenchmarkBase {
  JsonBufferDeserializeBenchmark() : super('JsonBufferDeserialize');

  @override
  void run() {
    // TODO: This is actually a no-op, so the benchmark is kind of pointless.
    // Should we read all the keys/values?
    deserialized = JsonBuffer.deserialize(serialized!);
  }
}
