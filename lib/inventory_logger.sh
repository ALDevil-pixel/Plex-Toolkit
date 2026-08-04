#!/usr/bin/env bash
# Inventory logging

ptk_inventory_log() {
    local message="$1"
    local logfile="${2:-logs/inventory.log}"

    mkdir -p "$(dirname "$logfile")"
    printf "[%s] %s\n" "$(date '+%F %T')" "$message" >> "$logfile"
}
