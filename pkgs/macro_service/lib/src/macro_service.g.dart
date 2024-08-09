// This file is generated. To make changes edit schemas/*.schema.json
// then run from the repo root: dart tool/model_generator/bin/main.dart

import 'package:dart_model/dart_model.dart';

/// A request to a macro to augment some code.
extension type AugmentRequest.fromJson(Map<String, Object?> node) {
  AugmentRequest({
    int? phase,
  }) : this.fromJson({
          if (phase != null) 'phase': phase,
        });

  /// Which phase to run: 1, 2 or 3.
  int get phase => node['phase'] as int;
}

/// Macro's response to an [AugmentRequest]: the resulting augmentations.
extension type AugmentResponse.fromJson(Map<String, Object?> node) {
  AugmentResponse({
    List<Augmentation>? augmentations,
  }) : this.fromJson({
          if (augmentations != null) 'augmentations': augmentations,
        });

  /// The augmentations.
  List<Augmentation> get augmentations =>
      (node['augmentations'] as List).cast();
}

/// Request could not be handled.
extension type ErrorResponse.fromJson(Map<String, Object?> node) {
  ErrorResponse({
    String? error,
  }) : this.fromJson({
          if (error != null) 'error': error,
        });

  /// The error.
  String get error => node['error'] as String;
}

/// A macro host server endpoint. TODO(davidmorgan): this should be a oneOf supporting different types of connection. TODO(davidmorgan): it's not clear if this belongs in this package! But, where else?
extension type HostEndpoint.fromJson(Map<String, Object?> node) {
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

extension type HostRequest.fromJson(Map<String, Object?> node) {
  static HostRequest augmentRequest(AugmentRequest augmentRequest) =>
      HostRequest.fromJson(
          {'type': 'AugmentRequest', 'value': augmentRequest.node});
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
}

/// Information about a macro that the macro provides to the host.
extension type MacroDescription.fromJson(Map<String, Object?> node) {
  MacroDescription({
    List<int>? runsInPhases,
  }) : this.fromJson({
          if (runsInPhases != null) 'runsInPhases': runsInPhases,
        });

  /// Phases that the macro runs in: 1, 2 and/or 3.
  List<int> get runsInPhases => (node['runsInPhases'] as List).cast();
}

/// Informs the host that a macro has started.
extension type MacroStartedRequest.fromJson(Map<String, Object?> node) {
  MacroStartedRequest({
    MacroDescription? macroDescription,
  }) : this.fromJson({
          if (macroDescription != null) 'macroDescription': macroDescription,
        });
  MacroDescription get macroDescription =>
      node['macroDescription'] as MacroDescription;
}

/// Host's response to a [MacroStartedRequest].
extension type MacroStartedResponse.fromJson(Map<String, Object?> node) {
  MacroStartedResponse() : this.fromJson({});
}

enum MacroRequestType {
  // Private so switches must have a default. See `isKnown`.
  _unknown,
  macroStartedRequest,
  queryRequest;

  bool get isKnown => this != _unknown;
}

extension type MacroRequest.fromJson(Map<String, Object?> node) {
  static MacroRequest macroStartedRequest(
          MacroStartedRequest macroStartedRequest) =>
      MacroRequest.fromJson(
          {'type': 'MacroStartedRequest', 'value': macroStartedRequest.node});
  static MacroRequest queryRequest(QueryRequest queryRequest) =>
      MacroRequest.fromJson(
          {'type': 'QueryRequest', 'value': queryRequest.node});
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
}

/// Macro's query about the code it should augment.
extension type QueryRequest.fromJson(Map<String, Object?> node) {
  QueryRequest({
    Query? query,
  }) : this.fromJson({
          if (query != null) 'query': query,
        });
  Query get query => node['query'] as Query;
}

/// Host's response to a [QueryRequest].
extension type QueryResponse.fromJson(Map<String, Object?> node) {
  QueryResponse({
    Model? model,
  }) : this.fromJson({
          if (model != null) 'model': model,
        });
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

extension type Response.fromJson(Map<String, Object?> node) {
  static Response augmentResponse(AugmentResponse augmentResponse) =>
      Response.fromJson(
          {'type': 'AugmentResponse', 'value': augmentResponse.node});
  static Response errorResponse(ErrorResponse errorResponse) =>
      Response.fromJson({'type': 'ErrorResponse', 'value': errorResponse.node});
  static Response macroStartedResponse(
          MacroStartedResponse macroStartedResponse) =>
      Response.fromJson(
          {'type': 'MacroStartedResponse', 'value': macroStartedResponse.node});
  static Response queryResponse(QueryResponse queryResponse) =>
      Response.fromJson({'type': 'QueryResponse', 'value': queryResponse.node});
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
}
