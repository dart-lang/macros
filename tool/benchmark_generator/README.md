# Benchmark Generator

Generates code that uses macros, for benchmarking.

Example use, from the root of this repo:

```
dart run benchmark_generator large macro 64
dart run _macro_tool \
    --workspace=goldens/foo \
    --packageConfig=.dart_tool/package_config.json \
    --script=goldens/foo/lib/generated/large/a0.dart \
    --host=analyzer watch
```

then change `goldens/foo/lib/generated/large/a0.dart` to see the refresh time.
