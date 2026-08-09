#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNNER="$ROOT/tests/run.sh"

grep -q 'cd "$ROOT"' "$RUNNER"
grep -q 'test-suite.sh' "$RUNNER"

# The runner must not invoke test-suite.sh as one of its children.
if grep -E 'bash "\$test_file"' "$RUNNER" >/dev/null && \
   grep -E 'name.*test-suite\.sh.*continue' "$RUNNER" >/dev/null; then
    :
else
    echo "Runner recursion protection is missing." >&2
    exit 1
fi

echo "Runner contract: OK"
