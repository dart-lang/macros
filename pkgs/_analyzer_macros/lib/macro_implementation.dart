// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_macro_host/macro_host.dart';
import 'package:analyzer/dart/element/element.dart';
// ignore: implementation_imports
import 'package:analyzer/src/summary2/macro_declarations.dart' as analyzer;
// ignore: implementation_imports
import 'package:analyzer/src/summary2/macro_injected_impl.dart' as injected;
import 'package:dart_model/dart_model.dart';
import 'package:macro_service/macro_service.dart';
import 'package:macros/macros.dart' as macros_api_v1;
// ignore: implementation_imports
import 'package:macros/src/executor.dart' as macros_api_v1;

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

  /// Queries for [target] and returns the [Model] representing the result.
  ///
  /// TODO: Make this a more limited query which doesn't fetch members.
  Future<Model> _queryTarget(QualifiedName target) =>
      Scope.query.run(() async => (await _impl._host.hostService.handle(
              MacroRequest.queryRequest(
                  QueryRequest(query: Query(target: target)),
                  id: nextRequestId)))
          .asQueryResponse
          .model);

  /// Cached macro results
  static final _declPhaseCachedResults = <
      // TODO: This is just the name of the class, yikes
      String,
      (
    List<(Query, Model)> queryResults,
    AugmentResponse macroResponse,
  )>{};

  @override
  Future<AnalyzerMacroExecutionResult> executeDeclarationsPhase(
      macros_api_v1.MacroTarget target,
      macros_api_v1.DeclarationPhaseIntrospector
          declarationsPhaseIntrospector) async {
    var watch = Stopwatch()..start();
    try {
      // TODO(davidmorgan): this is a hack to access analyzer internals; remove.
      introspector = declarationsPhaseIntrospector;

      final cached = _declPhaseCachedResults[
          // TODO: Obviously flawed
          (target as macros_api_v1.ClassDeclaration).identifier.name];
      AugmentResponse? response;
      if (cached != null) {
        var allWasCached = true;
        for (final (query, result) in cached.$1) {
          final newResult = await Scope.query.run(() async => (await _impl
                  ._host.hostService
                  .handle(MacroRequest.queryRequest(QueryRequest(query: query),
                      id: nextRequestId)))
              .asQueryResponse
              .model);
          if (result.identityHash != newResult.identityHash) {
            allWasCached = false;
            break;
          }
        }
        if (allWasCached) {
          response = cached.$2;
        }
      }
      if (response == null) {
        _impl._host.hostService.startTracking();
        response = await _impl._host.augment(
            name,
            AugmentRequest(
                phase: 2,
                target: target.qualifiedName,
                model: await _queryTarget(target.qualifiedName)));
        _declPhaseCachedResults[target.identifier.name] =
            (_impl._host.hostService.stopTracking(), response);
      }
      return await AnalyzerMacroExecutionResult.dartModelToInjected(
          target, response);
    } finally {
      print('executeDeclarationsPhase: ${watch.elapsedMilliseconds}ms');
    }
  }

  /// Cached macro results from the definitions phase.
  static final _definitionPhaseCachedResults = <
      // TODO: This is just the name of the class, yikes
      String,
      (
    List<(Query, Model)> queryResults,
    AugmentResponse macroResponse,
  )>{};

  @override
  Future<AnalyzerMacroExecutionResult> executeDefinitionsPhase(
      macros_api_v1.MacroTarget target,
      macros_api_v1.DefinitionPhaseIntrospector
          definitionPhaseIntrospector) async {
    var watch = Stopwatch()..start();
    try {
      // TODO(davidmorgan): this is a hack to access analyzer internals; remove.
      introspector = definitionPhaseIntrospector;

      final cached = _definitionPhaseCachedResults[
          // TODO: Obviously flawed
          (target as macros_api_v1.ClassDeclaration).identifier.name];
      AugmentResponse? response;
      if (cached != null) {
        var allWasCached = true;
        for (final (query, result) in cached.$1) {
          final newResult = await Scope.query.run(() async => (await _impl
                  ._host.hostService
                  .handle(MacroRequest.queryRequest(QueryRequest(query: query),
                      id: nextRequestId)))
              .asQueryResponse
              .model);
          if (result.identityHash != newResult.identityHash) {
            allWasCached = false;
            break;
          }
        }
        if (allWasCached) {
          response = cached.$2;
        }
      }

      if (response == null) {
        _impl._host.hostService.startTracking();
        response = await _impl._host.augment(
            name,
            AugmentRequest(
                phase: 3,
                target: target.qualifiedName,
                model: await _queryTarget(target.qualifiedName)));
        _definitionPhaseCachedResults[target.identifier.name] =
            (_impl._host.hostService.stopTracking(), response);
      }
      return await AnalyzerMacroExecutionResult.dartModelToInjected(
          target, response);
    } finally {
      print('executeDefinitionsPhase: ${watch.elapsedMilliseconds}ms');
    }
  }

  /// Cached macro results from the definitions phase.
  static final _typesPhaseCachedResults = <
      // TODO: This is just the name of the class, yikes
      String,
      (
    List<(Query, Model)> queryResults,
    AugmentResponse macroResponse,
  )>{};

  @override
  Future<AnalyzerMacroExecutionResult> executeTypesPhase(
      macros_api_v1.MacroTarget target,
      macros_api_v1.TypePhaseIntrospector typePhaseIntrospector) async {
    var watch = Stopwatch()..start();
    try {
      // TODO(davidmorgan): this is a hack to access analyzer internals; remove.
      introspector = typePhaseIntrospector;
      final cached = _typesPhaseCachedResults[
          // TODO: Obviously flawed
          (target as macros_api_v1.ClassDeclaration).identifier.name];
      AugmentResponse? response;
      if (cached != null) {
        var allWasCached = true;
        for (final (query, result) in cached.$1) {
          final newResult = await Scope.query.run(() async => (await _impl
                  ._host.hostService
                  .handle(MacroRequest.queryRequest(QueryRequest(query: query),
                      id: nextRequestId)))
              .asQueryResponse
              .model);
          if (result.identityHash != newResult.identityHash) {
            allWasCached = false;
            break;
          }
        }
        if (allWasCached) {
          response = cached.$2;
        }
      }
      if (response == null) {
        _impl._host.hostService.startTracking();
        response = await _impl._host.augment(
            name,
            AugmentRequest(
                phase: 1,
                target: target.qualifiedName,
                model: await _queryTarget(target.qualifiedName)));
        _typesPhaseCachedResults[target.identifier.name] =
            (_impl._host.hostService.stopTracking(), response);
      }
      return await AnalyzerMacroExecutionResult.dartModelToInjected(
          target, response);
    } finally {
      print('executeTypesPhase: ${watch.elapsedMilliseconds}ms');
    }
  }
}

/// Converts [AugmentResponse] to [macros_api_v1.MacroExecutionResult].
///
/// TODO(davidmorgan): add to `AugmentationResponse` to cover all the
/// functionality of `MacroExecutionResult`.
class AnalyzerMacroExecutionResult
    implements macros_api_v1.MacroExecutionResult {
  final macros_api_v1.MacroTarget target;
  @override
  final Map<macros_api_v1.Identifier, Iterable<macros_api_v1.DeclarationCode>>
      typeAugmentations;

  AnalyzerMacroExecutionResult(
      this.target, Iterable<macros_api_v1.DeclarationCode> declarations)
      // TODO(davidmorgan): this assumes augmentations are for the macro
      // application target. Instead, it should be explicit in
      // `AugmentResponse`.
      : typeAugmentations = {
          (target as macros_api_v1.Declaration).identifier: declarations
        };

  static Future<AnalyzerMacroExecutionResult> dartModelToInjected(
      macros_api_v1.MacroTarget target, AugmentResponse augmentResponse) async {
    final declarations = <macros_api_v1.DeclarationCode>[];
    if (augmentResponse.typeAugmentations?.isNotEmpty == true) {
      // TODO: Handle targets that are not interfaces, or test that this works
      // already.
      for (final entry in augmentResponse.typeAugmentations!.entries) {
        if (entry.key != target.qualifiedName.name) {
          throw UnimplementedError(
              'Type augmentations are only implemented when the type is the '
              'target of the augmentation, expected '
              '${target.qualifiedName.name} but got ${entry.key}');
        }
        for (final augmentation in entry.value) {
          declarations.add(macros_api_v1.DeclarationCode.fromParts(
              await _resolveNames(augmentation.code)));
        }
      }
    }

    for (final augmentation
        in augmentResponse.libraryAugmentations ?? const <Augmentation>[]) {
      declarations.add(macros_api_v1.DeclarationCode.fromParts(
          await _resolveNames(augmentation.code)));
    }

    if (augmentResponse.enumValueAugmentations?.isNotEmpty == true) {
      throw UnimplementedError('Enum value augmentations are not implemented');
    }
    if (augmentResponse.extendsTypeAugmentations?.isNotEmpty == true ||
        augmentResponse.interfaceAugmentations?.isNotEmpty == true ||
        augmentResponse.mixinAugmentations?.isNotEmpty == true) {
      throw UnimplementedError('Type augmentations are not implemented');
    }

    return AnalyzerMacroExecutionResult(target, declarations);
  }

  @override
  List<macros_api_v1.Diagnostic> get diagnostics => [];

  @override
  Map<macros_api_v1.Identifier, Iterable<macros_api_v1.DeclarationCode>>
      get enumValueAugmentations => {};

  @override
  macros_api_v1.MacroException? get exception => null;

  @override
  Map<macros_api_v1.Identifier, macros_api_v1.NamedTypeAnnotationCode>
      get extendsTypeAugmentations => {};

  @override
  Map<macros_api_v1.Identifier, Iterable<macros_api_v1.TypeAnnotationCode>>
      get interfaceAugmentations => {};

  @override
  Iterable<macros_api_v1.DeclarationCode> get libraryAugmentations => {};

  @override
  Map<macros_api_v1.Identifier, Iterable<macros_api_v1.TypeAnnotationCode>>
      get mixinAugmentations => {};

  @override
  Iterable<String> get newTypeNames => [];

  @override
  void serialize(Object serializer) => throw UnimplementedError();
}

extension MacroTargetExtension on macros_api_v1.MacroTarget {
  QualifiedName get qualifiedName {
    final element = ((this as macros_api_v1.Declaration).identifier
            as analyzer.IdentifierImpl)
        .element!;
    return element.qualifiedName;
  }
}

extension QualifiedNameForElement on Element {
  QualifiedName get qualifiedName {
    final uri = '${library!.definingCompilationUnit.source.uri}';
    final enclosingElement = enclosingElement3;
    if (enclosingElement == null) {
      throw UnsupportedError('Library macro targets are not yet supported');
    }
    final scope = (enclosingElement is LibraryElement ||
            enclosingElement is CompilationUnitElement)
        ? null
        : enclosingElement.displayName;
    final isStatic = scope == null
        ? null
        : switch (this) {
            ClassMemberElement self => self.isStatic,
            _ => throw UnimplementedError(
                'Cannot create a QualifiedName for $runtimeType'),
          };
    return QualifiedName(
        uri: uri, name: displayName, scope: scope, isStatic: isStatic);
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
  final identifierFutures = <Future<macros_api_v1.Identifier>>[];
  for (final qualifiedName in qualifiedNamesList) {
    identifierFutures.add((introspector as macros_api_v1.TypePhaseIntrospector)
        // ignore: deprecated_member_use
        .resolveIdentifier(Uri.parse(qualifiedName.uri), qualifiedName.name));
  }
  final identifiers = await Future.wait(identifierFutures);

  // Build the result using the looked up [Identifier]s.
  final identifiersByQualifiedNameStrings =
      Map.fromIterables(qualifiedNameStrings, identifiers);
  final result = <Object>[];
  for (final code in codes) {
    if (code.type == CodeType.string) {
      result.add(code.asString);
    } else if (code.type == CodeType.qualifiedName) {
      final qualifiedName = code.asQualifiedName;
      result.add(identifiersByQualifiedNameStrings[qualifiedName.asString]!);
    }
  }
  return result;
}
