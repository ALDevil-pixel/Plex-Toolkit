#!/usr/bin/env bash
# CSV export

ptk_inventory_export_csv() {
    local input="$1"
    local output="${2:-}"

    if [[ -z "$output" ]]; then
        local cfg="${PTK_INVENTORY_CONFIG:-config/inventory.conf}"
        source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
        ptk_load_config "$cfg" || return 1
        : "${INVENTORY_CSV_REPORT:=${PTK_INVENTORY_CSV_REPORT}}"
        output="$PTK_REPORT_DIR/$INVENTORY_CSV_REPORT"
    fi

    mkdir -p "$(dirname "$output")" || return 1
    echo "name,extension,size,modified,path" > "$output"
    cat "$input" >> "$output"

    echo "CSV exported to: $output"
}
