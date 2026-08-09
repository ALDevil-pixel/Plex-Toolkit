#!/usr/bin/env bash
set -e

source lib/cli_options.sh

ptk_parse_common_options --verbose --dry-run
test "$PTK_DRY_RUN" -eq 1
test "$PTK_VERBOSE" -eq 1
test "$PTK_QUIET" -eq 0

ptk_parse_common_options --fix --quiet
test "$PTK_DRY_RUN" -eq 0
test "$PTK_QUIET" -eq 1

echo OK
