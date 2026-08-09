#!/usr/bin/env bash
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
pass=0; fail=0
for test in "$ROOT"/tests/test-sprint-*.sh; do
    [[ -f "$test" ]] || continue
    [[ "$(basename "$test")" == "test-historical-sprints.sh" ]] && continue
    if bash "$test" >/tmp/ptk-historical-test.out 2>&1; then
        printf '[PASS] %s\n' "$(basename "$test")"; pass=$((pass+1))
    else
        rc=$?
        printf '[FAIL] %s (rc=%s)\n' "$(basename "$test")" "$rc"
        cat /tmp/ptk-historical-test.out
        fail=$((fail+1))
    fi
done
rm -f /tmp/ptk-historical-test.out
printf 'Historical sprint tests: PASS=%s FAIL=%s\n' "$pass" "$fail"
exit "$([[ $fail -eq 0 ]] && echo 0 || echo 1)"
