# Benchmark Generator

Generates code that uses macros, for benchmarking.

Example use, from the root of this package:

```
dart bin/main.dart large macro 64
dart ../../pkgs/_macro_tool/bin/main.dart \
    --workspace=../../goldens/foo \
    --packageConfig=../../.dart_tool/package_config.json \
    --script=../../goldens/foo/lib/generated/large/a0.dart \
    --host=analyzer --watch
```

then change `goldens/foo/lib/generated/large/a0.dart` to see the refresh time.
