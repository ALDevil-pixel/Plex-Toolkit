#!/usr/bin/env bash
set -e
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[[ -f "$ROOT/SPRINT_STATE.md" ]]

# Inspect historical tests only; this checker intentionally excludes itself.
for test in "$ROOT"/tests/test-sprint-*.sh; do
    [[ "$test" == "$ROOT/tests/test-sprint-state-independent.sh" ]] && continue
    if grep -nE 'SPRINT_STATE\.md.*Sprint|Sprint.*SPRINT_STATE\.md' "$test" >/dev/null 2>&1; then
        echo "Historical sprint test still depends on the current sprint marker: $test" >&2
        exit 1
    fi
done

echo "Historical sprint state independence: OK"
