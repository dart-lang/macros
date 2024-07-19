// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:_macro_builder/macro_builder.dart';
import 'package:_macro_runner/macro_runner.dart';
import 'package:_macro_server/macro_server.dart';
import 'package:dart_model/dart_model.dart';
import 'package:macro_service/macro_service.dart';

/// Hosts macros: builds them, runs them, serves the macro service.
///
/// Tools that want to support macros, such as the Analyzer and the CFE, can
/// do so by running a `MacroHost` and providing their own `MacroService`.
class MacroHost implements MacroService {
  final MacroServer macroServer;
  final ListOfServices services;
  final MacroBuilder macroBuilder = MacroBuilder();
  final MacroRunner macroRunner = MacroRunner();

  // TODO(davidmorgan): this should be per macro, as part of tracking per-macro
  // lifecycle state.
  Set<int>? _macroPhases;

  MacroHost._(this.macroServer, this.services) {
    services.services.insert(0, this);
  }

  /// Starts a macro host serving the provided [service].
  ///
  /// The service passed in should handle introspection RPCs, it does not need
  /// to handle others.
  ///
  /// TODO(davidmorgan): make this split clearer, it should be in the protocol
  /// definition somewhere which requests the host handles.
  static Future<MacroHost> serve({required MacroService service}) async {
    final listOfServices = ListOfServices();
    listOfServices.services.add(service);
    final server = await MacroServer.serve(service: listOfServices);
    return MacroHost._(server, listOfServices);
  }

  /// Whether [name] is a macro according to that package's `pubspec.yaml`.
  bool isMacro(File packageConfig, QualifiedName name) {
    // TODO(language/3728): this is a placeholder, use package config when
    // available.
    return true;
  }

  /// Determines which phases the macro implemented at [name] runs in.
  Future<Set<int>> queryMacroPhases(
      File packageConfig, QualifiedName name) async {
    if (_macroPhases != null) return _macroPhases!;
    final macroBundle = await macroBuilder.build(packageConfig, [name]);
    macroRunner.run(macroBundle: macroBundle, endpoint: macroServer.endpoint);
    // TODO(davidmorgan): wait explicitly for the MacroStartedRequest to
    // arrive, remove this hard-coded wait.
    await Future<void>.delayed(const Duration(seconds: 2));
    return _macroPhases!;
  }

  /// Handle requests that are for the host.
  @override
  Future<Object?> handle(Object request) async {
    // TODO(davidmorgan): don't assume the type. Return `null` for types
    // that should be passed through to the service that was passed in.
    final macroStartedRequest =
        MacroStartedRequest.fromJson(request as Map<String, Object?>);
    _macroPhases = macroStartedRequest.macroDescription.runsInPhases.toSet();
    return MacroStartedResponse();
  }

  // TODO(davidmorgan): add method here for running macro phases.
}

// TODO(davidmorgan): this is used to handle some requests in the host while
// letting some fall through to the passed in service. Differentiate in a
// better way.
class ListOfServices implements MacroService {
  List<MacroService> services = [];

  @override
  Future<Object> handle(Object request) async {
    for (final service in services) {
      final result = await service.handle(request);
      if (result != null) return result;
    }
    throw StateError('No service handled: $request');
  }
}
