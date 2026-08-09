#!/usr/bin/env bash
# Corrections automatiques sûres du contrôle

source "$(dirname "${BASH_SOURCE[0]}")/check_logger.sh"

ptk_check_remove_zero_size() {
    local file="$1"
    local dry="${2:-1}"

    [[ -f "$file" ]] || return 0

    if [[ "$dry" -eq 1 ]]; then
        echo "[DRY-RUN] Remove zero-byte file: $file"
        return 0
    fi

    if rm -f -- "$file"; then
        ptk_check_log INFO "Removed zero-byte file: $file"
        echo "[REMOVED] $file"
        return 0
    fi

    ptk_check_log ERROR "Unable to remove zero-byte file: $file"
    echo "[ERROR] Unable to remove: $file" >&2
    return 1
}

ptk_check_fix_zero_size() {
    local path="$1"
    local dry="${2:-1}"

    find "$path" -type f -size 0 -print0 |
    while IFS= read -r -d '' file; do
        ptk_check_remove_zero_size "$file" "$dry" || return 1
    done
}
