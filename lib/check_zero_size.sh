#!/usr/bin/env bash
# Zero-byte file detection

ptk_find_zero_size_files() {
    local path="$1"
    [[ -d "$path" ]] || return 1

    find "$path" -type f -size 0 -print0 |
    while IFS= read -r -d '' file; do
        echo "[ZERO] $file"
    done
}
