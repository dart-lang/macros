// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';

import 'builder_maps_builder_wire_benchmark.dart';
import 'builder_maps_json_wire_benchmark.dart';
import 'lazy_maps_buffer_wire_benchmark.dart';
import 'lazy_maps_json_wire_benchmark.dart';
import 'lazy_wrappers_buffer_wire_benchmark.dart';
import 'lazy_wrappers_buffer_wire_benchmark.dart' as wrapped;
import 'regular_dart_classes.dart';
import 'regular_dart_classes.dart' as regular;
import 'sdk_maps_buffer_wire_benchmark.dart';
import 'sdk_maps_builder_wire_benchmark.dart';
import 'sdk_maps_json_wire_benchmark.dart';

void main() {
  final sdkMapsJsonWireBenchmark = SdkMapsJsonWireBenchmark();
  final lazyMapsBufferWireBenchmark = LazyMapsBufferWireBenchmark();
  final lazyWrappersBufferWireBenchmark = LazyWrappersBufferWireBenchmark();
  final builderMapsBuilderWireBenchmark = BuilderMapsBuilderWireBenchmark();
  final regularClassesBufferWireBenchmark = RegularClassesBufferWireBenchmark();
  final serializationBenchmarks = [
    sdkMapsJsonWireBenchmark,
    SdkMapsBufferWireBenchmark(),
    SdkMapsBuilderWireBenchmark(),
    LazyMapsJsonWireBenchmark(),
    lazyMapsBufferWireBenchmark,
    lazyWrappersBufferWireBenchmark,
    BuilderMapsJsonWireBenchmark(),
    builderMapsBuilderWireBenchmark,
    regularClassesBufferWireBenchmark,
  ];

  for (var i = 0; i != 3; ++i) {
    for (final benchmark in serializationBenchmarks) {
      final measure = benchmark.measure().toMilliseconds;
      final paddedName = benchmark.name.padLeft(31);
      final paddedMeasure = '${measure}ms'.padLeft(6);

      final paddedBytes = '${benchmark.serialized!.length}'.padLeft(7);
      print('$paddedName: $paddedMeasure, $paddedBytes bytes');
      benchmark.deserialize();
    }
    print('');

    for (final benchmark in [
      sdkMapsJsonWireBenchmark.processBenchmark(),
      lazyMapsBufferWireBenchmark.processBenchmark(),
      lazyWrappersBufferWireBenchmark.processBenchmark(),
      builderMapsBuilderWireBenchmark.processBenchmark(),
      regularClassesBufferWireBenchmark.processBenchmark(),
    ]) {
      final measure = benchmark.measure().toMilliseconds;
      final paddedName = benchmark.name.padLeft(36);
      final paddedMeasure = '${measure}ms'.padLeft(6);

      print('$paddedName: $paddedMeasure, hash ${benchmark.computedResult}');
    }

    for (final benchmark in serializationBenchmarks.skip(1)) {
      var deserialized = benchmark.deserialized;
      // Need to unwrap these to compare them as raw maps.
      if (deserialized is Map<String, wrapped.Interface>) {
        deserialized = deserialized.map<String, Object?>(
          (k, v) => MapEntry(k, v.toJson()),
        );
      } else if (deserialized is Map<String, regular.Interface>) {
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
