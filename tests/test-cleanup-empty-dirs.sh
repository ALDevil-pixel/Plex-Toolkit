#!/usr/bin/env bash
mkdir -p /tmp/ptk-empty/a /tmp/ptk-empty/b
touch /tmp/ptk-empty/b/file.mkv
source lib/cleanup_empty_dirs.sh
ptk_find_empty_dirs /tmp/ptk-empty | grep "/tmp/ptk-empty/a" >/dev/null
rm -rf /tmp/ptk-empty
echo OK
