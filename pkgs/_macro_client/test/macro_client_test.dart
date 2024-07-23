// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:_macro_client/macro_client.dart';
import 'package:_test_macros/declare_x_macro.dart';
import 'package:_test_macros/query_class.dart';
import 'package:async/async.dart';
import 'package:dart_model/dart_model.dart';
import 'package:macro_service/macro_service.dart';
import 'package:test/test.dart';

void main() {
  group(MacroClient, () {
    test('connects to service', () async {
      final serverSocket = await ServerSocket.bind('localhost', 0);
      addTearDown(serverSocket.close);

      unawaited(MacroClient.run(
          endpoint: HostEndpoint(port: serverSocket.port),
          macros: [DeclareXImplementation()]));

      expect(
          serverSocket.first.timeout(const Duration(seconds: 10)), completes);
    });

    test('sends augmentation requests to macros, sends reponse', () async {
      final serverSocket = await ServerSocket.bind('localhost', 0);

      unawaited(MacroClient.run(
          endpoint: HostEndpoint(port: serverSocket.port),
          macros: [DeclareXImplementation()]));

      final socket = await serverSocket.first;

      final responses = StreamQueue(
          const Utf8Decoder().bind(socket).transform(const LineSplitter()));
      final descriptionResponse = await responses.next;
      expect(
          descriptionResponse,
          '{"type":"MacroStartedRequest","value":'
          '{"macroDescription":{"runsInPhases":[2]}}}');

      socket.writeln(
          json.encode(HostRequest.augmentRequest(AugmentRequest(phase: 2))));
      final augmentResponse = await responses.next;
      expect(
          augmentResponse,
          '{"type":"AugmentResponse","value":'
          '{"augmentations":[{"code":"int get x => 3;"}]}}');
    });

    test('sends query requests to host, sends reponse', () async {
      final serverSocket = await ServerSocket.bind('localhost', 0);

      unawaited(MacroClient.run(
          endpoint: HostEndpoint(port: serverSocket.port),
          macros: [QueryClassImplementation()]));

      final socket = await serverSocket.first;

      final responses = StreamQueue(socket
          .cast<List<int>>()
          .transform(const Utf8Decoder())
          .transform(const LineSplitter()));
      final descriptionResponse = await responses.next;
      expect(
          descriptionResponse,
          '{"type":"MacroStartedRequest","value":'
          '{"macroDescription":{"runsInPhases":[3]}}}');

      socket.writeln(
          json.encode(HostRequest.augmentRequest(AugmentRequest(phase: 3))));
      final queryRequest = await responses.next;
      expect(
        queryRequest,
        '{"type":"QueryRequest","value":{"query":{}}}',
      );

      socket.writeln(json.encode(Response.queryResponse(QueryResponse(
          model: Model(uris: {'package:foo/foo.dart': Library()})))));

      final augmentRequest = await responses.next;
      expect(
        augmentRequest,
        '{"type":"AugmentResponse","value":'
        '{"augmentations":[{"code":"// {uris: {package:foo/foo.dart: {}}}"}]}}',
      );
    });
  });
}
