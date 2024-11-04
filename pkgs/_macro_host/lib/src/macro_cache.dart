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
      queries: queryResults.map((q) => q.asCachedResult),
      response: response
    );
  }

  Future<AugmentResponse?> cachedResult(
      QualifiedName annotation, AugmentRequest request) async {
    final cacheKey = (
      annotation: annotation.asRecord,
      target: request.target.asRecord,
      phase: request.phase
    );
    final cached = _cache[cacheKey];
    if (cached == null) return null;

    Future<bool> checkQuery(_CachedQueryResult cachedQuery) async {
      var newResult = await Scope.query.run(
          () => queryService.handle(QueryRequest(query: cachedQuery.query)));
      return newResult.model.identityHash == cachedQuery.resultHash;
    }

    // TODO: Consider doing these in parallel?
    final checkedResults = await Future.wait(cached.queries.map(checkQuery));
    if (checkedResults.any((cached) => !cached)) {
      _cache.remove(cacheKey);
      return null;
    }
    return cached.response;
  }
}

typedef _MacroResultsCacheKey = ({
  QualifiedNameRecord annotation,
  QualifiedNameRecord target,
  int phase,
});

typedef _MacroResultsCacheValue = ({
  Iterable<_CachedQueryResult> queries,
  AugmentResponse response,
});

typedef _CachedQueryResult = ({
  Query query,
  int resultHash,
});

typedef QualifiedNameRecord = (
  String uri,
  String? scope,
  String name,
  bool? isStatic
);

extension on ({Query query, Model response}) {
  _CachedQueryResult get asCachedResult => (
        query: query,
        resultHash: response.identityHash,
      );
}

extension on QualifiedName {
  QualifiedNameRecord get asRecord => (uri, scope, name, isStatic);
}
