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
    // TODO(davidmorgan): this should be negotiated per client, not set here.
    required Protocol protocol,
    required Uri packageConfig,
    required QueryService queryService,
  }) async {
    final macroPackageConfig = MacroPackageConfig.readFromUri(packageConfig);
    final hostService = _HostService(queryService);
    final server =
        await MacroServer.serve(protocol: protocol, service: hostService);
    return MacroHost._(macroPackageConfig, server, hostService);
  }

  /// Whether [name] is a macro according to that package's `pubspec.yaml`.
  bool isMacro(QualifiedName name) => lookupMacroImplementation(name) != null;

  /// Checks whether [annotation] is a macro annotation.
  ///
  /// If so, returns the qualified name of the macro implementation.
  ///
  /// If not, returns `null`.
  QualifiedName? lookupMacroImplementation(QualifiedName annotation) =>
      macroPackageConfig.lookupMacroImplementation(annotation);

  /// Determines which phases the macro triggered by [annotation] runs in.
  Future<Set<int>> queryMacroPhases(
      Uri packageConfig, QualifiedName annotation) async {
    await _ensureRunning(annotation);
    return _hostService._macroState[annotation.string]!.phases;
  }

  /// Sends [request] to the macro triggered by [annotation].
  Future<AugmentResponse> augment(
      QualifiedName annotation, AugmentRequest request) async {
    await _ensureRunning(annotation);
    final response = await macroServer.sendToMacro(HostRequest.augmentRequest(
        macroAnnotation: annotation, request, id: nextRequestId));
    return response.asAugmentResponse;
  }

  /// If the macro triggered by [annotation] is not running, builds it and
  /// launches it.
  Future<void> _ensureRunning(QualifiedName annotation) async {
    if (_hostService._macroState.containsKey(annotation.string)) return;
    await buildAndRunMacro(annotation);
  }

  /// Builds and runs the macro triggered by [annotation].
  ///
  /// Throws if it's already running.
  Future<void> buildAndRunMacro(QualifiedName annotation) async {
    if (_hostService._macroState.containsKey(annotation.string)) {
      throw StateError('Macro is already running: ${annotation.string}');
    }
    // TODO(davidmorgan): additional state is needed to track that a macro
    // is still building; currently requests while the macro is building will
    // time out after 5s.
    _hostService._macroState[annotation.string] = _MacroState();
    final macroBundle = await macroBuilder.build(
        macroPackageConfig.uri, [lookupMacroImplementation(annotation)!]);
    macroRunner.start(
        macroBundle: macroBundle,
        protocol: macroServer.protocol,
        endpoint: macroServer.endpoint);
  }
}

class _HostService implements HostService {
  final QueryService queryService;

  /// Macro state by its annotation [QualifiedName] string representation.
  final Map<String, _MacroState> _macroState = {};

  _HostService(this.queryService);

  /// Handle requests that are for the host.
  @override
  Future<Response> handle(MacroRequest request) async {
    switch (request.type) {
      case MacroRequestType.macroStartedRequest:
        final macroStartedRequest = request.asMacroStartedRequest;
        _macroState[macroStartedRequest.macroDescription.annotation.string]!
            ._phasesCompleter
            .complete(
                macroStartedRequest.macroDescription.runsInPhases.toSet());
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

class _MacroState {
  // The first thing a macro does when it runs is sent a `MacroStartedRequest`
  // with its phases, so this value is expected as soon as the macro runs.
  final Completer<Set<int>> _phasesCompleter = Completer();
  Future<Set<int>> get phases => _phasesCompleter.future;
}
