#!/usr/bin/env bash

ptk_inventory_library() {
    local path="$1"
    [[ -d "$path" ]] || return 1

    echo "== Inventory: $path =="

    find "$path" -type f | while read -r file; do
        echo "[FILE] $file"
    done
}

ptk_inventory() {
    if [[ $# -eq 0 ]]; then
        while IFS='|' read -r name path; do
            echo "== $name =="
            ptk_inventory_library "$path"
        done < <(ptk_load_libraries)
    else
        ptk_inventory_library "$1"
    fi
}
