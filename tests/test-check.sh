#!/usr/bin/env bash
mkdir -p /tmp/ptk-check
touch /tmp/ptk-check/test.mkv
source lib/check.sh
ptk_check_library /tmp/ptk-check >/dev/null
rm -rf /tmp/ptk-check
echo OK
