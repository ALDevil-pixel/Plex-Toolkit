#!/usr/bin/env bash
# Cleanup logging

ptk_cleanup_log() {
    local action="$1"
    local target="$2"
    local logfile="${3:-logs/cleanup.log}"

    mkdir -p "$(dirname "$logfile")"
    printf "[%s] %s %s\n" "$(date '+%F %T')" "$action" "$target" >> "$logfile"
}
