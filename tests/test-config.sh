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

cat > "$TEST_ROOT/invalid.conf" <<'EOF'
PTK_DRY_RUN=maybe
EOF

if ptk_load_config "$TEST_ROOT/invalid.conf" >/tmp/ptk-config-invalid.out 2>&1; then
    exit 1
fi

grep "Invalid boolean" /tmp/ptk-config-invalid.out >/dev/null

rm -f /tmp/ptk-config-invalid.out
echo OK
