// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:collection/collection.dart';

import 'builder_maps_builder_wire_benchmark.dart';
import 'builder_maps_json_wire_benchmark.dart';
import 'lazy_maps_buffer_wire_benchmark.dart';
import 'lazy_maps_json_wire_benchmark.dart';
import 'lazy_wrappers_buffer_wire_benchmark.dart';
import 'lazy_wrappers_buffer_wire_benchmark.dart' as wrapped;
import 'sdk_maps_buffer_wire_benchmark.dart';
import 'sdk_maps_builder_wire_benchmark.dart';
import 'sdk_maps_json_wire_benchmark.dart';
import 'serialization_benchmark.dart';

void main() {
  final serializationBenchmarks = [
    SdkMapsJsonWireBenchmark(),
    SdkMapsBufferWireBenchmark(),
    SdkMapsBuilderWireBenchmark(),
    LazyMapsJsonWireBenchmark(),
    LazyMapsBufferWireBenchmark(),
    LazyWrappersBufferWireBenchmark(),
    BuilderMapsJsonWireBenchmark(),
    BuilderMapsBuilderWireBenchmark(),
  ];

  for (var i = 0; i != 3; ++i) {
    // Collects the total measurements from all phases, per benchmark.
    final totals = <SerializationBenchmark, int>{
      for (var benchmark in serializationBenchmarks) benchmark: 0,
    };

    for (var stage in BenchmarkStage.values) {
      var padding = 0;
      for (final benchmark in serializationBenchmarks) {
        benchmark.stage = stage;
        padding = max(padding, benchmark.name.length);
      }

      for (final benchmark in serializationBenchmarks) {
        final measure = benchmark.measure().toMilliseconds;
        totals[benchmark] = totals[benchmark]! + measure;

        var buffer =
            StringBuffer(benchmark.name.padLeft(padding + 1))
              ..write(': ')
              ..write('${measure}ms'.padLeft(6));

        switch (stage) {
          case BenchmarkStage.serialize:
            final paddedBytes = '${benchmark.bytes}'.padLeft(7);
            buffer.write(', $paddedBytes bytes');
          case BenchmarkStage.process:
            buffer.write(', hash ${benchmark.hashResult}');
          default:
        }
        print(buffer.toString());
      }
    }

    // Add up the totals and print them.
    {
      var padding = 0;
      String name(SerializationBenchmark benchmark) =>
          '${benchmark.runtimeType}-total';

      for (final benchmark in serializationBenchmarks) {
        padding = max(padding, name(benchmark).length);
      }
      for (var benchmark in serializationBenchmarks) {
        var buffer =
            StringBuffer(name(benchmark).padLeft(padding + 1))
              ..write(':')
              ..write('${totals[benchmark]}ms'.padLeft(7));
        print(buffer.toString());
      }
    }

    print('');

    print('validating benchmark results (this is slow)');
    for (final benchmark in serializationBenchmarks.skip(1)) {
      var deserialized = benchmark.deserialized;
      // Need to unwrap these to compare them as raw maps.
      if (deserialized is Map<String, wrapped.Interface>) {
        deserialized = deserialized.map<String, Object?>(
          (k, v) => MapEntry(k, v.toJson()),
        );
      }
      if (!const DeepCollectionEquality().equals(
        deserialized,
        serializationBenchmarks.first.deserialized,
      )) {
        throw StateError(
          'Validation failed for ${benchmark.name}, deserialized does not match.',
        );
      }
    }
    print('\nDeserialized output validated.\n');
  }
}

extension DoubleExtension on double {
  int get toMilliseconds => (this / 1000).round();
}
