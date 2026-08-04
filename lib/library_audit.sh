#!/usr/bin/env bash

ptk_library_audit() {
    local cfg="${1:-config/library.conf}"

    if [[ ! -f "$cfg" ]]; then
        echo "[ERROR] Missing configuration: $cfg"
        return 10
    fi

    echo "Plex Library Audit"
    echo

    while IFS='=' read -r name path; do
        [[ -z "$name" || "$name" =~ ^# ]] && continue
        path="${path%"}"
        path="${path#"}"

        if [[ -d "$path" ]]; then
            count=$(find "$path" -mindepth 1 -maxdepth 1 | wc -l)
            printf "[ OK ] %-15s %5s entries : %s
" "$name" "$count" "$path"
        else
            printf "[WARN] %-15s missing     : %s
" "$name" "$path"
        fi
    done < "$cfg"
}
