#!/usr/bin/env bash
# Empty directory detection

ptk_find_empty_dirs() {
    local path="$1"
    [[ -d "$path" ]] || return 1

    find "$path" -type d -empty | while read -r dir; do
        echo "[EMPTY] $dir"
    done
}
