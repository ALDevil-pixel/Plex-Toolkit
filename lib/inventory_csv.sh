#!/usr/bin/env bash
# CSV export

ptk_inventory_export_csv() {
    local input="$1"
    local output="${2:-}"

    if [[ -z "$output" ]]; then
        local cfg="${PTK_INVENTORY_CONFIG:-config/inventory.conf}"
        [[ -f "$cfg" ]] || {
            echo "[ERROR] Inventory configuration not found: $cfg" >&2
            return 1
        }
        # shellcheck disable=SC1090
        source "$cfg"
        : "${REPORT_DIR:=./reports}"
        : "${INVENTORY_CSV_REPORT:=inventory.csv}"
        output="$REPORT_DIR/$INVENTORY_CSV_REPORT"
    fi

    mkdir -p "$(dirname "$output")" || return 1
    echo "name,extension,size,modified,path" > "$output"
    cat "$input" >> "$output"

    echo "CSV exported to: $output"
}
