#!/usr/bin/env bash
# JSON export

ptk_json_escape() {
    local value="$1"
    value="${value//\\/\\\\}"
    value="${value//\"/\\\"}"
    value="${value//$'\t'/\\t}"
    value="${value//$'\r'/\\r}"
    value="${value//$'\n'/\\n}"
    printf '%s' "$value"
}

ptk_inventory_export_json() {
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
        : "${INVENTORY_JSON_REPORT:=${PTK_INVENTORY_JSON_REPORT}}"
        output="$PTK_REPORT_DIR/$INVENTORY_JSON_REPORT"
    fi

    local directory tmp
    directory="$(dirname "$output")"
    mkdir -p "$directory" || return 1
    tmp="$(mktemp "$directory/.ptk-inventory-json.XXXXXX")" || return 1

    printf '[\n' > "$tmp" || {
        rm -f -- "$tmp"
        return 1
    }

    local first=1
    while IFS='|' read -r name ext size modified path; do
        [[ -z "$name" ]] && continue

        [[ "$size" =~ ^[0-9]+$ ]] || {
            echo "[ERROR] Invalid inventory size for: $name" >&2
            rm -f -- "$tmp"
            return 1
        }

        if [[ "$first" -eq 0 ]]; then
            printf ',\n' >> "$tmp"
        fi
        first=0

        printf '  {"name":"%s","extension":"%s","size":%s,"modified":"%s","path":"%s"}' \
            "$(ptk_json_escape "$name")" \
            "$(ptk_json_escape "$ext")" \
            "$size" \
            "$(ptk_json_escape "$modified")" \
            "$(ptk_json_escape "$path")" >> "$tmp" || {
                rm -f -- "$tmp"
                return 1
            }
    done < "$input"

    printf '\n]\n' >> "$tmp" || {
        rm -f -- "$tmp"
        return 1
    }

    mv -f -- "$tmp" "$output" || {
        rm -f -- "$tmp"
        return 1
    }

    echo "JSON exported to: $output"
}
