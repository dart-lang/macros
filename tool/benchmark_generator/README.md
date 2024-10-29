# Benchmark Generator

Generates code that uses macros, for benchmarking.

Example use:

```
dart bin/main.dart large macro 64
dart ~/git/macros/pkgs/_macro_tool/bin/main.dart \
    --workspace=$HOME/git/macros/goldens/foo \
    --packageConfig=$HOME/git/macros/.dart_tool/package_config.json \
    --script=$HOME/git/macros/goldens/foo/lib/generated/large/a0.dart \
    --host=analyzer --watch
```

then change `goldens/foo/lib/generated/large/a0.dart` to see the refresh time.
