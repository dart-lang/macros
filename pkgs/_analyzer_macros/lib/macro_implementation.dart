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
      MacroTarget target,
      DeclarationPhaseIntrospector declarationsPhaseIntrospector) async {
    // TODO(davidmorgan): this is a hack to access analyzer internals; remove.
    introspector = declarationsPhaseIntrospector;
    return await AnalyzerMacroExecutionResult.expandTemplates(
        target,
        await _impl._host.augment(
            name, AugmentRequest(phase: 2, target: target.qualifiedName)));
  }

  @override
  Future<AnalyzerMacroExecutionResult> executeDefinitionsPhase(
      MacroTarget target,
      DefinitionPhaseIntrospector definitionPhaseIntrospector) async {
    // TODO(davidmorgan): this is a hack to access analyzer internals; remove.
    introspector = definitionPhaseIntrospector;
    return await AnalyzerMacroExecutionResult.expandTemplates(
        target,
        await _impl._host.augment(
            name, AugmentRequest(phase: 3, target: target.qualifiedName)));
  }

  @override
  Future<AnalyzerMacroExecutionResult> executeTypesPhase(
      MacroTarget target, TypePhaseIntrospector typePhaseIntrospector) async {
    // TODO(davidmorgan): this is a hack to access analyzer internals; remove.
    introspector = typePhaseIntrospector;
    return await AnalyzerMacroExecutionResult.expandTemplates(
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
  @override
  final Map<Identifier, Iterable<DeclarationCode>> typeAugmentations;

  AnalyzerMacroExecutionResult(
      this.target, Iterable<DeclarationCode> declarations)
      // TODO(davidmorgan): this assumes augmentations are for the macro
      // application target. Instead, it should be explicit in
      // `AugmentResponse`.
      : typeAugmentations = {(target as Declaration).identifier: declarations};

  static Future<AnalyzerMacroExecutionResult> expandTemplates(
      MacroTarget target, AugmentResponse augmentResponse) async {
    final declarations = <DeclarationCode>[];
    for (final augmentation in augmentResponse.augmentations) {
      declarations.add(
          DeclarationCode.fromParts(await _expandTemplates(augmentation.code)));
    }
    return AnalyzerMacroExecutionResult(target, declarations);
  }

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
}

extension MacroTargetExtension on MacroTarget {
  QualifiedName get qualifiedName {
    final element =
        ((this as Declaration).identifier as analyzer.IdentifierImpl).element!;
    return QualifiedName(
        uri: '${element.library!.definingCompilationUnit.source.uri}',
        name: element.displayName);
  }
}

/// Converts [code] to a mix of `Identifier` and `String`.
///
/// Looks up references of the form `{{uri#name}}` using `resolveIdentifier`.
///
/// TODO(davidmorgan): move to the client side.
Future<List<Object>> _expandTemplates(String code) async {
  final result = <Object>[];
  var index = 0;
  while (index < code.length) {
    final start = code.indexOf('{{', index);
    if (start == -1) {
      result.add(code.substring(index));
      break;
    }
    result.add(code.substring(index, start));
    final end = code.indexOf('}}', start);
    if (end == -1) {
      throw ArgumentError('Unmatched opening brace: $code');
    }
    final name = code.substring(start + 2, end);
    final parts = name.split('#');
    if (parts.length != 2) {
      throw ArgumentError('Expected "uri#name" in: $name');
    }
    final uri = Uri.parse(parts[0]);
    final identifier = await (introspector as TypePhaseIntrospector)
        // ignore: deprecated_member_use
        .resolveIdentifier(uri, parts[1]);
    result.add(identifier);
    index = end + 2;
  }
  return result;
}
