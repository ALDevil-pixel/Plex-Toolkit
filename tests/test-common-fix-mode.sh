#!/usr/bin/env bash
set -e

source lib/cli_options.sh

ptk_parse_common_options --dry-run
ptk_is_dry_run
! ptk_is_fix_enabled

ptk_parse_common_options --fix
ptk_is_fix_enabled
! ptk_is_dry_run

ptk_parse_common_options --verbose --quiet
test "$PTK_VERBOSE" -eq 1
test "$PTK_QUIET" -eq 1

echo OK
