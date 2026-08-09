#!/usr/bin/env bash
set -e

source lib/exit_codes.sh
source lib/cli_errors.sh
source lib/cli_options.sh

ptk_parse_common_options --verbose --quiet /tmp
test "$PTK_VERBOSE" -eq 1
test "$PTK_QUIET" -eq 1
test "${PTK_POSITIONAL[0]}" = "/tmp"

echo OK
