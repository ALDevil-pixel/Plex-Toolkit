#!/usr/bin/env bash
# CSV export

ptk_csv_escape() {
    local value="$1"
    value="${value//\"/\"\"}"
    printf '"%s"' "$value"
}

ptk_inventory_export_csv() {
    local input="${1:-}"
    local output="${2:-}"

    [[ -n "$input" && -f "$input" ]] || {
        echo "[ERROR] Inventory input not found: $input" >&2
        return 1
    }

    if [[ -z "$output" ]]; then
        local cfg="${PTK_INVENTORY_CONFIG:-config/inventory.conf}"
        source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
        ptk_load_config "$cfg" || return 1
        : "${INVENTORY_CSV_REPORT:=${PTK_INVENTORY_CSV_REPORT}}"
        output="$PTK_REPORT_DIR/$INVENTORY_CSV_REPORT"
    fi

    local directory tmp
    directory="$(dirname "$output")"
    mkdir -p "$directory" || return 1
    tmp="$(mktemp "$directory/.ptk-inventory-csv.XXXXXX")" || return 1

    if ! printf '%s\n' '"name","extension","size","modified","path"' > "$tmp"; then
        rm -f -- "$tmp"
        return 1
    fi

    while IFS='|' read -r name ext size modified path; do
        [[ -z "$name" ]] && continue
        printf '%s,%s,%s,%s,%s\n' \
            "$(ptk_csv_escape "$name")" \
            "$(ptk_csv_escape "$ext")" \
            "$(ptk_csv_escape "$size")" \
            "$(ptk_csv_escape "$modified")" \
            "$(ptk_csv_escape "$path")" >> "$tmp" || {
                rm -f -- "$tmp"
                return 1
            }
    done < "$input"

    mv -f -- "$tmp" "$output" || {
        rm -f -- "$tmp"
        return 1
    }

    echo "CSV exported to: $output"
}
