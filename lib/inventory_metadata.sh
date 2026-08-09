#!/usr/bin/env bash
# Metadata collection for inventory.
# Output format remains pipe-delimited for compatibility.

ptk_inventory_hash_file() {
    local file="$1"

    [[ "$INVENTORY_HASH_ENABLED" == "true" ]] || {
        printf '%s\n' ""
        return 0
    }

    case "${INVENTORY_HASH_ALGORITHM,,}" in
        sha256)
            sha256sum -- "$file" | awk '{print $1}'
            ;;
        md5)
            md5sum -- "$file" | awk '{print $1}'
            ;;
        *)
            echo "[ERROR] Unsupported inventory hash algorithm: $INVENTORY_HASH_ALGORITHM" >&2
            return 2
            ;;
    esac
}

ptk_inventory_metadata() {
    local file="$1"
    [[ -f "$file" ]] || return 1

    local name ext size mtime hash
    name="$(basename "$file")"
    ext="${name##*.}"
    size="$(stat -c %s -- "$file" 2>/dev/null)" || return 1
    mtime="$(stat -c %y -- "$file" 2>/dev/null | cut -d'.' -f1)" || return 1
    hash="$(ptk_inventory_hash_file "$file")" || return $?

    printf "%s|%s|%s|%s|%s|%s\n" \
        "$name" "$ext" "$size" "$mtime" "$hash" "$file"
}
