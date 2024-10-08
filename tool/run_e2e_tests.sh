#!/bin/bash
#
# Runs tests under `goldens/foo` with macros applied.

# All paths below are relative to this script, change to script directory.
cd $(dirname ${BASH_SOURCE[0]})

echo "Testing goldens/foo/*_test.dart..."

for test_file in $(ls ../goldens/foo/lib/ | grep _test.dart); do
  echo "Testing $test_file..."
  if dart ../pkgs/_macro_tool/bin/main.dart \
      --workspace=../goldens/foo \
      --packageConfig=../.dart_tool/package_config.json \
      --script=../goldens/foo/lib/${test_file}; then
    echo "PASS"
  else
    echo "FAIL"
    # Fail fast: fail on first test failure.
    exit 1
  fi
done
