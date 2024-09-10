// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_model/serialization.dart';

import 'macro_service.g.dart';
import 'message_grouper.dart';

/// Service provided by the host to the macro.
abstract interface class HostService {
  /// Handles [request].
  ///
  /// Returns `null` if the request is of a type not handled by this service
  /// instance.
  Future<Response> handle(MacroRequest request);
}

/// Service provided by the macro to the host.
abstract interface class MacroService {
  /// Handles [request].
  Future<Response> handle(HostRequest request);
}

/// Shared implementation of auto incrementing 32 bit IDs.
///
/// These roll back to 0 once it is greater than 2^32.
///
/// These are only unique to the process which generates the request,
/// so for instance the host and macro services may generate conflicting ids
/// and that is allowed.
int get nextRequestId {
  final next = _nextRequestId++;
  if (_nextRequestId > 0x7fffffff) {
    _nextRequestId = 0;
  }
  return next;
}

int _nextRequestId = 0;

final _jsonConverter = json.fuse(utf8);

extension ProtocolExtension on Protocol {
  /// Serializes [node] and sends it to [sink].
  void send(void Function(Uint8List) sink, Map<String, Object?> node) {
    switch (encoding) {
      case ProtocolEncoding.json:
        sink(_jsonConverter.encode(node) as Uint8List);
        sink(_utf8Newline);
      case ProtocolEncoding.binary:
        // Four byte message length followed by message.
        // TODO(davidmorgan): variable length int encoding probably makes more
        // sense than fixed four bytes.
        final binary = node.serializeToBinary();
        final length = binary.length;
        sink(Uint8List.fromList([
          (length >> 24) & 255,
          (length >> 16) & 255,
          (length >> 8) & 255,
          length & 255,
        ]));
        sink(binary);
      default:
        throw StateError('Unsupported protocol: $this.');
    }
  }

  /// Deserializes [stream] to JSON objects.
  ///
  /// The data on `stream` can be arbitrarily split to `Uint8List` instances,
  /// it does not have to be one list per message.
  Stream<Map<String, Object?>> decode(Stream<Uint8List> stream) {
    switch (encoding) {
      case ProtocolEncoding.json:
        return const Utf8Decoder()
            .bind(stream)
            .transform(const LineSplitter())
            .map((line) => json.decode(line) as Map<String, Object?>);
      case ProtocolEncoding.binary:
        return MessageGrouper(stream)
            .messageStream
            .map((message) => message.deserializeFromBinary());
      default:
        throw StateError('Unsupported protocol: $this');
    }
  }
}

final _utf8Newline = const Utf8Encoder().convert('\n');
