#!/usr/bin/env bash
mkdir -p config
echo 'VIDEO_EXTENSIONS="mkv mp4 avi"' > config/check.conf

source lib/check_extensions.sh

test "$(ptk_load_allowed_extensions)" = "mkv mp4 avi"

rm -f config/check.conf
echo OK
