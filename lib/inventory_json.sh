#!/usr/bin/env bash
# JSON export

ptk_inventory_export_json() {
    local input="$1"
    local output="${2:-}"

    if [[ -z "$output" ]]; then
        local cfg="${PTK_INVENTORY_CONFIG:-config/inventory.conf}"
        source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
        ptk_load_config "$cfg" || return 1
        : "${INVENTORY_JSON_REPORT:=${PTK_INVENTORY_JSON_REPORT}}"
        output="$PTK_REPORT_DIR/$INVENTORY_JSON_REPORT"
    fi

    mkdir -p "$(dirname "$output")" || return 1

    {
        echo "["
        first=1
        while IFS='|' read -r name ext size modified path; do
            [[ -z "$name" ]] && continue
            [[ $first -eq 0 ]] && echo ","
            first=0
            printf '  {"name":"%s","extension":"%s","size":%s,"modified":"%s","path":"%s"}' \
                "$name" "$ext" "$size" "$modified" "$path"
        done < "$input"
        echo
        echo "]"
    } > "$output"

    echo "JSON exported to: $output"
}
