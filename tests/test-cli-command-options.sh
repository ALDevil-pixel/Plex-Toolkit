#!/usr/bin/env bash
set -e

source lib/cli_options.sh

ptk_parse_common_options --verbose --dry-run /media/Movies
test "$PTK_DRY_RUN" -eq 1
test "$PTK_VERBOSE" -eq 1
test "${#PTK_POSITIONAL[@]}" -eq 1
test "${PTK_POSITIONAL[0]}" = "/media/Movies"

ptk_parse_common_options --fix --quiet -- /media/Series
test "$PTK_DRY_RUN" -eq 0
test "$PTK_QUIET" -eq 1
test "${PTK_POSITIONAL[0]}" = "/media/Series"

echo OK
