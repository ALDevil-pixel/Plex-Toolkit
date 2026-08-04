#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/rename_conflicts.sh"

ptk_apply_rename() {
    local src="$1"
    local dst="$2"
    local dry="$3"
    local strategy="${4:-skip}"

    if ptk_check_conflict "$dst"; then
        newdst=$(ptk_resolve_conflict "$dst" "$strategy") || return 1
        [[ "$newdst" == "[SKIP]"* ]] && return 1
        dst="$newdst"
    fi

    if [[ "$dry" -eq 1 ]]; then
        echo "[DRY-RUN] $(basename "$src") -> $(basename "$dst")"
    else
        mv "$src" "$dst"
        echo "[OK] $(basename "$dst")"
    fi
}
