#!/usr/bin/env bash
source lib/rename_logger.sh
rm -rf logs
ptk_log_rename old.mkv new.mkv
test -f logs/rename.log
grep "old.mkv -> new.mkv" logs/rename.log >/dev/null
rm -rf logs
echo OK
