#!/usr/bin/env bash
set -e

source lib/exit_codes.sh
source lib/cli_errors.sh
source lib/cli_options.sh
source lib/logger.sh
source lib/help.sh
source lib/version.sh

ptk_parse_common_options --verbose
test "$PTK_VERBOSE" -eq 1

ptk_help_show >/tmp/ptk-help.out
grep "Plex Toolkit Help" /tmp/ptk-help.out >/dev/null

ptk_version_show >/tmp/ptk-version.out
test -s /tmp/ptk-version.out

rm -f /tmp/ptk-help.out /tmp/ptk-version.out
echo OK
