#!/usr/bin/env bash
mkdir -p /tmp/ptk-junk
touch /tmp/ptk-junk/Thumbs.db
touch /tmp/ptk-junk/test.tmp

source lib/cleanup_junk_files.sh

ptk_find_junk_files /tmp/ptk-junk | grep "Thumbs.db" >/dev/null
ptk_find_junk_files /tmp/ptk-junk | grep "test.tmp" >/dev/null

rm -rf /tmp/ptk-junk
echo OK
