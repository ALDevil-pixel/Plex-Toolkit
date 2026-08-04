#!/usr/bin/env bash
ptk_duplicates_summary() {
    local report="${1:-logs/duplicates-report.txt}"
    [[ -f "$report" ]] || { echo "No report found."; return 1; }

    local groups files
    groups=$(grep -c '^\[WARN\]' "$report" 2>/dev/null || true)
    files=$(grep -c '^ - ' "$report" 2>/dev/null || true)

    cat <<EOF
========== Duplicate Summary ==========
Groups : ${groups:-0}
Files  : ${files:-0}
Report : $report
=======================================
EOF
}
