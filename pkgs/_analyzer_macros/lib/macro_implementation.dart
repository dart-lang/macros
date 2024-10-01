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
import 'package:macros/macros.dart' as injected;
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
              // TODO(davidmorgan): support serving multiple protocols.
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
      _impl._host.isMacro(QualifiedName(uri: '$uri', name: name));
}

class AnalyzerMacroRunner implements injected.MacroRunner {
  final AnalyzerMacroImplementation _impl;

  AnalyzerMacroRunner(this._impl);

  @override
  injected.RunningMacro run(Uri uri, String name) => AnalyzerRunningMacro.run(
      _impl,
      QualifiedName(uri: '$uri', name: name),
      _impl._host
          .lookupMacroImplementation(QualifiedName(uri: '$uri', name: name))!);
}

class AnalyzerRunningMacro implements injected.RunningMacro {
  final AnalyzerMacroImplementation _impl;
  final QualifiedName name;
  final QualifiedName implementation;

  AnalyzerRunningMacro._(this._impl, this.name, this.implementation);

  static AnalyzerRunningMacro run(AnalyzerMacroImplementation impl,
      QualifiedName name, QualifiedName implementation) {
    return AnalyzerRunningMacro._(impl, name, implementation);
  }

  @override
  Future<AnalyzerMacroExecutionResult> executeDeclarationsPhase(
      injected.MacroTarget target,
      injected.DeclarationPhaseIntrospector
          declarationsPhaseIntrospector) async {
    // TODO(davidmorgan): this is a hack to access analyzer internals; remove.
    introspector = declarationsPhaseIntrospector;
    return await AnalyzerMacroExecutionResult.dartModelToInjected(
        target,
        await _impl._host.augment(
            name, AugmentRequest(phase: 2, target: target.qualifiedName)));
  }

  @override
  Future<AnalyzerMacroExecutionResult> executeDefinitionsPhase(
      injected.MacroTarget target,
      injected.DefinitionPhaseIntrospector definitionPhaseIntrospector) async {
    // TODO(davidmorgan): this is a hack to access analyzer internals; remove.
    introspector = definitionPhaseIntrospector;
    return await AnalyzerMacroExecutionResult.dartModelToInjected(
        target,
        await _impl._host.augment(
            name, AugmentRequest(phase: 3, target: target.qualifiedName)));
  }

  @override
  Future<AnalyzerMacroExecutionResult> executeTypesPhase(
      injected.MacroTarget target,
      injected.TypePhaseIntrospector typePhaseIntrospector) async {
    // TODO(davidmorgan): this is a hack to access analyzer internals; remove.
    introspector = typePhaseIntrospector;
    return await AnalyzerMacroExecutionResult.dartModelToInjected(
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
  final injected.MacroTarget target;
  @override
  final Map<injected.Identifier, Iterable<injected.DeclarationCode>>
      typeAugmentations;

  AnalyzerMacroExecutionResult(
      this.target, Iterable<injected.DeclarationCode> declarations)
      // TODO(davidmorgan): this assumes augmentations are for the macro
      // application target. Instead, it should be explicit in
      // `AugmentResponse`.
      : typeAugmentations = {
          (target as injected.Declaration).identifier: declarations
        };

  static Future<AnalyzerMacroExecutionResult> dartModelToInjected(
      injected.MacroTarget target, AugmentResponse augmentResponse) async {
    final declarations = <injected.DeclarationCode>[];
    for (final augmentation in augmentResponse.augmentations) {
      declarations.add(injected.DeclarationCode.fromParts(
          await _resolveNames(augmentation.code)));
    }
    return AnalyzerMacroExecutionResult(target, declarations);
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
    final element =
        ((this as injected.Declaration).identifier as analyzer.IdentifierImpl)
            .element!;
    return QualifiedName(
        uri: '${element.library!.definingCompilationUnit.source.uri}',
        name: element.displayName);
  }
}

/// Converts [codes] to a list of `String` and `Identifier`.
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
