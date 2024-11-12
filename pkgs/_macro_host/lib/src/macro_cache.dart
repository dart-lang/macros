// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';
import 'package:macro_service/macro_service.dart';

import 'macro_host.dart';

class MacroResultsCache {
  final _cache = <_MacroResultsCacheKey, _MacroResultsCacheValue>{};

  final QueryService queryService;

  MacroResultsCache(this.queryService);

  /// Adds an entry into the cache.
  ///
  /// The cache keys are a combined value of the [annotation], and [request].
  ///
  /// The caceh values are based on each query in [queryResults] and a digest of
  /// the [Model] response for that query.
  void cache({
    required QualifiedName annotation,
    required AugmentRequest request,
    required Iterable<({Query query, Model response})> queryResults,
    required AugmentResponse response,
  }) {
    _cache[(
      annotation: annotation.asRecord,
      target: request.target.asRecord,
      phase: request.phase,
    )] = (
      queries: queryResults.map((q) => q.query),
      resultsHash:
          queryResults
              .skip(1)
              .fold(
                queryResults.first.response,
                (model, next) => model.mergeWith(next.response),
              )
              .fingerprint,
      response: response,
    );
  }

  /// Returns a cached result for the given augmentation request, if there is
  /// one and it is still valid.
  ///
  /// Otherwise, invalidates the cache for this request and returns `null`.
  Future<AugmentResponse?> cachedResult(
    QualifiedName annotation,
    AugmentRequest request,
  ) async {
    final cacheKey = (
      annotation: annotation.asRecord,
      target: request.target.asRecord,
      phase: request.phase,
    );
    final cached = _cache[cacheKey];
    if (cached == null) return null;

    final queryResults = await Scope.query.run(
      () => Future.wait(
        cached.queries.map(
          (query) => queryService.handle(QueryRequest(query: query)),
        ),
      ),
    );
    final newResultsHash =
        queryResults
            .skip(1)
            .fold(
              queryResults.first.model,
              (model, next) => model.mergeWith(next.model),
            )
            .fingerprint;
    if (newResultsHash != cached.resultsHash) {
      _cache.remove(cacheKey);
      return null;
    }
    return cached.response;
  }
}

typedef _MacroResultsCacheKey =
    ({QualifiedNameRecord annotation, QualifiedNameRecord target, int phase});

typedef _MacroResultsCacheValue =
    ({
      /// All queries done by a macro in a given phase.
      Iterable<Query> queries,

      /// The `identityHash` of the merged model from all query responses.
      int resultsHash,

      /// The macro augmentation response that was cached.
      AugmentResponse response,
    });

typedef QualifiedNameRecord =
    (String uri, String? scope, String name, bool? isStatic);

extension on QualifiedName {
  QualifiedNameRecord get asRecord => (uri, scope, name, isStatic);
}
