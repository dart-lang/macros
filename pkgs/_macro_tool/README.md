A tool for running macro examples end to end.

## Example usage

The following will run the json_codable example, assuming you start at the root
of this repo:

```bash
dart pkgs/_macro_tool/bin/main.dart \
  --workspace=goldens/foo \
  --packageConfig=.dart_tool/package_config.json \
  --script=goldens/foo/lib/json_codable_test.dart
```

You can also enable watch mode using `--watch`.
