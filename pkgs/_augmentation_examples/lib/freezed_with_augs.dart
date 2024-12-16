// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'freezed_with_augs.a.dart';
part 'freezed_with_augs.ag.dart';

// @freezed
class MyClass {
  MyClass({String? a, int? b});
}

// @freezed
class Union {
  const factory Union(int value) = Data;
  const factory Union.loading() = Loading;
  const factory Union.error([String? message]) = ErrorDetails;
  const factory Union.complex(int a, String b) = Complex;

  factory Union.fromJson(Map<String, Object?> json) => _$UnionFromJson(json);
}

// @freezed
class SharedProperty {
  factory SharedProperty.person({String? name, int? age}) = SharedProperty0;

  factory SharedProperty.city({String? name, int? population}) =
      SharedProperty1;
}
