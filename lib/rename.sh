#!/usr/bin/env bash

ptk_rename() {
    local dry_run=1
    local target=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --fix) dry_run=0 ;;
            *) target="$1" ;;
        esac
        shift
    done

    if [[ -z "$target" ]]; then
        while IFS='|' read -r name path; do
            echo "== $name =="
            ptk_rename_library "$path" "$dry_run"
        done < <(ptk_load_libraries)
    else
        ptk_rename_library "$target" "$dry_run"
    fi
}

ptk_rename_library() {
    local path="$1"
    local dry="$2"

    [[ -d "$path" ]] || return 1

    find "$path" -type f | while read -r file; do
        if [[ "$dry" -eq 1 ]]; then
            echo "[DRY-RUN] $file"
        else
            echo "[TODO] Rename: $file"
        fi
    done
}
