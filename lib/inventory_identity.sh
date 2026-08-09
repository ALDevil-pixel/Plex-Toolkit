#!/usr/bin/env bash
# Stable identity helpers for inventory comparison.

ptk_inventory_identity() {
    local name="$1"
    local size="$2"
    local hash="$3"

    if [[ -n "$hash" ]]; then
        printf 'hash:%s\n' "$hash"
    else
        printf 'name-size:%s|%s\n' "$name" "$size"
    fi
}

ptk_inventory_metadata_identity() {
    local record="$1"
    local name ext size mtime hash path
    IFS='|' read -r name ext size mtime hash path <<< "$record"
    ptk_inventory_identity "$name" "$size" "$hash"
}
