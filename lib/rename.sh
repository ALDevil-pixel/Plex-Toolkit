#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/media_type.sh"

ptk_rename_library() {
    local path="$1"
    local dry="$2"

    [[ -d "$path" ]] || return 1

    local type
    type=$(ptk_detect_media_type "$path")

    echo "Library type : $type"

    find "$path" -type f | while read -r file; do
        echo "[DRY-RUN][$type] $file"
    done
}
