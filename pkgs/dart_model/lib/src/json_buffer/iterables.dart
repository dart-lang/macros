// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'json_buffer_builder.dart';

/// More efficient implementations than `MapMixin` for maps with efficient
/// `entries`.
mixin _EntryMapMixin<K, V> on Map<K, V> {
  // `MapMixin` iterates keys then looks up each value.
  //
  // Instead, iterate `entries`.
  @override
  void forEach(void Function(K key, V value) action) {
    for (final entry in entries) {
      action(entry.key, entry.value);
    }
  }
}

/// An [Iterable] that uses the supplied function to create an [Iterator].
///
/// [length] is also passed in, as the default implementation is very slow.
class _IteratorFunctionIterable<T> extends Iterable<T> {
  final Iterator<T> Function() _function;
  @override
  final int length;

  _IteratorFunctionIterable(this._function, {required this.length});

  @override
  Iterator<T> get iterator => _function();
}
