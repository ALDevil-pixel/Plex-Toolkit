#!/usr/bin/env bash
# Journalisation des renommages

ptk_log_rename() {
    local src="$1"
    local dst="$2"
    local logfile="${3:-logs/rename.log}"

    mkdir -p "$(dirname "$logfile")"
    printf "[%s] %s -> %s\n" "$(date '+%F %T')" "$src" "$dst" >> "$logfile"
}
