// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:macros/macros.dart';

macro class DeclareDefineConstructor implements ClassDeclarationsMacro, ClassDefinitionMacro {
  const DeclareDefineConstructor();

  Future<void> buildDeclarationsForClass(
      ClassDeclaration clazz, MemberDeclarationBuilder builder) async {
      builder.declareInType(DeclarationCode.fromParts([
        'external ',
        clazz.identifier.name,
        '.x();'
      ]));
  }

  Future<void> buildDefinitionForClass(
      ClassDeclaration clazz, TypeDefinitionBuilder typeBuilder) async {
    final constructors = await typeBuilder.constructorsOf(clazz);
    final x =
        constructors.singleWhere((c) => c.identifier.name == 'x');
    final builder = await typeBuilder.buildConstructor(x.identifier);
    builder.augment();
  }
}
