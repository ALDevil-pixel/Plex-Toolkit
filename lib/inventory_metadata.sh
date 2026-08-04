#!/usr/bin/env bash
# Metadata collection

ptk_inventory_metadata() {
    local file="$1"
    [[ -f "$file" ]] || return 1

    local name ext size mtime
    name="$(basename "$file")"
    ext="${name##*.}"
    size=$(stat -c %s "$file" 2>/dev/null)
    mtime=$(stat -c %y "$file" 2>/dev/null | cut -d'.' -f1)

    printf "%s|%s|%s|%s|%s\n" "$name" "$ext" "$size" "$mtime" "$file"
}
