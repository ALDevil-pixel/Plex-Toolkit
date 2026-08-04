#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/cleanup_logger.sh"

ptk_cleanup_remove() {
    local target="$1"
    local dry="${2:-1}"

    [[ -e "$target" ]] || return 0

    if [[ "$dry" -eq 1 ]]; then
        echo "[DRY-RUN] Remove: $target"
        return 0
    fi

    rm -rf "$target"
    ptk_cleanup_log "REMOVED" "$target"
    echo "[REMOVED] $target"
}
