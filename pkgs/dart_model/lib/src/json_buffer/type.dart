// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'json_buffer_builder.dart';

/// Bytes to store a `Type`.
const int _typeSize = 1;

/// Bytes to stare a `Pointer`.
const int _pointerSize = 4;

/// Bytes to store the length of a collection.
const int _lengthSize = 4;

typedef Pointer = int;

enum Type {
  // Fixed size.
  nil,
  type,
  pointer,
  uint32,
  boolean,
  stringPointer,
  closedMapPointer,
  growableMapPointer,
  typedMapPointer;

  static Type of(Object? value) {
    if (value == null) return Type.nil;
    switch (value) {
      case String _:
        return Type.stringPointer;
      case int _:
        return Type.uint32;
      case bool _:
        return Type.boolean;
      case Type _:
        return Type.type;
      case _TypedMap _:
        return Type.typedMapPointer;
      case _GrowableMap _:
        return Type.growableMapPointer;
      case Map _:
        return Type.closedMapPointer;
    }
    throw UnsupportedError(
        'Unsupported type: ${value.runtimeType}, value: $value');
  }

  /// Returns size in bytes.
  int get sizeInBytes {
    switch (this) {
      case nil:
        return 0;
      case type:
      case boolean:
        return 1;
      case uint32:
      case pointer:
      case stringPointer:
      case closedMapPointer:
      case growableMapPointer:
      case typedMapPointer:
        return 4;
    }
  }
}
