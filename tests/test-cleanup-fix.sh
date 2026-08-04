#!/usr/bin/env bash
mkdir -p /tmp/ptk-cleanup
touch /tmp/ptk-cleanup/test.tmp

source lib/cleanup_fix.sh

ptk_cleanup_remove /tmp/ptk-cleanup/test.tmp 0

test ! -f /tmp/ptk-cleanup/test.tmp

rm -rf /tmp/ptk-cleanup

echo OK
