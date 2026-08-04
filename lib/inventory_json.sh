#!/usr/bin/env bash
# JSON export

ptk_inventory_export_json() {
    local input="$1"
    local output="${2:-logs/inventory.json}"

    mkdir -p "$(dirname "$output")"

    {
        echo "["
        first=1
        while IFS='|' read -r name ext size modified path; do
            [[ -z "$name" ]] && continue
            [[ $first -eq 0 ]] && echo ","
            first=0
            printf '  {"name":"%s","extension":"%s","size":%s,"modified":"%s","path":"%s"}'                 "$name" "$ext" "$size" "$modified" "$path"
        done < "$input"
        echo
        echo "]"
    } > "$output"

    echo "JSON exported to: $output"
}
