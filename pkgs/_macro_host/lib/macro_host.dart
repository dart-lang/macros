// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';

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
    // TODO(davidmorgan): support serving multiple protocols.
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
    return _hostService._macroState[annotation.asString]!.phases;
  }

  /// Sends [request] to the macro triggered by [annotation].
  Future<AugmentResponse> augment(
      QualifiedName annotation, AugmentRequest request) async {
    await _ensureRunning(annotation);

    final context = _ActiveHostRequest();
    final hostRequest = context.request = HostRequest.augmentRequest(
        macroAnnotation: annotation,
        request,
        id: nextRequestId,
        context: context.token);

    try {
      _hostService._activeRequests[context.token] = context;
      final response = await macroServer.sendToMacro(hostRequest);
      return response.asAugmentResponse;
    } finally {
      _hostService._activeRequests.remove(context.token);
    }
  }

  /// If the macro triggered by [annotation] is not running, builds it and
  /// launches it.
  Future<void> _ensureRunning(QualifiedName annotation) async {
    if (_hostService._macroState.containsKey(annotation.asString)) return;
    await buildAndRunMacro(annotation);
  }

  /// Builds and runs the macro triggered by [annotation].
  ///
  /// Throws if it's already running.
  Future<void> buildAndRunMacro(QualifiedName annotation) async {
    if (_hostService._macroState.containsKey(annotation.asString)) {
      throw StateError('Macro is already running: ${annotation.asString}');
    }
    // TODO(davidmorgan): additional state is needed to track that a macro
    // is still building; currently requests while the macro is building will
    // time out after 5s.
    _hostService._macroState[annotation.asString] = _MacroState();
    final macroBundle = await macroBuilder.build(
        macroPackageConfig.uri, [lookupMacroImplementation(annotation)!]);
    macroRunner.start(macroBundle: macroBundle, endpoint: macroServer.endpoint);
  }
}

class _HostService implements HostService {
  final QueryService queryService;

  /// Macro state by its annotation [QualifiedName] string representation.
  final Map<String, _MacroState> _macroState = {};

  /// Active request contexts, identified by their [_ActiveHostRequest.token].
  final Map<String, _ActiveHostRequest> _activeRequests = {};

  _HostService(this.queryService);

  /// Handle requests that are for the host.
  @override
  Future<Response> handle(MacroRequest request) async {
    switch (request.type) {
      case MacroRequestType.macroStartedRequest:
        final macroStartedRequest = request.asMacroStartedRequest;
        _macroState[macroStartedRequest.macroDescription.annotation.asString]!
            ._phasesCompleter
            .complete(
                macroStartedRequest.macroDescription.runsInPhases.toSet());
        return Response.macroStartedResponse(MacroStartedResponse(),
            requestId: request.id);
      case MacroRequestType.queryRequest:
        final context = _activeRequests[request.context];
        if (context == null) {
          return Response.errorResponse(ErrorResponse(error: 'Invalid token'),
              requestId: request.id);
        }
        final originalRequest = context.request;
        if (originalRequest?.type != HostRequestType.augmentRequest) {
          return Response.errorResponse(
              ErrorResponse(error: 'Must happen within augment request'),
              requestId: request.id);
        }

        final queryComponents = <Query>[];
        for (final entry in request.asQueryRequest.query.expandBatches()) {
          if (!QueryService._isValid(
              entry, originalRequest!.asAugmentRequest)) {
            return Response.errorResponse(
                ErrorResponse(error: 'Illegal query for phase.'),
                requestId: request.id);
          }

          queryComponents.add(entry);
        }

        return Response.queryResponse(
            await queryService.handle(queryComponents),
            requestId: request.id);
      default:
        return Response.errorResponse(ErrorResponse(error: 'unsupported'),
            requestId: request.id);
    }
  }
}

/// Service provided by the frontend the host integrates with.
abstract interface class QueryService {
  /// Handle a validated query request consisisting of the given [queries].
  ///
  /// [BatchQuery] instances in the requests are expanded at this point and not
  /// part of [queries].
  Future<QueryResponse> handle(List<Query> queries);

  /// Whether a macro is allowed to send [query] to answer the pending
  /// [augmentRequest].
  static bool _isValid(Query query, AugmentRequest augmentRequest) {
    if (query.type == QueryType.queryStaticType && augmentRequest.phase < 2) {
      return false;
    }

    // TODO: Investigate which other verification steps are necessary.
    return true;
  }
}

class _MacroState {
  // The first thing a macro does when it runs is sent a `MacroStartedRequest`
  // with its phases, so this value is expected as soon as the macro runs.
  final Completer<Set<int>> _phasesCompleter = Completer();
  Future<Set<int>> get phases => _phasesCompleter.future;
}

/// An active request sent to the macro for which a response has not yet been
/// received.
///
/// While e.g. a augmention request is active, the macro is allowed to send back
/// introspection queries. The exact set of queries depends on the running
/// augmentation request (and in particular its phase), so we need a way for a
/// macro to verify that a query is sent within the context of a known
/// augmentation. We use randomly-generated tokens for this purpose.
final class _ActiveHostRequest {
  final String token;
  HostRequest? request;

  _ActiveHostRequest() : token = generateToken();

  static String generateToken() {
    const length = 64;
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    final random = Random.secure();
    final tokenBuffer = StringBuffer();

    for (var i = 0; i < length; i++) {
      tokenBuffer.writeCharCode(
          characters.codeUnitAt(random.nextInt(characters.length)));
    }

    return tokenBuffer.toString();
  }
}
