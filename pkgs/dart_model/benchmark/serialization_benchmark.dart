// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';

import 'lazy_wrappers_buffer_wire_benchmark.dart';

const mapSize = 10000;
final mapKeys = List.generate(mapSize, (i) => i.toString());

/// Benchmark serializing `dart_model` data.
abstract class SerializationBenchmark extends BenchmarkBase {
  late BenchmarkStage stage;

  /// The result of [createData]; passed to [serialize] later.
  late Map<String, Object?> _data;

  /// The result of [serialize]; used to report the size and passed to
  /// [deserialize] later.
  late Uint8List _serialized;

  /// The result of [deserialize]; used to check correctness and passed to
  /// [deepHash] later.
  late Map<String, Object?> deserialized;

  /// The result of [deepHash]; result should be identical from all
  /// implementations.
  late int hashResult;

  SerializationBenchmark() : super('');

  /// The length of the serialized bytes, only valid to call after running
  /// [BenchmarkStage.serialize].
  int get bytes => _serialized.lengthInBytes;

  @override
  String get name => '$runtimeType-${stage.name}';

  @override
  void run() {
    switch (stage) {
      case BenchmarkStage.create:
        _data = createData();
      case BenchmarkStage.serialize:
        _serialized = serialize(_data);
      case BenchmarkStage.deserialize:
        deserialized = deserialize(_serialized);
      case BenchmarkStage.process:
        hashResult = deepHash(deserialized);
    }
  }

  /// Used to measure [BenchmarkStage.create], sets [_data] to the result.
  Map<String, Object?> createData();

  /// Used to measure [BenchmarkStage.serialize], called with [data], sets
  /// [_serialized] to the result.
  Uint8List serialize(Map<String, Object?> data);

  /// Used to measure [BenchmarkStage.deserialize], called with
  /// [_serialized], sets [deserialized] to the result.
  Map<String, Object?> deserialize(Uint8List data);

  /// Used to measure [BenchmarkStage.process], called with
  /// [_serialized], sets [deserialized] to the result.
  ///
  /// Default implementation works only for JSON style maps.
  int deepHash(Map<String, Object?> deserialized) {
    var result = 0;
    for (final entry in deserialized.entries) {
      result ^= entry.key.hashCode;
      final value = entry.value;
      result ^= switch (value) {
        Map<String, Object?>() => deepHash(value),
        Serializable() => deepHash(value.toJson()),
        String() || int() || bool() => value.hashCode,
        _ =>
          throw StateError(
            'Unrecognized JSON value $value, '
            'custom hash function needed?',
          ),
      };
    }
    return result;
  }

  List<String> makeMemberNames(int key) {
    final length = key % 10;
    return List<String>.generate(
      // "key % 2999" so some member names are reused.
      length,
      (i) => 'interface${key % 2999}member$i',
    );
  }
}

enum BenchmarkStage { create, serialize, deserialize, process }
