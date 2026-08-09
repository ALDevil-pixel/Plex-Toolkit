#!/usr/bin/env bash
set -e

source lib/config.sh

PTK_LOG_DIR="./logs"
PTK_REPORT_DIR="./reports"
PTK_DRY_RUN=true
PTK_VERBOSE=false
PTK_COLOR=true
PTK_VIDEO_EXTENSIONS="mkv mp4"

ptk_validate_config

PTK_VERBOSE=invalid
if ptk_validate_config >/tmp/ptk-config-validation.out 2>&1; then
    exit 1
fi

grep "PTK_VERBOSE" /tmp/ptk-config-validation.out >/dev/null

rm -f /tmp/ptk-config-validation.out
echo OK
