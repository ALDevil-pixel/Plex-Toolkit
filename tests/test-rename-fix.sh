#!/usr/bin/env bash
mkdir -p /tmp/ptk-r
touch "/tmp/ptk-r/Avatar.2009.1080p.x264.mkv"
source lib/rename.sh
ptk_rename /tmp/ptk-r >/dev/null
test -f "/tmp/ptk-r/Avatar.2009.1080p.x264.mkv"
rm -rf /tmp/ptk-r
echo OK
