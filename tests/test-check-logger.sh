#!/usr/bin/env bash
source lib/check_logger.sh
rm -rf logs
ptk_check_log INFO "Unit test"
test -f logs/check.log
grep "Unit test" logs/check.log >/dev/null
rm -rf logs
echo OK
