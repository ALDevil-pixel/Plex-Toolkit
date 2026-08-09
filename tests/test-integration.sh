#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOL="$ROOT/plex-toolkit"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Basic CLI contract.
"$TOOL" version >"$TMP/version.out"
test -s "$TMP/version.out"

"$TOOL" help >"$TMP/help.out"
grep "Plex Toolkit Help" "$TMP/help.out" >/dev/null

# Plugin discovery/execution.
(
    cd "$ROOT"
    source lib/plugin.sh
    ptk_plugin_exists anime audit
    ptk_plugin_run anime audit >"$TMP/plugin.out"
)
grep "not implemented yet" "$TMP/plugin.out" >/dev/null

# Configuration validation.
(
    cd "$ROOT"
    source lib/config.sh
    ptk_load_config
    test "$PTK_REPORT_DIR" = "./reports"
)

# Reporting.
(
    cd "$ROOT"
    source lib/report.sh
    PTK_REPORT_CONFIG="$TMP/report.conf"
    cat > "$TMP/report.conf" <<EOF
PTK_REPORT_DIR="$TMP/reports"
AUDIT_TEXT_REPORT="integration.log"
AUDIT_JSON_REPORT="integration.json"
EOF
    ptk_report_summary 0 >/dev/null
    test -f "$TMP/reports/integration.log"
    ptk_report_summary 1 >/dev/null
    test -f "$TMP/reports/integration.json"
)

# Unknown command must keep the usage-error contract.
if "$TOOL" definitely-not-a-command >"$TMP/error.out" 2>&1; then
    exit 1
else
    test "$?" -eq 2
fi

echo "Integration: OK"
