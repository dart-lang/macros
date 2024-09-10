// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math' show min;
import 'dart:typed_data';

import 'package:macro_service/macro_service.dart';
import 'package:test/test.dart';

void main() {
  for (final protocol in [
    Protocol(encoding: ProtocolEncoding.json),
    Protocol(encoding: ProtocolEncoding.binary)
  ]) {
    group('Protocol using ${protocol.encoding}', () {
      test('can round trip JSON data', () async {
        final json = {
          'string': 'string',
          'int': 7,
          'boolean': true,
          'map': {'key': 'value'},
          'list': [1, 'two', 3]
        };

        final receivedData = <int>[];
        void sink(Uint8List data) => receivedData.addAll(data);
        protocol.send(sink, json);

        final streamController = StreamController<Uint8List>();
        final decodedStream = protocol.decode(streamController.stream);
        streamController.add(Uint8List.fromList(receivedData));
        final message = await decodedStream.first;

        expect(message, json);
      });

      test('can handle multiple arbitrarily split messages', () async {
        final json = {
          'string': 'string',
          'int': 7,
          'boolean': true,
          'map': {'key': 'value'},
          'list': [1, 'two', 3]
        };

        final receivedData = <int>[];
        void sink(Uint8List data) => receivedData.addAll(data);
        for (var i = 0; i != 1000; ++i) {
          protocol.send(sink, json);
        }

        final streamController = StreamController<Uint8List>();
        final decodedStream = protocol.decode(streamController.stream);

        // Split into chunks with size 1, 2, 3, ... until done.
        var sizeToTake = 1;
        while (receivedData.isNotEmpty) {
          final take = min(sizeToTake++, receivedData.length);
          final takenBytes =
              Uint8List.fromList(receivedData.take(take).toList());
          receivedData.removeRange(0, take);
          streamController.add(takenBytes);
        }
        unawaited(streamController.close());

        final messages = await decodedStream.toList();
        expect(messages.length, 1000);

        for (final message in messages) {
          expect(message, json);
        }
      });
    });
  }
}
