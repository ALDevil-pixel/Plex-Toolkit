#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/check_zero_size.sh"
source "$(dirname "${BASH_SOURCE[0]}")/check_extensions.sh"
source "$(dirname "${BASH_SOURCE[0]}")/check_report.sh"

ptk_check_library() {
    local path="$1"
    [[ -d "$path" ]] || return 1

    echo "== Checking: $path =="

    find "$path" -type f | while read -r f; do
        echo "[CHECK] $f"
    done

    echo
    ptk_find_zero_size_files "$path"

    echo
    ptk_find_invalid_extensions "$path"

    echo
    ptk_check_report "$path"
}
