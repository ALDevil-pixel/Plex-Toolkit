#!/usr/bin/env bash
source lib/media_analyzer.sh
mkdir -p /tmp/ptk-test
touch /tmp/ptk-test/test.mkv
touch /tmp/ptk-test/file.tmp
ptk_media_scan /tmp/ptk-test >/dev/null
rm -rf /tmp/ptk-test
echo OK
