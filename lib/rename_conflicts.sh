#!/usr/bin/env bash
# Conflict detection helpers

ptk_check_conflict() {
    local target="$1"
    [[ -e "$target" ]]
}

ptk_resolve_conflict() {
    local target="$1"
    local strategy="${2:-skip}"

    case "$strategy" in
        skip)
            echo "[SKIP] $target"
            return 1
            ;;
        suffix)
            local base="${target%.*}"
            local ext="${target##*.}"
            echo "${base}_1.${ext}"
            ;;
        *)
            echo "$target"
            ;;
    esac
}
