#!/usr/bin/env bash
# Ignore patterns support

ptk_load_ignore_file() {
    local file="${1:-config/duplicates.ignore}"
    [[ -f "$file" ]] || return 0
    grep -Ev '^#|^$' "$file"
}

ptk_is_ignored() {
    local path="$1"; shift
    for pattern in "$@"; do
        [[ "$path" == *"$pattern"* ]] && return 0
    done
    return 1
}
