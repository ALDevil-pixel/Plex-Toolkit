#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/inventory_metadata.sh"

ptk_inventory_library() {
    local path="$1"
    [[ -d "$path" ]] || return 1

    find "$path" -type f | while read -r file; do
        IFS='|' read -r name ext size mtime fullpath <<EOF
$(ptk_inventory_metadata "$file")
EOF
        echo "[FILE] $name | $ext | $size bytes | $mtime"
    done
}
