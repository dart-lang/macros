// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_model/dart_model.dart';
import 'package:test/test.dart';

void main() {
  group(Model, () {
    test('maps to JSON', () {
      final model = Model(uris: {
        'package:dart_model/dart_model.dart': Library(scopes: {
          'JsonData':
              Interface(properties: Properties(isClass: true), members: {
            '_root': Member(
              properties: Properties(isField: true),
            )
          })
        })
      });

      expect(model as Map, {
        'uris': {
          'package:dart_model/dart_model.dart': {
            'scopes': {
              'JsonData': {
                'members': {
                  '_root': {
                    'properties': {'isField': true}
                  }
                },
                'properties': {'isClass': true}
              }
            }
          }
        }
      });
    });
  });
}
