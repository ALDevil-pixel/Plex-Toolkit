#!/usr/bin/env bash
set -e

source lib/exit_codes.sh
source lib/cli_errors.sh
source lib/cli_options.sh
source lib/logger.sh
source lib/self_check.sh

ptk_parse_common_options --dry-run --verbose
test "$PTK_DRY_RUN" -eq 1
test "$PTK_VERBOSE" -eq 1

ptk_self_check_run >/tmp/ptk-self-check.out
grep "Self-check OK" /tmp/ptk-self-check.out >/dev/null

rm -f /tmp/ptk-self-check.out
echo OK
