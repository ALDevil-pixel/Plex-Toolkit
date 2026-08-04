#!/usr/bin/env bash
# CSV export

ptk_inventory_export_csv() {
    local input="$1"
    local output="${2:-logs/inventory.csv}"

    mkdir -p "$(dirname "$output")"
    echo "name,extension,size,modified,path" > "$output"

    cat "$input" >> "$output"

    echo "CSV exported to: $output"
}
