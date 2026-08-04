#!/usr/bin/env bash
# Journalisation des contrôles

ptk_check_log() {
    local level="$1"
    local message="$2"
    local logfile="${3:-logs/check.log}"

    mkdir -p "$(dirname "$logfile")"
    printf "[%s] [%s] %s\n" "$(date '+%F %T')" "$level" "$message" >> "$logfile"
}
