// This file is generated. To make changes edit tool/dart_model_generator
// then run from the repo root: dart tool/dart_model_generator/bin/main.dart

// ignore: implementation_imports,unused_import,prefer_relative_imports
import 'dart:typed_data';
// ignore: implementation_imports,unused_import,prefer_relative_imports
import 'package:crypto/crypto.dart';
// ignore: implementation_imports,unused_import,prefer_relative_imports
import 'package:dart_model/src/dart_model.g.dart';
// ignore: implementation_imports,unused_import,prefer_relative_imports
import 'package:dart_model/src/deep_cast_map.dart';
// ignore: implementation_imports,unused_import,prefer_relative_imports
import 'package:dart_model/src/json_buffer/json_buffer_builder.dart';
// ignore: implementation_imports,unused_import,prefer_relative_imports
import 'package:dart_model/src/scopes.dart';

/// A request to a macro to augment some code.
extension type AugmentRequest.fromJson(Map<String, Object?> node)
    implements Object {
  AugmentRequest({
    required int phase,
    required QualifiedName target,
    required Model model,
  }) : this.fromJson({
          'phase': phase,
          'target': target,
          'model': model,
        });

  /// Which phase to run: 1, 2 or 3.
  int get phase => node['phase'] as int;

  /// The class to augment. TODO(davidmorgan): expand to more types of target.
  QualifiedName get target => node['target'] as QualifiedName;

  /// A pre-computed query result for the target.
  Model get model => node['model'] as Model;
}

/// Macro's response to an [AugmentRequest]: the resulting augmentations.
extension type AugmentResponse.fromJson(Map<String, Object?> node)
    implements Object {
  AugmentResponse({
    List<Augmentation>? libraryAugmentations,
    List<String>? newTypeNames,
  }) : this.fromJson({
          'enumValueAugmentations': <String, Object?>{},
          'extendsTypeAugmentations': <String, Object?>{},
          'interfaceAugmentations': <String, Object?>{},
          if (libraryAugmentations != null)
            'libraryAugmentations': libraryAugmentations,
          'mixinAugmentations': <String, Object?>{},
          if (newTypeNames != null) 'newTypeNames': newTypeNames,
          'typeAugmentations': <String, Object?>{},
        });

  /// Any augmentations to enum values that should be applied to an enum as a result of executing a macro, indexed by the name of the enum.
  Map<String, List<Augmentation>>? get enumValueAugmentations =>
      (node['enumValueAugmentations'] as Map?)
          ?.deepCast<String, List<Augmentation>>((v) => (v as List).cast());

  /// Any extends clauses that should be added to types as a result of executing a macro, indexed by the name of the augmented type declaration.
  Map<String, List<Augmentation>>? get extendsTypeAugmentations =>
      (node['extendsTypeAugmentations'] as Map?)
          ?.deepCast<String, List<Augmentation>>((v) => (v as List).cast());

  /// Any interfaces that should be added to types as a result of executing a macro, indexed by the name of the augmented type declaration.
  Map<String, List<Augmentation>>? get interfaceAugmentations =>
      (node['interfaceAugmentations'] as Map?)
          ?.deepCast<String, List<Augmentation>>((v) => (v as List).cast());

  /// Any augmentations that should be applied to the library as a result of executing a macro.
  List<Augmentation>? get libraryAugmentations =>
      (node['libraryAugmentations'] as List?)?.cast();

  /// Any mixins that should be added to types as a result of executing a macro, indexed by the name of the augmented type declaration.
  Map<String, List<Augmentation>>? get mixinAugmentations =>
      (node['mixinAugmentations'] as Map?)
          ?.deepCast<String, List<Augmentation>>((v) => (v as List).cast());

  /// The names of any new types declared in [libraryAugmentations].
  List<String>? get newTypeNames => (node['newTypeNames'] as List?)?.cast();

  /// Any augmentations that should be applied to a class as a result of executing a macro, indexed by the name of the class.
  Map<String, List<Augmentation>>? get typeAugmentations =>
      (node['typeAugmentations'] as Map?)
          ?.deepCast<String, List<Augmentation>>((v) => (v as List).cast());
}

/// Request could not be handled.
extension type ErrorResponse.fromJson(Map<String, Object?> node)
    implements Object {
  ErrorResponse({
    String? error,
  }) : this.fromJson({
          if (error != null) 'error': error,
        });

  /// The error.
  String get error => node['error'] as String;
}

/// A macro host server endpoint. TODO(davidmorgan): this should be a oneOf supporting different types of connection. TODO(davidmorgan): it's not clear if this belongs in this package! But, where else?
extension type HostEndpoint.fromJson(Map<String, Object?> node)
    implements Object {
  HostEndpoint({
    int? port,
  }) : this.fromJson({
          if (port != null) 'port': port,
        });

  /// TCP port to connect to.
  int get port => node['port'] as int;
}

enum HostRequestType {
  // Private so switches must have a default. See `isKnown`.
  _unknown,
  augmentRequest;

  bool get isKnown => this != _unknown;
}

extension type HostRequest.fromJson(Map<String, Object?> node)
    implements Object {
  static HostRequest augmentRequest(
    AugmentRequest augmentRequest, {
    required int id,
    QualifiedName? macroAnnotation,
  }) =>
      HostRequest.fromJson({
        'type': 'AugmentRequest',
        'value': augmentRequest,
        'id': id,
        if (macroAnnotation != null) 'macroAnnotation': macroAnnotation,
      });
  HostRequestType get type {
    switch (node['type'] as String) {
      case 'AugmentRequest':
        return HostRequestType.augmentRequest;
      default:
        return HostRequestType._unknown;
    }
  }

  AugmentRequest get asAugmentRequest {
    if (node['type'] != 'AugmentRequest') {
      throw StateError('Not a AugmentRequest.');
    }
    return AugmentRequest.fromJson(node['value'] as Map<String, Object?>);
  }

  /// The id of this request, must be returned in responses.
  int get id => node['id'] as int;

  /// The annotation identifying the macro that should handle the request.
  QualifiedName get macroAnnotation => node['macroAnnotation'] as QualifiedName;
}

/// Information about a macro that the macro provides to the host.
extension type MacroDescription.fromJson(Map<String, Object?> node)
    implements Object {
  MacroDescription({
    QualifiedName? annotation,
    List<int>? runsInPhases,
  }) : this.fromJson({
          if (annotation != null) 'annotation': annotation,
          if (runsInPhases != null) 'runsInPhases': runsInPhases,
        });

  /// The annotation that triggers the macro.
  QualifiedName get annotation => node['annotation'] as QualifiedName;

  /// Phases that the macro runs in: 1, 2 and/or 3.
  List<int> get runsInPhases => (node['runsInPhases'] as List).cast();
}

/// Informs the host that a macro has started.
extension type MacroStartedRequest.fromJson(Map<String, Object?> node)
    implements Object {
  MacroStartedRequest({
    MacroDescription? macroDescription,
  }) : this.fromJson({
          if (macroDescription != null) 'macroDescription': macroDescription,
        });

  /// The macro description.
  MacroDescription get macroDescription =>
      node['macroDescription'] as MacroDescription;
}

/// Host's response to a [MacroStartedRequest].
extension type MacroStartedResponse.fromJson(Map<String, Object?> node)
    implements Object {
  MacroStartedResponse() : this.fromJson({});
}

enum MacroRequestType {
  // Private so switches must have a default. See `isKnown`.
  _unknown,
  macroStartedRequest,
  queryRequest;

  bool get isKnown => this != _unknown;
}

extension type MacroRequest.fromJson(Map<String, Object?> node)
    implements Object {
  static MacroRequest macroStartedRequest(
    MacroStartedRequest macroStartedRequest, {
    required int id,
  }) =>
      MacroRequest.fromJson({
        'type': 'MacroStartedRequest',
        'value': macroStartedRequest,
        'id': id,
      });
  static MacroRequest queryRequest(
    QueryRequest queryRequest, {
    required int id,
  }) =>
      MacroRequest.fromJson({
        'type': 'QueryRequest',
        'value': queryRequest,
        'id': id,
      });
  MacroRequestType get type {
    switch (node['type'] as String) {
      case 'MacroStartedRequest':
        return MacroRequestType.macroStartedRequest;
      case 'QueryRequest':
        return MacroRequestType.queryRequest;
      default:
        return MacroRequestType._unknown;
    }
  }

  MacroStartedRequest get asMacroStartedRequest {
    if (node['type'] != 'MacroStartedRequest') {
      throw StateError('Not a MacroStartedRequest.');
    }
    return MacroStartedRequest.fromJson(node['value'] as Map<String, Object?>);
  }

  QueryRequest get asQueryRequest {
    if (node['type'] != 'QueryRequest') {
      throw StateError('Not a QueryRequest.');
    }
    return QueryRequest.fromJson(node['value'] as Map<String, Object?>);
  }

  /// The id of this request, must be returned in responses.
  int get id => node['id'] as int;
}

/// Macro's query about the code it should augment.
extension type QueryRequest.fromJson(Map<String, Object?> node)
    implements Object {
  QueryRequest({
    Query? query,
  }) : this.fromJson({
          if (query != null) 'query': query,
        });

  /// The query.
  Query get query => node['query'] as Query;
}

/// Host's response to a [QueryRequest].
extension type QueryResponse.fromJson(Map<String, Object?> node)
    implements Object {
  QueryResponse({
    Model? model,
  }) : this.fromJson({
          if (model != null) 'model': model,
        });

  /// The model.
  Model get model => node['model'] as Model;
}

enum ResponseType {
  // Private so switches must have a default. See `isKnown`.
  _unknown,
  augmentResponse,
  errorResponse,
  macroStartedResponse,
  queryResponse;

  bool get isKnown => this != _unknown;
}

extension type Response.fromJson(Map<String, Object?> node) implements Object {
  static Response augmentResponse(
    AugmentResponse augmentResponse, {
    required int requestId,
  }) =>
      Response.fromJson({
        'type': 'AugmentResponse',
        'value': augmentResponse,
        'requestId': requestId,
      });
  static Response errorResponse(
    ErrorResponse errorResponse, {
    required int requestId,
  }) =>
      Response.fromJson({
        'type': 'ErrorResponse',
        'value': errorResponse,
        'requestId': requestId,
      });
  static Response macroStartedResponse(
    MacroStartedResponse macroStartedResponse, {
    required int requestId,
  }) =>
      Response.fromJson({
        'type': 'MacroStartedResponse',
        'value': macroStartedResponse,
        'requestId': requestId,
      });
  static Response queryResponse(
    QueryResponse queryResponse, {
    required int requestId,
  }) =>
      Response.fromJson({
        'type': 'QueryResponse',
        'value': queryResponse,
        'requestId': requestId,
      });
  ResponseType get type {
    switch (node['type'] as String) {
      case 'AugmentResponse':
        return ResponseType.augmentResponse;
      case 'ErrorResponse':
        return ResponseType.errorResponse;
      case 'MacroStartedResponse':
        return ResponseType.macroStartedResponse;
      case 'QueryResponse':
        return ResponseType.queryResponse;
      default:
        return ResponseType._unknown;
    }
  }

  AugmentResponse get asAugmentResponse {
    if (node['type'] != 'AugmentResponse') {
      throw StateError('Not a AugmentResponse.');
    }
    return AugmentResponse.fromJson(node['value'] as Map<String, Object?>);
  }

  ErrorResponse get asErrorResponse {
    if (node['type'] != 'ErrorResponse') {
      throw StateError('Not a ErrorResponse.');
    }
    return ErrorResponse.fromJson(node['value'] as Map<String, Object?>);
  }

  MacroStartedResponse get asMacroStartedResponse {
    if (node['type'] != 'MacroStartedResponse') {
      throw StateError('Not a MacroStartedResponse.');
    }
    return MacroStartedResponse.fromJson(node['value'] as Map<String, Object?>);
  }

  QueryResponse get asQueryResponse {
    if (node['type'] != 'QueryResponse') {
      throw StateError('Not a QueryResponse.');
    }
    return QueryResponse.fromJson(node['value'] as Map<String, Object?>);
  }

  /// The id of the request this is responding to.
  int get requestId => node['requestId'] as int;
}
