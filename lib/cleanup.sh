#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/cleanup_empty_dirs.sh"
source "$(dirname "${BASH_SOURCE[0]}")/cleanup_junk_files.sh"
source "$(dirname "${BASH_SOURCE[0]}")/cleanup_orphan_subtitles.sh"
source "$(dirname "${BASH_SOURCE[0]}")/cleanup_fix.sh"
source "$(dirname "${BASH_SOURCE[0]}")/library_loader.sh"

ptk_cleanup_library() {
    local path="$1"
    local dry="${2:-1}"

    [[ -d "$path" ]] || return 1

    echo "== Cleanup: $path =="

    if [[ "$dry" -eq 1 ]]; then
        ptk_find_empty_dirs "$path"
        ptk_find_junk_files "$path"
        ptk_find_orphan_subtitles "$path"
        return 0
    fi

    echo "[FIX] Empty directories"
    ptk_cleanup_fix_empty_dirs "$path" "$dry" || return 1

    echo "[FIX] Junk files"
    ptk_cleanup_fix_junk_files "$path" "$dry" || return 1

    echo "[FIX] Orphan subtitles"
    ptk_cleanup_fix_orphan_subtitles "$path" "$dry" || return 1
}

ptk_cleanup() {
    local dry=1
    local target=""

    if [[ "$1" == "--fix" ]]; then
        dry=0
        shift
    elif [[ "$1" == "--dry-run" ]]; then
        dry=1
        shift
    fi

    [[ -n "$1" ]] && target="$1"

    if [[ -n "$target" ]]; then
        ptk_cleanup_library "$target" "$dry"
        return $?
    fi

    while IFS='|' read -r name path; do
        [[ -n "$name" && -n "$path" ]] || continue
        echo "== $name =="
        ptk_cleanup_library "$path" "$dry" || return $?
    done < <(ptk_load_libraries)
}
