#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOL="$ROOT/plex-toolkit"

# Core read-only commands should remain callable after the CLI/library cleanup.
"$TOOL" help >/dev/null
"$TOOL" version >/dev/null
"$TOOL" self-check >/dev/null

# Legacy wrappers must remain available.
(
    cd "$ROOT"
    source lib/common.sh
    source lib/args.sh
    source lib/cli.sh
    source lib/errors.sh

    ptk_require_command bash
    parse_args --dry-run --verbose --quiet --force -- sample
    test "$DRY_RUN" = true
    test "$VERBOSE" = true
    test "$QUIET" = true
    test "$FORCE" = true
    test "${POSITIONAL[0]}" = sample
)

echo "Regression: OK"
