#!/usr/bin/env bash
set -e

source lib/exit_codes.sh
source lib/cli_errors.sh
source lib/cli_options.sh
source lib/logger.sh
source lib/doctor.sh

ptk_parse_common_options --dry-run --verbose
test "$PTK_DRY_RUN" -eq 1
test "$PTK_VERBOSE" -eq 1

ptk_doctor_run text >/tmp/ptk-doctor-text.out
grep "Summary" /tmp/ptk-doctor-text.out >/dev/null

ptk_doctor_run json >/tmp/ptk-doctor-json.out
grep '"bash":' /tmp/ptk-doctor-json.out >/dev/null

rm -f /tmp/ptk-doctor-text.out /tmp/ptk-doctor-json.out
echo OK
