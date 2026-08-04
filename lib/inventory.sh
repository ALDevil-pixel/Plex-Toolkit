#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/inventory_metadata.sh"
source "$(dirname "${BASH_SOURCE[0]}")/inventory_csv.sh"
source "$(dirname "${BASH_SOURCE[0]}")/inventory_json.sh"

ptk_inventory_library() {
    local path="$1"
    [[ -d "$path" ]] || return 1

    tmp=$(mktemp)

    find "$path" -type f | while read -r file; do
        ptk_inventory_metadata "$file" >> "$tmp"
    done

    ptk_inventory_export_csv "$tmp"
    ptk_inventory_export_json "$tmp"

    rm -f "$tmp"
}
