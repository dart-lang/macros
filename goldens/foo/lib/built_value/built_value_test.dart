// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_test_macros/built_value.dart';
import 'package:test/test.dart';

void main() {
  group('Empty class', () {
    test('instantiation, builder, rebuild, comparison', () {
      final value = Empty();
      final sameValue = value.rebuild((b) {});
      expect(sameValue, value);

      // analyzer: The function 'EmptyBuilder' isn't defined.
      // final valueBuilder = EmptyBuilder();
      // final value3 = valueBuilder.build();
      // expect(value3, value);
    });
  });

  group('Class with primitive fields', () {
    test('instantiation, builder, rebuild, comparison, hash code, '
        'toString', () {
      final value = PrimitiveFields(
        (b) =>
            b
              ..anInt = 3
              ..aString = 'four',
      );
      final value2 = value.rebuild(
        (b) =>
            b
              ..anInt = 4
              ..aString = 'five',
      );
      expect(value2, isNot(value));
      expect(value2.hashCode, isNot(value.hashCode));
      expect(
        value2.toString(),
        'PrimitiveFields(anInt: 4, aString: five, aNullableString: null)',
      );

      final sameValue = value.rebuild((b) => b);
      expect(sameValue, value);
      expect(sameValue.hashCode, value.hashCode);
    });
  });

  group('Class with nested fields', () {
    test('has nested builder', () {
      final value = NestedFields(
        (b) =>
            b
              ..aPrimitiveFields.anInt = 3
              ..aPrimitiveFields.aString = 'four'
              ..aString = 'five'
              ..stringWrapper = StringWrapper('six'),
      );
      expect(
        value.toString(),
        'NestedFields(aPrimitiveFields: PrimitiveFields('
        'anInt: 3, aString: four, aNullableString: null), '
        'stringWrapper: StringWrapper(aString: six), aString: five)',
      );
    });
  });
}

class NonMacro {
  const NonMacro();
}

@NonMacro()
class StringWrapper {
  const StringWrapper(this.aString);

  final String aString;

  @override
  String toString() => 'StringWrapper(aString: $aString)';
}

@BuiltValue()
class Empty {}

@BuiltValue()
class PrimitiveFields {
  final int anInt;
  final String aString;
  final String? aNullableString;
}

@BuiltValue()
class NestedFields {
  final PrimitiveFields aPrimitiveFields;
  final StringWrapper stringWrapper;
  final String aString;
}
