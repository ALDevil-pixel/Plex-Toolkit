#!/usr/bin/env bash
set -e

TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

mkdir -p "$TEST_ROOT/config" "$TEST_ROOT/reports"

cat > "$TEST_ROOT/config/report.conf" <<EOF
REPORT_DIR="$TEST_ROOT/reports"
AUDIT_TEXT_REPORT="audit.log"
AUDIT_JSON_REPORT="audit.json"
EOF

(
    cd "$TEST_ROOT"
    source "$OLDPWD/lib/report.sh"
    PTK_REPORT_CONFIG="$TEST_ROOT/config/report.conf"

    ptk_report_summary 0 >/tmp/ptk-report-text.out
    test -f "$TEST_ROOT/reports/audit.log"
    grep "Audit completed" "$TEST_ROOT/reports/audit.log" >/dev/null

    ptk_report_summary 1 >/tmp/ptk-report-json.out
    test -f "$TEST_ROOT/reports/audit.json"
    grep '"status":"ok"' "$TEST_ROOT/reports/audit.json" >/dev/null
)

rm -f /tmp/ptk-report-text.out /tmp/ptk-report-json.out
echo OK
