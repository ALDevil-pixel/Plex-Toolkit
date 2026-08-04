#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/rename_logger.sh"

ptk_apply_rename() {
    local src="$1"
    local dst="$2"
    local dry="$3"

    if [[ "$dry" -eq 1 ]]; then
        echo "[DRY-RUN] $(basename "$src") -> $(basename "$dst")"
    else
        mv "$src" "$dst"
        ptk_log_rename "$src" "$dst"
        echo "[OK] $(basename "$dst")"
    fi
}
