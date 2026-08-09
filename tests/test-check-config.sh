#!/usr/bin/env bash
set -e

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo 'VIDEO_EXTENSIONS="mkv mp4 avi"' > "$TMP/check.conf"

source lib/check_extensions.sh
test "$(ptk_load_allowed_extensions "$TMP/check.conf")" = "mkv mp4 avi"

echo OK
