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
import 'package:macros/macros.dart' as injected;
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
    // TODO(davidmorgan): support serving multiple protocols.
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
  Future<CfeMacroExecutionResult> executeDeclarationsPhase(
      injected.MacroTarget target,
      injected.DeclarationPhaseIntrospector
          declarationsPhaseIntrospector) async {
    // TODO(davidmorgan): this is a hack to access CFE internals; remove.
    introspector = declarationsPhaseIntrospector;
    return await CfeMacroExecutionResult.dartModelToInjected(
        target,
        await _impl._host.augment(
            name, AugmentRequest(phase: 2, target: target.qualifiedName)));
  }

  @override
  Future<CfeMacroExecutionResult> executeDefinitionsPhase(
      injected.MacroTarget target,
      injected.DefinitionPhaseIntrospector definitionPhaseIntrospector) async {
    // TODO(davidmorgan): this is a hack to access CFE internals; remove.
    introspector = definitionPhaseIntrospector;
    return await CfeMacroExecutionResult.dartModelToInjected(
        target,
        await _impl._host.augment(
            name, AugmentRequest(phase: 3, target: target.qualifiedName)));
  }

  @override
  Future<CfeMacroExecutionResult> executeTypesPhase(injected.MacroTarget target,
      injected.TypePhaseIntrospector typePhaseIntrospector) async {
    // TODO(davidmorgan): this is a hack to access CFE internals; remove.
    introspector = typePhaseIntrospector;
    return await CfeMacroExecutionResult.dartModelToInjected(
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
  final injected.MacroTarget target;
  @override
  final Map<injected.Identifier, Iterable<injected.DeclarationCode>>
      typeAugmentations;

  CfeMacroExecutionResult(
      this.target, Iterable<injected.DeclarationCode> declarations)
      // TODO(davidmorgan): this assumes augmentations are for the macro
      // application target. Instead, it should be explicit in
      // `AugmentResponse`.
      : typeAugmentations = {
          // TODO(davidmorgan): empty augmentations response breaks the test,
          // it's not clear why.
          if (declarations.isNotEmpty)
            (target as injected.Declaration).identifier: declarations
        };

  static Future<CfeMacroExecutionResult> dartModelToInjected(
      injected.MacroTarget target, AugmentResponse augmentResponse) async {
    final declarations = <injected.DeclarationCode>[];
    for (final augmentation in augmentResponse.augmentations) {
      declarations.add(injected.DeclarationCode.fromParts(
          await _resolveNames(augmentation.code)));
    }
    return CfeMacroExecutionResult(target, declarations);
  }

  @override
  List<injected.Diagnostic> get diagnostics => [];

  @override
  Map<injected.Identifier, Iterable<injected.DeclarationCode>>
      get enumValueAugmentations => {};

  @override
  injected.MacroException? get exception => null;

  @override
  Map<injected.Identifier, injected.NamedTypeAnnotationCode>
      get extendsTypeAugmentations => {};

  @override
  Map<injected.Identifier, Iterable<injected.TypeAnnotationCode>>
      get interfaceAugmentations => {};

  @override
  Iterable<injected.DeclarationCode> get libraryAugmentations => {};

  @override
  Map<injected.Identifier, Iterable<injected.TypeAnnotationCode>>
      get mixinAugmentations => {};

  @override
  Iterable<String> get newTypeNames => [];

  @override
  void serialize(Object serializer) => throw UnimplementedError();
}

extension MacroTargetExtension on injected.MacroTarget {
  QualifiedName get qualifiedName {
    final identifier =
        ((this as injected.Declaration).identifier as cfe.IdentifierImpl)
            .resolveIdentifier();
    return QualifiedName(uri: '${identifier.uri}', name: identifier.name);
  }
}

/// Converts [codes] to a list of `String` and `Identifier`.
// TODO(davidmorgan): share this code with `package:_analyzer_macros`.
Future<List<Object>> _resolveNames(List<Code> codes) async {
  // Find the set of unique [QualifiedName]s used.
  final qualifiedNameStrings = <String>{};
  for (final code in codes) {
    if (code.type == CodeType.qualifiedName) {
      qualifiedNameStrings.add(code.asQualifiedName.asString);
    }
  }

  // Create futures looking up their [Identifier]s, then `await` in parallel.
  final qualifiedNamesList =
      qualifiedNameStrings.map(QualifiedName.parse).toList();
  final identifierFutures = <Future<injected.Identifier>>[];
  for (final qualifiedName in qualifiedNamesList) {
    identifierFutures.add((introspector as injected.TypePhaseIntrospector)
        // ignore: deprecated_member_use
        .resolveIdentifier(Uri.parse(qualifiedName.uri), qualifiedName.name));
  }
  final identifiers = await Future.wait(identifierFutures);

  // Build the result using the looked up [Identifier]s.
  final identifiersByQualifiedNameStrings =
      Map.fromIterables(qualifiedNameStrings, identifiers);
  final result = <Object>[];
  for (final code in codes) {
    if (code.type == CodeType.resolvedCode) {
      result.add(code.asResolvedCode.code);
    } else if (code.type == CodeType.qualifiedName) {
      final qualifiedName = code.asQualifiedName;
      result.add(identifiersByQualifiedNameStrings[qualifiedName.asString]!);
    }
  }
  return result;
}
