// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:_macro_builder/macro_builder.dart';
import 'package:_macro_runner/macro_runner.dart';
import 'package:_macro_server/macro_server.dart';
import 'package:dart_model/dart_model.dart';
import 'package:macro_service/macro_service.dart';

/// Hosts macros: builds them, runs them, serves the macro service.
///
/// Tools that want to support macros, such as the Analyzer and the CFE, can
/// do so by running a `MacroHost` and providing their own `HostService`.
class MacroHost {
  final Map<String, String> macroImplByName;
  final _HostService _hostService;
  final MacroServer macroServer;
  final MacroBuilder macroBuilder = MacroBuilder();
  final MacroRunner macroRunner = MacroRunner();

  MacroHost._(this.macroImplByName, this.macroServer, this._hostService);

  /// Starts a macro host with introspection queries handled by [queryService].
  ///
  /// [macroImplByName] is a map from macro annotation qualified name to macro
  /// implementation qualified name, it's needed until this information is
  /// available in package configs.
  static Future<MacroHost> serve({
    required Map<String, String> macroImplByName,
    required QueryService queryService,
  }) async {
    final hostService = _HostService(queryService);
    final server = await MacroServer.serve(service: hostService);
    return MacroHost._(macroImplByName, server, hostService);
  }

  /// Whether [name] is a macro according to that package's `pubspec.yaml`.
  bool isMacro(Uri packageConfig, QualifiedName name) {
    // TODO(language/3728): this is a placeholder, use package config when
    // available.
    return macroImplByName.keys.contains(name.string);
  }

  /// Determines which phases the macro implemented at [name] runs in.
  Future<Set<int>> queryMacroPhases(
      Uri packageConfig, QualifiedName name) async {
    // TODO(davidmorgan): track macro lifecycle, correctly run once per macro
    // code change including if queried multiple times before response returns.
    if (_hostService._macroPhases != null) {
      return _hostService._macroPhases!.future;
    }
    _hostService._macroPhases = Completer();
    final macroBundle = await macroBuilder.build(packageConfig, [name]);
    macroRunner.start(macroBundle: macroBundle, endpoint: macroServer.endpoint);
    return _hostService._macroPhases!.future;
  }

  /// Sends [request] to the macro with [name].
  Future<AugmentResponse> augment(
      QualifiedName name, AugmentRequest request) async {
    // TODO(davidmorgan): this just assumes the macro is running, actually
    // track macro lifecycle.
    final response = await macroServer.sendToMacro(
        name, HostRequest.augmentRequest(request));
    return response.asAugmentResponse;
  }
}

class _HostService implements HostService {
  final QueryService queryService;
  // TODO(davidmorgan): this should be per macro, as part of tracking per-macro
  // lifecycle state.
  Completer<Set<int>>? _macroPhases;

  _HostService(this.queryService);

  /// Handle requests that are for the host.
  @override
  Future<Response> handle(MacroRequest request) async {
    switch (request.type) {
      case MacroRequestType.macroStartedRequest:
        _macroPhases!.complete(request
            .asMacroStartedRequest.macroDescription.runsInPhases
            .toSet());
        return Response.macroStartedResponse(MacroStartedResponse());
      case MacroRequestType.queryRequest:
        return Response.queryResponse(
            await queryService.handle(request.asQueryRequest));
      default:
        return Response.errorResponse(ErrorResponse(error: 'unsupported'));
    }
  }
}

/// Service provided by the frontend the host integrates with.
abstract interface class QueryService {
  Future<QueryResponse> handle(QueryRequest request);
}
