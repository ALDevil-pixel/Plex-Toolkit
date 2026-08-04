#!/usr/bin/env bash
source lib/cleanup_logger.sh
rm -rf logs
ptk_cleanup_log REMOVED "/tmp/test.tmp"
test -f logs/cleanup.log
grep "REMOVED /tmp/test.tmp" logs/cleanup.log >/dev/null
rm -rf logs
echo OK
