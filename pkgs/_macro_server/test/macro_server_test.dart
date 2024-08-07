// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:_macro_client/macro_client.dart';
import 'package:_macro_server/macro_server.dart';
import 'package:_test_macros/declare_x_macro.dart';
import 'package:macro_service/macro_service.dart';
import 'package:test/test.dart';

void main() {
  group(MacroServer, () {
    test('serves a macro service', () async {
      final service = TestMacroHostService();
      final server = await MacroServer.serve(service: service);

      await MacroClient.run(
          endpoint: server.endpoint, macros: [DeclareXImplementation()]);

      // Check that the macro sent its description to the host on startup.
      expect((await service.macroStartedRequests.first).macroDescription,
          DeclareXImplementation().description);
    });
  });
}

class TestMacroHostService implements HostService {
  final StreamController<MacroStartedRequest> _macroStartedRequestsController =
      StreamController();
  Stream<MacroStartedRequest> get macroStartedRequests =>
      _macroStartedRequestsController.stream;

  @override
  Future<Response?> handle(MacroRequest request) async {
    if (request.type == MacroRequestType.macroStartedRequest) {
      _macroStartedRequestsController.add(request.asMacroStartedRequest);
      return Response.macroStartedResponse(MacroStartedResponse());
    }
    return null;
  }
}
