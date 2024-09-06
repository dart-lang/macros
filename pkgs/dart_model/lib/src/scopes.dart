// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:typed_data';

import 'json_buffer/json_buffer_builder.dart';

/// Scope for accumulating `dart_model` data for efficient transmission.
///
/// A scope introduces buffers that can be written to. Some `dart_model` types
/// are then instantiated directly into the buffer instead of on the heap,
/// making them ready to send with no further copying.
///
/// Run code in a scope by calling [run] or [runAsync] on the scope.
enum Scope {
  /// No scope.
  ///
  /// If code is running in a scope it can use `Scope.none` to run code
  /// without a scope. For example macro scope is about accumulating
  /// augmentations, but macros also send queries. The `none` scope must be
  /// used when sending queries.
  none,

  /// Server-side scope for handling queries.
  ///
  /// Provides a new buffer for the query result.
  ///
  /// Cannot be nested.
  query,

  /// Client-side scope for macro code to run in.
  ///
  /// Provides a new buffer for the macro's augmentations.
  ///
  /// Cannot be nested.
  macro,

  /// Temporary scope for type evaluation.
  ///
  /// A new buffer is introduced for temporary intermediate values. It's an
  /// error to try to serialize it.
  ///
  /// Can be nested.
  evaluating;

  /// Runs [function] in this scope.
  T run<T>(T Function() function) {
    _checkNesting();
    return runZoned(function, zoneValues: {
      _symbol: _ScopeData._(this, this == none ? null : JsonBufferBuilder())
    });
  }

  /// Runs [function] in this scope.
  Future<T> runAsync<T>(Future<T> Function() function) {
    _checkNesting();
    return runZoned(function, zoneValues: {
      _symbol: _ScopeData._(this, this == none ? null : JsonBufferBuilder())
    });
  }

  void _checkNesting() {
    if (this == Scope.macro || this == Scope.query) {
      final current = _currentOrNull?.type ?? Scope.none;
      if (current != Scope.none) {
        throw StateError('$this cannot be nested in another scope; '
            'but, currently running: $current');
      }
    }
  }

  /// Creates a "typed map" in the buffer of the current scope.
  ///
  /// Throws if there is no current scope.
  static Map<String, Object?> createMap(TypedMapSchema schema,
      [Object? v0,
      Object? v1,
      Object? v2,
      Object? v3,
      Object? v4,
      Object? v5,
      Object? v6,
      Object? v7]) {
    final scope = Scope._currentOrNull;
    final buffer = scope?.buffer;
    if (buffer == null) throw StateError(_noScopeMessage);
    return buffer.createTypedMap(schema, v0, v1, v2, v3, v4, v5, v6, v7);
  }

  /// Creates a "growable map" in the buffer of the current scope.
  ///
  /// Throws if there is no current scope.
  static Map<String, Object?> createGrowableMap() {
    final scope = Scope._currentOrNull;
    final buffer = scope?.buffer;
    if (buffer == null) throw StateError(_noScopeMessage);
    return buffer.createGrowableMap();
  }

  /// Serializes [node] using the buffer of the current scope.
  ///
  /// Values that are part of [node] and already written to the buffer are not
  /// copied, but used directly.
  ///
  /// Throws if called more than once in the same scope.
  static Uint8List serializeToBinary(Map<String, Object?> node) {
    final scope = _currentOrNull;
    if (scope?.type == Scope.evaluating) {
      throw StateError('Current scope is Scope.evaluating, '
          'which should not serialize anything.');
    }
    final buffer = scope?.buffer ?? JsonBufferBuilder();
    if (buffer.map.isNotEmpty) {
      throw StateError('Buffer was already used to send: '
          '${buffer.map}, tried to use it to send: $node');
    }
    buffer.map.addAll(node);
    return buffer.serialize();
  }

  static const _symbol = #_dartModelScope;
  static _ScopeData? get _currentOrNull => Zone.current[_symbol] as _ScopeData?;
}

/// The data that belongs to a scope.
///
/// Whether the scope has a [buffer] is determined by the [type].
class _ScopeData {
  final Scope type;
  final JsonBufferBuilder? buffer;

  _ScopeData._(this.type, this.buffer);
}

const _noScopeMessage =
    'Not running in a scope, but this `dart_model` type can only be '
    'instantiated in a scope. See Scope#run.';
