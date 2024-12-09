// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';

import 'lazy_wrappers_buffer_wire_benchmark.dart' as wrapped;

const mapSize = 10000;
final mapKeys = List.generate(mapSize, (i) => i.toString());

/// Benchmark serializing `dart_model` data.
abstract class SerializationBenchmark extends BenchmarkBase {
  /// The serialized result; used to report the size.
  Uint8List? serialized;

  /// The deserialized result; used to check correctness.
  Map<String, Object?>? deserialized;

  SerializationBenchmark() : super('');

  @override
  String get name => runtimeType.toString();

  /// For [ProcessBenchmark].
  void deserialize();

  /// Creates a [ProcessBenchmark] based on the deserialized data.
  ProcessBenchmark processBenchmark() => ProcessBenchmark(this);

  List<String> makeMemberNames(int key) {
    final length = key % 10;
    return List<String>.generate(
      // "key % 2999" so some member names are reused.
      length,
      (i) => 'interface${key % 2999}member$i',
    );
  }
}

/// Benchmark that walks the full deserialized data.
class ProcessBenchmark extends BenchmarkBase {
  final SerializationBenchmark serializationBenchmark;

  /// The hash of all the data; used to check correctness.
  int? computedResult;

  ProcessBenchmark(this.serializationBenchmark) : super('');

  @override
  String get name => 'Process${serializationBenchmark.name}';

  @override
  void run() {
    computedResult = deepHash(serializationBenchmark.deserialized!);
  }

  int deepHash(Map<Object?, Object?> map) {
    var result = 0;
    for (final entry in map.entries) {
      result ^= entry.key.hashCode;
      final value = entry.value;
      if (value is Map) {
        result ^= deepHash(value);
      } else if (value is wrapped.Serializable) {
        result ^= deepHash(value.toJson());
      } else if (value is Hashable) {
        result ^= value.deepHash;
      } else {
        result ^= value.hashCode;
      }
    }
    return result;
  }
}

/// Interface for computing a hash, when the underlying object isn't a Map.
abstract interface class Hashable {
  int get deepHash;
}
