#!/usr/bin/env bash
set -e

echo "== Plex Toolkit consolidation tests =="

tests=(
  tests/test-library-runner.sh
  tests/test-cli-options.sh
  tests/test-exit-codes.sh
  tests/test-cli-errors.sh
  tests/test-command-errors.sh
  tests/test-logger.sh
)

for test_file in "${tests[@]}"; do
    echo "[TEST] $test_file"
    bash "$test_file"
done

echo "== All tests passed =="
