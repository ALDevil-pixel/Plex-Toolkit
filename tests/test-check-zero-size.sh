#!/usr/bin/env bash
mkdir -p /tmp/ptk-check
touch /tmp/ptk-check/empty.mkv
echo test >/tmp/ptk-check/video.mkv

source lib/check_zero_size.sh

ptk_find_zero_size_files /tmp/ptk-check | grep "empty.mkv" >/dev/null

rm -rf /tmp/ptk-check
echo OK
