// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'json_buffer_builder.dart';

/// Methods for writing and reading "closed lists".
///
/// A "closed list" is a `List<Object?>` in a byte buffer that has all values
/// known at the time of writing.
extension ClosedLists on JsonBufferBuilder {
  // Layout: [length, ...entries]
  //
  // Each entry is: [key (pointer to string), value type, value].
  //
  // Values are stored with `_writeAny`.
  static const _valueSize = _typeSize + _pointerSize;

  /// Adds a `List` to the buffer, returns the [_Pointer] to it.
  ///
  /// The `List` should be small and already evaluated, making it fast to
  /// iterate.
  _Pointer _addClosedList(List<Object?> list) {
    _explanations?.push('addClosedList $list');

    final length = list.length;
    final pointer = _reserve(_lengthSize + length * _valueSize);

    _writeLength(pointer, length);

    var entryPointer = pointer + _lengthSize;
    for (final value in list) {
      _writeAny(entryPointer, value);
      entryPointer += _valueSize;
    }

    _explanations?.pop();
    return pointer;
  }

  /// Returns the [_ClosedList] at [pointer].
  List<Object?> _readClosedList(_Pointer pointer) {
    return _ClosedList(this, pointer);
  }
}

class _ClosedList with ListMixin<Object?> {
  final JsonBufferBuilder _buffer;
  final _Pointer _pointer;
  @override
  final int length;

  _ClosedList(this._buffer, this._pointer)
      : length = _buffer._readLength(_pointer);

  @override
  Object? operator [](int index) {
    RangeError.checkValidIndex(index, this);
    final iterator = _ClosedListIterator(_buffer, _pointer, length);
    for (var i = -1; i != index; ++i) {
      iterator.moveNext();
    }
    return iterator.current;
  }

  @override
  void operator []=(int index, Object? value) {
    throw UnsupportedError('This JsonBufferBuilder list is read-only.');
  }

  @override
  void add(Object? key) {
    throw UnsupportedError('This JsonBufferBuilder list is read-only.');
  }

  @override
  set length(int length) {
    throw UnsupportedError('This JsonBufferBuilder list is read-only.');
  }

  int fingerprint() {
    var iterator = _ClosedListHashIterator(_buffer, _pointer, length);
    var hash = 0;
    while (iterator.moveNext()) {
      hash = Object.hash(hash, iterator.current);
    }
    return hash;
  }
}

/// `Iterator` that reads a "closed list" in a [JsonBufferBuilder].
class _ClosedListIterator<T extends Object?> implements Iterator<T> {
  final JsonBufferBuilder _buffer;
  final _Pointer _last;
  _Pointer _pointer;

  _ClosedListIterator(this._buffer, _Pointer pointer, int length)
      : _last = pointer + _lengthSize + length * ClosedLists._valueSize,
        // Subtract because `moveNext` is called before reading.
        _pointer = pointer + _lengthSize - ClosedLists._valueSize;

  @override
  T get current => _buffer._readAny(_pointer) as T;

  @override
  bool moveNext() {
    if (_pointer == _last) return false;
    if (_pointer > _last) throw StateError('Moved past _last!');
    _pointer += ClosedLists._valueSize;
    return _pointer != _last;
  }
}

class _ClosedListHashIterator extends _ClosedListIterator<int> {
  _ClosedListHashIterator(super.buffer, super.pointer, super.length);

  @override
  int get current => _buffer.fingerprint(_pointer);
}
