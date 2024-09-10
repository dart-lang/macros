// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_macro_host/macro_host.dart';
import 'package:dart_model/dart_model.dart';
// ignore: implementation_imports
import 'package:front_end/src/kernel/macro/identifiers.dart' as cfe;
// ignore: implementation_imports
import 'package:front_end/src/macros/macro_injected_impl.dart' as injected;
import 'package:macro_service/macro_service.dart';
import 'package:macros/macros.dart';
// ignore: implementation_imports
import 'package:macros/src/executor.dart' as injected;

import 'query_service.dart';

/// Injected macro implementation for the analyzer.
class CfeMacroImplementation implements injected.MacroImplementation {
  final Uri packageConfig;
  final MacroHost _host;

  CfeMacroImplementation._(this.packageConfig, this._host);

  /// Starts the macro host.
  ///
  /// [packageConfig] is the package config of the workspace of the code being
  /// edited.
  static Future<CfeMacroImplementation> start({
    // TODO(davidmorgan): this should be negotiated per client, not
    // set here.
    required Protocol protocol,
    required Uri packageConfig,
  }) async =>
      CfeMacroImplementation._(
          packageConfig,
          await MacroHost.serve(
              protocol: protocol,
              packageConfig: packageConfig,
              queryService: CfeQueryService()));

  @override
  injected.MacroPackageConfigs get packageConfigs =>
      CfeMacroPackageConfigs(this);

  @override
  injected.MacroRunner get macroRunner => CfeMacroRunner(this);
}

class CfeMacroPackageConfigs implements injected.MacroPackageConfigs {
  final CfeMacroImplementation _impl;

  CfeMacroPackageConfigs(this._impl);

  @override
  bool isMacro(Uri uri, String name) =>
      _impl._host.isMacro(QualifiedName(uri: '$uri', name: name));
}

class CfeMacroRunner implements injected.MacroRunner {
  final CfeMacroImplementation _impl;

  CfeMacroRunner(this._impl);

  @override
  injected.RunningMacro run(Uri uri, String name) => CfeRunningMacro.run(
      _impl,
      QualifiedName(uri: '$uri', name: name),
      _impl._host
          .lookupMacroImplementation(QualifiedName(uri: '$uri', name: name))!);
}

class CfeRunningMacro implements injected.RunningMacro {
  final CfeMacroImplementation _impl;
  final QualifiedName name;
  final QualifiedName implementation;

  CfeRunningMacro._(this._impl, this.name, this.implementation);

  static CfeRunningMacro run(CfeMacroImplementation impl, QualifiedName name,
      QualifiedName implementation) {
    return CfeRunningMacro._(impl, name, implementation);
  }

  @override
  Future<CfeMacroExecutionResult> executeDeclarationsPhase(MacroTarget target,
      DeclarationPhaseIntrospector declarationsPhaseIntrospector) async {
    // TODO(davidmorgan): this is a hack to access CFE internals; remove.
    introspector = declarationsPhaseIntrospector;
    return CfeMacroExecutionResult(
        target,
        await _impl._host.augment(
            name, AugmentRequest(phase: 2, target: target.qualifiedName)));
  }

  @override
  Future<CfeMacroExecutionResult> executeDefinitionsPhase(MacroTarget target,
      DefinitionPhaseIntrospector definitionPhaseIntrospector) async {
    // TODO(davidmorgan): this is a hack to access CFE internals; remove.
    introspector = definitionPhaseIntrospector;
    return CfeMacroExecutionResult(
        target,
        await _impl._host.augment(
            name, AugmentRequest(phase: 3, target: target.qualifiedName)));
  }

  @override
  Future<CfeMacroExecutionResult> executeTypesPhase(
      MacroTarget target, TypePhaseIntrospector typePhaseIntrospector) async {
    // TODO(davidmorgan): this is a hack to access CFE internals; remove.
    introspector = typePhaseIntrospector;
    return CfeMacroExecutionResult(
        target,
        await _impl._host.augment(
            name, AugmentRequest(phase: 1, target: target.qualifiedName)));
  }
}

/// Converts [AugmentResponse] to [injected.MacroExecutionResult].
///
/// TODO(davidmorgan): add to `AugmentationResponse` to cover all the
/// functionality of `MacroExecutionResult`.
class CfeMacroExecutionResult implements injected.MacroExecutionResult {
  final MacroTarget target;
  final AugmentResponse augmentResponse;

  CfeMacroExecutionResult(this.target, this.augmentResponse);

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
        // TODO(davidmorgan): empty augmentations response breaks the test,
        // it's not clear why.
        if (augmentResponse.augmentations.isNotEmpty)
          (target as Declaration).identifier: augmentResponse.augmentations
              .map((a) => DeclarationCode.fromParts([a.code]))
              .toList(),
      };
}

extension MacroTargetExtension on MacroTarget {
  QualifiedName get qualifiedName {
    final identifier = ((this as Declaration).identifier as cfe.IdentifierImpl)
        .resolveIdentifier();
    return QualifiedName(uri: '${identifier.uri}', name: identifier.name);
  }
}
