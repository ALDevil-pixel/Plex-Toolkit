#!/usr/bin/env bash
# Suppression sécurisée des éléments détectés

ptk_cleanup_remove() {
    local target="$1"
    local dry="${2:-1}"

    if [[ ! -e "$target" ]]; then
        return 0
    fi

    if [[ "$dry" -eq 1 ]]; then
        echo "[DRY-RUN] Remove: $target"
        return 0
    fi

    rm -rf "$target"
    echo "[REMOVED] $target"
}
