#!/usr/bin/env bash
set -e

TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

mkdir -p "$TEST_ROOT/config" "$TEST_ROOT/reports"

cat > "$TEST_ROOT/config/report.conf" <<EOF
REPORT_DIR="$TEST_ROOT/reports"
AUDIT_TEXT_REPORT="custom.log"
AUDIT_JSON_REPORT="custom.json"
EOF

(
    cd "$TEST_ROOT"
    source "$OLDPWD/lib/report.sh"
    PTK_REPORT_CONFIG="$TEST_ROOT/config/report.conf"

    ptk_report_summary 0 >/dev/null
    test -f "$TEST_ROOT/reports/custom.log"
    test "$(cat "$TEST_ROOT/reports/custom.log")" = "Audit completed"

    ptk_report_summary 1 >/dev/null
    test -f "$TEST_ROOT/reports/custom.json"
    grep '"status":"ok"' "$TEST_ROOT/reports/custom.json" >/dev/null
)

echo OK
