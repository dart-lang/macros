// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

extension DeepCastMap<SK, SV> on Map<SK, SV> {
  /// A lazy deep cast map for `this`, where the values are deeply cast using
  /// the provided [castValue] function, and they keys are normally cast.
  Map<K, V> deepCast<K, V>(V Function(SV) castValue) =>
      _DeepCastMap(this, castValue);
}

/// Like a `CastMap`, except it can perform deep casts on values using a
/// provided conversion function.
class _DeepCastMap<SK, SV, K, V> extends MapBase<K, V> {
  final Map<SK, SV> _source;

  final V Function(SV) _castValue;

  _DeepCastMap(this._source, this._castValue);

  @override
  bool containsValue(Object? value) => _source.containsValue(value);

  @override
  bool containsKey(Object? key) => _source.containsKey(key);

  @override
  V? operator [](Object? key) {
    final value = _source[key];
    if (value == null) return null;
    return _castValue(value);
  }

  @override
  void operator []=(K key, V value) {
    _source[key as SK] = value as SV;
  }

  @override
  V putIfAbsent(K key, V Function() ifAbsent) =>
      _castValue(_source.putIfAbsent(key as SK, () => ifAbsent() as SV));

  @override
  V? remove(Object? key) {
    final removed = _source.remove(key);
    if (removed == null) return null;
    return _castValue(removed);
  }

  @override
  void clear() {
    _source.clear();
  }

  @override
  void forEach(void Function(K key, V value) f) {
    _source.forEach((SK key, SV value) {
      f(key as K, _castValue(value));
    });
  }

  @override
  Iterable<K> get keys => _source.keys.cast();

  @override
  Iterable<V> get values => _source.values.map(_castValue);

  @override
  int get length => _source.length;

  @override
  bool get isEmpty => _source.isEmpty;

  @override
  bool get isNotEmpty => _source.isNotEmpty;

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    return _castValue(_source.update(
        key as SK, (SV value) => update(_castValue(value)) as SV,
        ifAbsent: (ifAbsent == null) ? null : () => ifAbsent() as SV));
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    _source.updateAll(
        (SK key, SV value) => update(key as K, _castValue(value)) as SV);
  }

  @override
  Iterable<MapEntry<K, V>> get entries {
    return _source.entries.map<MapEntry<K, V>>((MapEntry<SK, SV> e) =>
        MapEntry<K, V>(e.key as K, _castValue(e.value)));
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> entries) {
    for (var entry in entries) {
      _source[entry.key as SK] = entry.value as SV;
    }
  }

  @override
  void removeWhere(bool Function(K key, V value) test) {
    _source
        .removeWhere((SK key, SV value) => test(key as K, _castValue(value)));
  }
}
