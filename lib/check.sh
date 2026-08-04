#!/usr/bin/env bash

ptk_check_library() {
    local path="$1"
    [[ -d "$path" ]] || return 1

    echo "== Checking: $path =="
    find "$path" -type f | while read -r file; do
        echo "[CHECK] $file"
    done
}

ptk_check() {
    if [[ $# -eq 0 ]]; then
        while IFS='|' read -r name path; do
            echo "== $name =="
            ptk_check_library "$path"
        done < <(ptk_load_libraries)
    else
        ptk_check_library "$1"
    fi
}
