#!/usr/bin/env bash
set -e

source lib/exit_codes.sh
source lib/cli_errors.sh
source lib/cli_options.sh

ptk_parse_common_options --dry-run --verbose --quiet -- sample
test "$PTK_DRY_RUN" -eq 1
test "$PTK_VERBOSE" -eq 1
test "$PTK_QUIET" -eq 1
test "${PTK_POSITIONAL[0]}" = "sample"

ptk_parse_common_options --fix
ptk_is_fix_enabled

if ptk_parse_common_options --unknown >/tmp/ptk-cli-error.out 2>&1; then
    exit 1
else
    test "$?" -eq 2
fi

grep "Unknown option" /tmp/ptk-cli-error.out >/dev/null

if ptk_require_option_value "--config" "" >/tmp/ptk-cli-value.out 2>&1; then
    exit 1
else
    test "$?" -eq 2
fi

grep "requires a value" /tmp/ptk-cli-value.out >/dev/null

rm -f /tmp/ptk-cli-error.out /tmp/ptk-cli-value.out
echo OK
