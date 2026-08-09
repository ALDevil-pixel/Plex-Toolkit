#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/cleanup_empty_dirs.sh"
source "$(dirname "${BASH_SOURCE[0]}")/cleanup_junk_files.sh"
source "$(dirname "${BASH_SOURCE[0]}")/cleanup_orphan_subtitles.sh"
source "$(dirname "${BASH_SOURCE[0]}")/library_loader.sh"

ptk_cleanup_library() {
    local p="$1"
    [[ -d "$p" ]] || return 1

    echo "== Cleanup: $p =="
    find "$p" -type f | while read -r f; do
        echo "[SCAN] $f"
    done

    ptk_find_empty_dirs "$p"
    ptk_find_junk_files "$p"
    ptk_find_orphan_subtitles "$p"
}

ptk_cleanup() {
    local target="${1:-}"

    if [[ -n "$target" ]]; then
        ptk_cleanup_library "$target"
        return $?
    fi

    while IFS='|' read -r name path; do
        [[ -n "$name" && -n "$path" ]] || continue
        echo "== $name =="
        ptk_cleanup_library "$path" || return $?
    done < <(ptk_load_libraries)
}
