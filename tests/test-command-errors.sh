#!/usr/bin/env bash
set -e

source lib/exit_codes.sh
source lib/cli_errors.sh
source lib/cli_options.sh

ptk_parse_common_options /path/that/does/not/exist
if ptk_require_directory "${PTK_POSITIONAL[0]}"; then
    exit 1
else
    test "$?" -eq "$PTK_EXIT_ERROR"
fi

ptk_parse_common_options one two
test "${#PTK_POSITIONAL[@]}" -eq 2

echo OK
