#!/usr/bin/env bash

ptk_cleanup_library() {
    local path="$1"
    [[ -d "$path" ]] || return 1

    find "$path" -type f | while read -r file; do
        echo "[SCAN] $file"
    done
}

ptk_cleanup() {
    if [[ $# -eq 0 ]]; then
        while IFS='|' read -r name path; do
            echo "== $name =="
            ptk_cleanup_library "$path"
        done < <(ptk_load_libraries)
    else
        ptk_cleanup_library "$1"
    fi
}
