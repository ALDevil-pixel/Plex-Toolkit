#!/usr/bin/env bash
# Charge les bibliothèques définies dans config/library.conf

ptk_load_libraries() {
    local cfg="${1:-config/library.conf}"
    [[ -f "$cfg" ]] || { echo "[ERROR] Missing $cfg"; return 10; }

    while IFS='=' read -r name path; do
        [[ -z "$name" || "$name" =~ ^# ]] && continue
        path="${path#\"}"
        path="${path%\"}"
        printf "%s|%s\n" "$name" "$path"
    done < "$cfg"
}
