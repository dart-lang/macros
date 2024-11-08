A tool for running and benchmarking with macros.

Specify a list of commands in addition to options:

  apply: runs macros, outputs to disk
  patch_for_analyzer: fixes macro output for the analyzer
  patch_for_cfe: fixes macro output for the CFE
  run: runs the specified script
  revert: reverts patches to files
  benchmark_apply: benchmarks applying macros
  benchmark_analyze: benchmarks analyzing macros
  bust_caches: modifies files like the benchmarks do
  watch: loops watching for changes to the specified script and applying

## Examples

All examples are run from the root of this repo.

Benchmarks require that you first create sources to benchmark with:

```bash
dart run benchmark_generator large macro 16
```

Benchmark running macros:

```bash
dart run _macro_tool \
    --workspace=goldens/foo/lib/generated/large \
    benchmark_apply
```

Benchmark analysis on macro output without running macros:

```bash
dart run _macro_tool \
    --workspace=goldens/foo/lib/generated/large \
    apply patch_for_analyzer benchmark_analyze revert
```

Run a script with macros:

```bash
dart run _macro_tool \
  --workspace=goldens/foo \
  --script=goldens/foo/lib/json_codable_test.dart \
  apply patch_for_cfe run revert
```

Watch for changes to a script, applying macros when it changes, writing the
output to disk and reporting how long it took:

```bash
dart run _macro_tool \
  --workspace=goldens/foo \
  --script=goldens/foo/lib/json_codable_test.dart \
  watch
```

Clean up output after using `watch`:

```bash
dart run _macro_tool \
  --workspace=goldens/foo \
  --script=goldens/foo/lib/json_codable_test.dart \
  revert
```
