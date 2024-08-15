// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:_macro_builder/macro_builder.dart';
import 'package:_macro_runner/macro_runner.dart';
import 'package:_macro_server/macro_server.dart';
import 'package:dart_model/dart_model.dart';
import 'package:macro_service/macro_service.dart';

import 'src/package_config.dart';

/// Hosts macros: builds them, runs them, serves the macro service.
///
/// Tools that want to support macros, such as the Analyzer and the CFE, can
/// do so by running a `MacroHost` and providing their own `HostService`.
class MacroHost {
  final MacroPackageConfig macroPackageConfig;
  final _HostService _hostService;
  final MacroServer macroServer;
  final MacroBuilder macroBuilder = MacroBuilder();
  final MacroRunner macroRunner = MacroRunner();

  MacroHost._(this.macroPackageConfig, this.macroServer, this._hostService);

  /// Starts a macro host with introspection queries handled by [queryService].
  static Future<MacroHost> serve({
    required Uri packageConfig,
    required QueryService queryService,
  }) async {
    final macroPackageConfig = MacroPackageConfig.readFromUri(packageConfig);
    final hostService = _HostService(queryService);
    final server = await MacroServer.serve(service: hostService);
    return MacroHost._(macroPackageConfig, server, hostService);
  }

  /// Whether [name] is a macro according to that package's `pubspec.yaml`.
  bool isMacro(QualifiedName name) => lookupMacroImplementation(name) != null;

  /// Checks whether [name] is a macro annotation.
  ///
  /// If so, returns the qualified name of the macro implementation.
  ///
  /// If not, returns `null`.
  QualifiedName? lookupMacroImplementation(QualifiedName name) =>
      macroPackageConfig.lookupMacroImplementation(name);

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
        name, HostRequest.augmentRequest(request, id: nextRequestId));
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
        return Response.macroStartedResponse(MacroStartedResponse(),
            requestId: request.id);
      case MacroRequestType.queryRequest:
        return Response.queryResponse(
            await queryService.handle(request.asQueryRequest),
            requestId: request.id);
      default:
        return Response.errorResponse(ErrorResponse(error: 'unsupported'),
            requestId: request.id);
    }
  }
}

/// Service provided by the frontend the host integrates with.
abstract interface class QueryService {
  Future<QueryResponse> handle(QueryRequest request);
}
