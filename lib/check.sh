#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/check_zero_size.sh"
source "$(dirname "${BASH_SOURCE[0]}")/check_extensions.sh"

ptk_check_library() {
    local path="$1"
    [[ -d "$path" ]] || return 1

    echo "== Checking: $path =="

    find "$path" -type f | while read -r file; do
        echo "[CHECK] $file"
    done

    echo
    echo "Searching zero-byte files..."
    ptk_find_zero_size_files "$path"

    echo
    echo "Searching invalid extensions..."
    ptk_find_invalid_extensions "$path"
}
