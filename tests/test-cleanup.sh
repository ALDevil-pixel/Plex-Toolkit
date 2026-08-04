#!/usr/bin/env bash
mkdir -p /tmp/ptk-clean
touch /tmp/ptk-clean/test.mkv
source lib/cleanup.sh
ptk_cleanup_library /tmp/ptk-clean >/dev/null
rm -rf /tmp/ptk-clean
echo OK
