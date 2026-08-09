#!/usr/bin/env bash
# Application sécurisée de la suppression des doublons

ptk_remove_duplicate() {
    local target="$1"
    local dry="${2:-1}"

    [[ -f "$target" ]] || return 0

    if [[ "$dry" -eq 1 ]]; then
        echo "[DRY-RUN] Remove duplicate: $target"
        return 0
    fi

    if rm -f -- "$target"; then
        ptk_log "INFO" "Removed duplicate: $target"
        echo "[REMOVED] $target"
        return 0
    fi

    ptk_log "ERROR" "Unable to remove duplicate: $target"
    return 1
}
