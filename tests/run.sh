#!/usr/bin/env bash
set -u

TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$TEST_DIR/.." && pwd)"
cd "$ROOT" || exit 1

passed=0
failed=0
skipped=0

echo "== Plex Toolkit test suite =="
echo

for test_file in "$TEST_DIR"/test-*.sh; do
    [[ -f "$test_file" ]] || continue
    name="$(basename "$test_file")"

    [[ "$name" == "test-suite.sh" ]] && continue
    [[ "$name" == "test-historical-sprints.sh" ]] && continue

    printf "[TEST] %-40s " "$name"

    if (cd "$ROOT" && bash "$test_file") >/tmp/plex-toolkit-test.out 2>&1; then
        echo "OK"
        passed=$((passed + 1))
    else
        rc=$?
        echo "FAILED (exit=$rc)"
        cat /tmp/plex-toolkit-test.out
        failed=$((failed + 1))
    fi
done

rm -f /tmp/plex-toolkit-test.out

echo
echo "== Summary =="
echo "Passed : $passed"
echo "Failed : $failed"
echo "Skipped: $skipped"

(( failed == 0 ))
