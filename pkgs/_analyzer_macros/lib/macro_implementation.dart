// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_macro_host/macro_host.dart';
// ignore: implementation_imports
import 'package:analyzer/src/summary2/macro_declarations.dart' as analyzer;
// ignore: implementation_imports
import 'package:analyzer/src/summary2/macro_injected_impl.dart' as injected;
import 'package:dart_model/dart_model.dart';
import 'package:macro_service/macro_service.dart';
import 'package:macros/macros.dart';
// ignore: implementation_imports
import 'package:macros/src/executor.dart' as injected;

import 'query_service.dart';

/// Injected macro implementation for the analyzer.
class AnalyzerMacroImplementation implements injected.MacroImplementation {
  final Uri packageConfig;
  final MacroHost _host;

  AnalyzerMacroImplementation._(this.packageConfig, this._host);

  /// Starts the macro host.
  ///
  /// [packageConfig] is the package config of the workspace of the code being
  /// edited.
  static Future<AnalyzerMacroImplementation> start({
    required Protocol protocol,
    required Uri packageConfig,
  }) async =>
      AnalyzerMacroImplementation._(
          packageConfig,
          await MacroHost.serve(
              // TODO(davidmorgan): this should be negotiated per client, not
              // set here.
              protocol: protocol,
              packageConfig: packageConfig,
              queryService: AnalyzerQueryService()));

  @override
  injected.MacroPackageConfigs get packageConfigs =>
      AnalyzerMacroPackageConfigs(this);

  @override
  injected.MacroRunner get runner => AnalyzerMacroRunner(this);
}

class AnalyzerMacroPackageConfigs implements injected.MacroPackageConfigs {
  final AnalyzerMacroImplementation _impl;

  AnalyzerMacroPackageConfigs(this._impl);

  @override
  bool isMacro(Uri uri, String name) =>
      _impl._host.isMacro(QualifiedName('$uri#$name'));
}

class AnalyzerMacroRunner implements injected.MacroRunner {
  final AnalyzerMacroImplementation _impl;

  AnalyzerMacroRunner(this._impl);

  @override
  injected.RunningMacro run(Uri uri, String name) => AnalyzerRunningMacro.run(
      _impl,
      QualifiedName('$uri#$name'),
      _impl._host.lookupMacroImplementation(QualifiedName('$uri#$name'))!);
}

class AnalyzerRunningMacro implements injected.RunningMacro {
  final AnalyzerMacroImplementation _impl;
  final QualifiedName name;
  final QualifiedName implementation;
  late final Future _started;

  AnalyzerRunningMacro._(this._impl, this.name, this.implementation);

  // TODO(davidmorgan): should this be async, removing the need for `_started`?
  // If so the API injected into analyzer+CFE needs to change to be async.
  static AnalyzerRunningMacro run(AnalyzerMacroImplementation impl,
      QualifiedName name, QualifiedName implementation) {
    final result = AnalyzerRunningMacro._(impl, name, implementation);
    // TODO(davidmorgan): this is currently what starts the macro running,
    // make it explicit.
    result._started =
        impl._host.queryMacroPhases(impl.packageConfig, implementation);
    return result;
  }

  @override
  Future<AnalyzerMacroExecutionResult> executeDeclarationsPhase(
      MacroTarget target,
      DeclarationPhaseIntrospector declarationsPhaseIntrospector) async {
    await _started;
    // TODO(davidmorgan): this is a hack to access analyzer internals; remove.
    introspector = declarationsPhaseIntrospector;
    return AnalyzerMacroExecutionResult(
        target,
        await _impl._host.augment(
            name, AugmentRequest(phase: 2, target: target.qualifiedName)));
  }

  @override
  Future<AnalyzerMacroExecutionResult> executeDefinitionsPhase(
      MacroTarget target,
      DefinitionPhaseIntrospector definitionPhaseIntrospector) async {
    await _started;
    // TODO(davidmorgan): this is a hack to access analyzer internals; remove.
    introspector = definitionPhaseIntrospector;
    return AnalyzerMacroExecutionResult(
        target,
        await _impl._host.augment(
            name, AugmentRequest(phase: 3, target: target.qualifiedName)));
  }

  @override
  Future<AnalyzerMacroExecutionResult> executeTypesPhase(
      MacroTarget target, TypePhaseIntrospector typePhaseIntrospector) async {
    await _started;
    // TODO(davidmorgan): this is a hack to access analyzer internals; remove.
    introspector = typePhaseIntrospector;
    return AnalyzerMacroExecutionResult(
        target,
        await _impl._host.augment(
            name, AugmentRequest(phase: 1, target: target.qualifiedName)));
  }
}

/// Converts [AugmentResponse] to [injected.MacroExecutionResult].
///
/// TODO(davidmorgan): add to `AugmentationResponse` to cover all the
/// functionality of `MacroExecutionResult`.
class AnalyzerMacroExecutionResult implements injected.MacroExecutionResult {
  final MacroTarget target;
  final AugmentResponse augmentResponse;

  AnalyzerMacroExecutionResult(this.target, this.augmentResponse);

  @override
  List<Diagnostic> get diagnostics => [];

  @override
  Map<Identifier, Iterable<DeclarationCode>> get enumValueAugmentations => {};

  @override
  MacroException? get exception => null;

  @override
  Map<Identifier, NamedTypeAnnotationCode> get extendsTypeAugmentations => {};

  @override
  Map<Identifier, Iterable<TypeAnnotationCode>> get interfaceAugmentations =>
      {};

  @override
  Iterable<DeclarationCode> get libraryAugmentations => {};

  @override
  Map<Identifier, Iterable<TypeAnnotationCode>> get mixinAugmentations => {};

  @override
  Iterable<String> get newTypeNames => [];

  @override
  void serialize(Object serializer) => throw UnimplementedError();

  @override
  Map<Identifier, Iterable<DeclarationCode>> get typeAugmentations => {
        // TODO(davidmorgan): this assumes augmentations are for the macro
        // application target. Instead, it should be explicit in
        // `AugmentResponse`.
        (target as Declaration).identifier: augmentResponse.augmentations
            .map((a) => DeclarationCode.fromParts([a.code]))
            .toList(),
      };
}

extension MacroTargetExtension on MacroTarget {
  QualifiedName get qualifiedName {
    final element =
        ((this as Declaration).identifier as analyzer.IdentifierImpl).element!;
    return QualifiedName(
        '${element.library!.definingCompilationUnit.source.uri}#'
        '${element.displayName}');
  }
}
