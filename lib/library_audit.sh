#!/usr/bin/env bash
# Audit des bibliothèques configurées

ptk_library_audit() {
    local cfg="${1:-config/library.conf}"

    if [[ ! -f "$cfg" ]]; then
        echo "[ERROR] Missing configuration: $cfg" >&2
        return 1
    fi

    echo "Plex Library Audit"
    echo

    local errors=0

    while IFS='=' read -r name path; do
        [[ -z "$name" || "$name" =~ ^# ]] && continue

        path="${path#\"}"
        path="${path%\"}"

        if [[ -d "$path" ]]; then
            local count
            count=$(find "$path" -mindepth 1 -maxdepth 1 | wc -l)
            printf "[ OK ] %-15s %5s entries : %s\n" "$name" "$count" "$path"
        else
            printf "[WARN] %-15s missing     : %s\n" "$name" "$path"
            errors=1
        fi
    done < "$cfg"

    return "$errors"
}
