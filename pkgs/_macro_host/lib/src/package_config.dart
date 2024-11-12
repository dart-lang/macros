// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:dart_model/dart_model.dart';
import 'package:package_config/package_config.dart';

/// Reads a package config to determine information about macros.
class MacroPackageConfig {
  final PackageConfig packageConfig;
  final Uri uri;

  MacroPackageConfig({required this.uri, required this.packageConfig});

  factory MacroPackageConfig.readFromUri(Uri uri) => MacroPackageConfig(
    uri: uri,
    packageConfig: PackageConfig.parseBytes(
      File.fromUri(uri).readAsBytesSync(),
      uri,
    ),
  );

  /// Checks whether [name] is a macro annotation.
  ///
  /// If so, returns the qualified name of the macro implementation.
  ///
  /// If not, returns `null`.
  ///
  /// This is a placeholder implementation until `language/3728` is
  /// implemented. It expects macros to be marked by a comment in the
  /// annotation package `pubspec.yaml` that looks like this:
  ///
  /// ```
  /// # macro <annotation name> <implementation name>
  /// ```
  ///
  /// For example:
  ///
  /// ```
  /// # macro lib/declare_x_macro.dart#DeclareX package:_test_macros/declare_x_macro.dart#DeclareXImplementation
  /// ```
  QualifiedName? lookupMacroImplementation(QualifiedName name) {
    var packageName = name.uri;
    if (packageName.startsWith('dart:') ||
        packageName.startsWith('org-dartlang-sdk:')) {
      return null;
    }
    // TODO(davidmorgan): error handling when lookup fails.
    if (packageName.startsWith('file:')) {
      packageName =
          packageConfig.toPackageUri(Uri.parse(packageName)).toString();
    }
    final libraryPathAndName =
        'lib/${packageName.substring(packageName.indexOf('/') + 1)}#${name.name}';
    if (packageName.startsWith('package:') && packageName.contains('/')) {
      packageName = packageName.substring('package:'.length);
      packageName = packageName.substring(0, packageName.indexOf('/'));
    } else {
      // TODO(davidmorgan): support macros outside lib dirs.
      throw ArgumentError('Name must start "package:" and have a path: $name');
    }

    final matchingPackage = packageConfig[packageName];
    if (matchingPackage == null) {
      throw StateError('Package "$packageName" not found in package config.');
    }

    // TODO(language/3728): read macro annotation identifiers from package
    // config. Until then, check the pubsec, to simulate what that feature will
    // do.
    final packageUri = matchingPackage.root;
    final pubspecUri = packageUri.resolve('pubspec.yaml');
    final lines = File.fromUri(pubspecUri).readAsLinesSync();

    final implsByLibraryQualifiedName = <String, QualifiedName>{};
    for (final line in lines) {
      if (!line.startsWith('# macro ')) continue;
      final items = line.split(' ');
      // The rest of the line should be the library qualified name of the
      // annotation then the fully qualified name of the implementation.
      implsByLibraryQualifiedName[items[2]] = QualifiedName.parse(items[3]);
    }

    return implsByLibraryQualifiedName[libraryPathAndName];
  }
}
