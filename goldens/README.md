# Golden Tests

Each `.dart` file under this path creates a test case in
`pkgs/_analyzer_macros/test/golden_test.dart` and
`pkgs/_cfe_macros/test/golden_test.dart`.

The test case looks for golden files next to the `.dart` file and asserts
that they match.

## Introspection

To test introspection, add `.analyzer.json` and/or `.cfe.json` golden files.
The JSON in the golden file is compared with the query output on the `.dart`
file, which must be tagged with the `QueryClass` macro.

## Application

To test macro application, add `.analyzer.augmentations` and/or
`.cfe.augmentations` golden files. These are compared with the full
macro augmentation output of the corresponding `.dart` file.
