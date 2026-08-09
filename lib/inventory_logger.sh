#!/usr/bin/env bash
# Inventory logging

ptk_inventory_log() {
    local message="$1"
    local logfile="${2:-}"

    if [[ -z "$logfile" ]]; then
        local cfg="${PTK_INVENTORY_CONFIG:-config/inventory.conf}"
        [[ -f "$cfg" ]] || {
            echo "[ERROR] Inventory configuration not found: $cfg" >&2
            return 1
        }
        # shellcheck disable=SC1090
        source "$cfg"
        : "${REPORT_DIR:=./reports}"
        : "${INVENTORY_LOG:=inventory.log}"
        logfile="$REPORT_DIR/$INVENTORY_LOG"
    fi

    mkdir -p "$(dirname "$logfile")" || return 1
    printf "[%s] %s\n" "$(date '+%F %T')" "$message" >> "$logfile"
}
