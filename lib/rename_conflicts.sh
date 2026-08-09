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
            local index=1
            local candidate="${base}_${index}.${ext}"

            while [[ -e "$candidate" ]]; do
                index=$((index + 1))
                candidate="${base}_${index}.${ext}"
            done

            echo "$candidate"
            return 0
            ;;
        *)
            echo "$target"
            return 0
            ;;
    esac
}
