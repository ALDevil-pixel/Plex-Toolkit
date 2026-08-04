#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/inventory_logger.sh"

ptk_inventory_stats() {
    local input="$1"

    local files total
    files=$(wc -l < "$input")
    total=$(awk -F'|' '{s+=$3} END{print s+0}' "$input")

    ptk_inventory_log "Files: $files"
    ptk_inventory_log "Total size: $total bytes"

    cat <<EOF
========== Inventory Summary ==========
Files : $files
Total size (bytes): $total
=======================================
EOF
}
