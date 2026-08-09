#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/inventory_metadata.sh"
source "$(dirname "${BASH_SOURCE[0]}")/inventory_csv.sh"
source "$(dirname "${BASH_SOURCE[0]}")/inventory_json.sh"
source "$(dirname "${BASH_SOURCE[0]}")/inventory_stats.sh"
source "$(dirname "${BASH_SOURCE[0]}")/library_loader.sh"

ptk_inventory_library() {
    local path="$1"
    [[ -d "$path" ]] || return 1

    local tmp
    tmp="$(mktemp)"

    find "$path" -type f | while read -r file; do
        ptk_inventory_metadata "$file" >> "$tmp"
    done

    ptk_inventory_export_csv "$tmp"
    ptk_inventory_export_json "$tmp"
    ptk_inventory_stats "$tmp"

    rm -f "$tmp"
}

ptk_inventory() {
    local target="${1:-}"

    if [[ -n "$target" ]]; then
        ptk_inventory_library "$target"
        return $?
    fi

    while IFS='|' read -r name path; do
        [[ -n "$name" && -n "$path" ]] || continue
        echo "== $name =="
        ptk_inventory_library "$path" || return $?
    done < <(ptk_load_libraries)
}
