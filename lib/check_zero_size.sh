#!/usr/bin/env bash
# Zero-byte file detection

ptk_find_zero_size_files() {
    local path="$1"
    [[ -d "$path" ]] || return 1

    find "$path" -type f -size 0 | while read -r file; do
        echo "[ZERO] $file"
    done
}
