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

/// Initial size of the buffer.
///
/// TODO(davidmorgan): this matters for performance; optimize.
const int _initialBufferSize = 32;

/// A pointer into the buffer.
typedef _Pointer = int;

/// The type of a value in the buffer.
enum Type {
  nil,
  type,
  pointer,
  uint32,
  boolean,
  stringPointer,
  closedMapPointer,
  growableMapPointer,
  typedMapPointer;

  /// Returns the [Type] of [value], or throws if it is not a supported type.
  static Type _of(Object? value) {
    switch (value) {
      case Null():
        return Type.nil;
      case String():
        return Type.stringPointer;
      case int():
        return Type.uint32;
      case bool():
        return Type.boolean;
      case Type():
        return Type.type;
      case _TypedMap():
        return Type.typedMapPointer;
      case _GrowableMap():
        return Type.growableMapPointer;
      case Map():
        return Type.closedMapPointer;
    }
    throw UnsupportedError(
        'Unsupported type: ${value.runtimeType}, value: $value');
  }

  /// The size in bytes of value of this type.
  int get _sizeInBytes {
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
