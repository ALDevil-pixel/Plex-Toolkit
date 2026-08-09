#!/usr/bin/env bash
# Vérifications minimales nécessaires au fonctionnement du Toolkit.

ptk_self_check_run() {
    local missing=0

    for c in bash find grep awk sed; do
        if command -v "$c" >/dev/null 2>&1; then
            printf "[ OK ] %s\n" "$c"
        else
            printf "[ERROR] Missing: %s\n" "$c" >&2
            missing=1
        fi
    done

    if [[ ! -d "config" ]]; then
        echo "[WARN] config directory is missing"
    fi

    if [[ "$missing" -ne 0 ]]; then
        return 1
    fi

    echo "Self-check OK"
    return 0
}
