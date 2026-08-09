#!/usr/bin/env bash
# Inventory logging

ptk_inventory_log() {
    local message="$1"
    local logfile="${2:-}"

    if [[ -z "$logfile" ]]; then
        local cfg="${PTK_INVENTORY_CONFIG:-config/inventory.conf}"
        source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
        ptk_load_config "$cfg" || return 1
        : "${INVENTORY_LOG:=${PTK_INVENTORY_LOG}}"
        logfile="$PTK_REPORT_DIR/$INVENTORY_LOG"
    fi

    mkdir -p "$(dirname "$logfile")" || return 1
    printf "[%s] %s\n" "$(date '+%F %T')" "$message" >> "$logfile"
}
