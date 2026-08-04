#!/usr/bin/env bash
# Build a simple duplicate report

ptk_duplicate_report() {
    local input="$1"
    local report="${2:-logs/duplicates-report.txt}"

    mkdir -p "$(dirname "$report")"

    {
        echo "Plex-Toolkit Duplicate Report"
        echo "Generated: $(date)"
        echo
        cat "$input"
    } > "$report"

    echo "Report written to: $report"
}
