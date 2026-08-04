#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/cleanup_empty_dirs.sh"
source "$(dirname "${BASH_SOURCE[0]}")/cleanup_junk_files.sh"
source "$(dirname "${BASH_SOURCE[0]}")/cleanup_orphan_subtitles.sh"

ptk_cleanup_library() {
    local path="$1"
    [[ -d "$path" ]] || return 1

    echo "Scanning files..."
    find "$path" -type f | while read -r f; do echo "[SCAN] $f"; done

    echo
    echo "Searching empty directories..."
    ptk_find_empty_dirs "$path"

    echo
    echo "Searching junk files..."
    ptk_find_junk_files "$path"

    echo
    echo "Searching orphan subtitles..."
    ptk_find_orphan_subtitles "$path"
}
