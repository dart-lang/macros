<!-- [![Dart CI](https://github.com/dart-lang/core/actions/workflows/dart.yml/badge.svg)](https://github.com/dart-lang/core/actions/workflows/dart.yml) -->

## Overview

> [!IMPORTANT]  
> This repository was a work-in-progress prototype for the
> [macros](https://github.com/dart-lang/language/blob/b268fe0380995b074176e335beec476553eb3c04/working/macros/feature-specification.md)
> feature, which was [canceled](https://medium.com/dartlang/an-update-on-dart-macros-data-serialization-06d3037d4f12)
> in January 2025.

For related work, see:

 - [Augmentations](https://github.com/dart-lang/language/blob/main/working/augmentation-libraries/feature-specification.md) feature
 - [`build_runner`](https://github.com/dart-lang/build/issues/3800) performance improvements
 - [Static Metaprogramming](https://github.com/dart-lang/language/issues/1482) feature request

## Packages

| Package | Description | Version |
|---|---|---|
| [_analyzer_macros](pkgs/_analyzer_macros/) | Macro support for the analyzer. |  |
| [_cfe_macros](pkgs/_cfe_macros/) | Macro support for the CFE. |  |
| [_macro_builder](pkgs/_macro_builder/) | Builds macros. |  |
| [_macro_client](pkgs/_macro_client/) | Connects user macro code to a macro host. |  |
| [_macro_host](pkgs/_macro_host/) | Hosts macros. |  |
| [_macro_runner](pkgs/_macro_runner/) | Runs macros. |  |
| [_macro_server](pkgs/_macro_server/) | Serves a `macro_service`. |  |
| [_test_macros](pkgs/_test_macros/) | Some test macros. |  |
| [dart_model](pkgs/dart_model/) | Data model for information about Dart code, queries about Dart code and augmentations to Dart code. Serializable with a versioned JSON schema for use by macros, generators and other tools. | [![pub package](https://img.shields.io/pub/v/dart_model.svg)](https://pub.dev/packages/dart_model) |
| [macro](pkgs/macro/) | For implementing a macro. | [![pub package](https://img.shields.io/pub/v/macro.svg)](https://pub.dev/packages/macro) |
| [macro_service](pkgs/macro_service/) | Macro communication with the macro host. | [![pub package](https://img.shields.io/pub/v/macro_service.svg)](https://pub.dev/packages/macro_service) |
| [generate_dart_model](tool/dart_model_generator/) |  |  |

## Publishing automation

For information about our publishing automation and release process, see
https://github.com/dart-lang/ecosystem/wiki/Publishing-automation.

For additional information about contributing, see our
[contributing](CONTRIBUTING.md) page.
