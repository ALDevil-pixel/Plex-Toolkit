#!/usr/bin/env bash
set -e

source lib/config.sh

TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

cat > "$TEST_ROOT/custom.conf" <<EOF
PTK_LOG_DIR="$TEST_ROOT/logs"
PTK_REPORT_DIR="$TEST_ROOT/reports"
PTK_VERBOSE=true
EOF

ptk_load_config "$TEST_ROOT/custom.conf"

test "$PTK_LOG_DIR" = "$TEST_ROOT/logs"
test "$PTK_REPORT_DIR" = "$TEST_ROOT/reports"
test "$PTK_VERBOSE" = "true"
test "$PTK_VIDEO_EXTENSIONS" = "mkv mp4 ts"

echo OK
