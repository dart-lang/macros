// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'json_buffer_builder.dart';

/// Global hook for turning on "debug logs" for [JsonBufferBuilder].
///
/// Set to an instance of [Explanations] to turn on logging, reset to null to
/// turn off logging. If set, [JsonBufferBuilder#toString] will print
/// additional information for each byte.
///
/// TODO(davidmorgan): this is only intended for use in local unit tests.
/// If debug logs are useful elsewhere, do something more robust, but take
/// care not to degrade performance when logs are off.
Explanations? explanations;

/// Tracks why each byte in a [JsonBufferBuilder] was written, and does
/// additional checks.
class Explanations {
  final Map<int, String> _explanationsByPointer = {};
  final List<String> _explanationsStack = [];

  static const _allowOverwriteTag = ' [allowOverwrite]';

  /// Log what is being written.
  ///
  /// At the start of a method writing to the buffer, "push" details of the
  /// write. Then, call "explain" on every write to the buffer. The details
  /// will be logged. Finally, call "pop" before returning.
  void push(String explanation) {
    if (explanation.length > 40) {
      explanation = '${explanation.substring(0, 37)}...';
    }
    _explanationsStack.add(explanation);
  }

  /// Call at the end of a write method to "pop" from the explanations stack.
  void pop() {
    _explanationsStack.removeLast();
  }

  /// Associate the current explanation stack with [pointer].
  ///
  /// Set [allowOverwrite] if multiple writes to this location are allowed.
  /// Otherwise, this method throws on multiple writes.
  void explain(Pointer pointer, {bool allowOverwrite = false}) {
    if (_explanationsStack.isNotEmpty) {
      final explanation = _explanationsStack.join(', ') +
          (allowOverwrite ? _allowOverwriteTag : '');
      final oldExplanation = _explanationsByPointer[pointer];
      if (oldExplanation != null) {
        if (!allowOverwrite || !oldExplanation.contains(_allowOverwriteTag)) {
          throw StateError('Second write to $pointer!\n'
              '  Old explanation: ${_explanationsByPointer[pointer]}\n'
              '  New explanation: $explanation');
        }
      }
      _explanationsByPointer[pointer] = explanation;
    }
  }

  /// Associate the current explanation stack with all bytes [from] until [to].
  void explainRange(Pointer from, Pointer to) {
    for (var pointer = from; pointer != to; ++pointer) {
      explain(pointer);
    }
  }
}
