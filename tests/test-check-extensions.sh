#!/usr/bin/env bash
mkdir -p /tmp/ptk-ext
touch /tmp/ptk-ext/video.mkv
touch /tmp/ptk-ext/video.wmv

source lib/check_extensions.sh

ptk_find_invalid_extensions /tmp/ptk-ext | grep "video.wmv" >/dev/null

rm -rf /tmp/ptk-ext
echo OK
