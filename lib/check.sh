#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/check_zero_size.sh"
source "$(dirname "${BASH_SOURCE[0]}")/check_extensions.sh"
source "$(dirname "${BASH_SOURCE[0]}")/check_report.sh"
source "$(dirname "${BASH_SOURCE[0]}")/library_loader.sh"

ptk_check_library() {
    local p="$1"
    [[ -d "$p" ]] || return 1

    echo "== Checking: $p =="
    find "$p" -type f | while read -r f; do
        echo "[CHECK] $f"
    done

    ptk_find_zero_size_files "$p"
    ptk_find_invalid_extensions "$p"
    ptk_check_report "$p"
}

ptk_check() {
    local target="${1:-}"

    if [[ -n "$target" ]]; then
        ptk_check_library "$target"
        return $?
    fi

    while IFS='|' read -r name path; do
        [[ -n "$name" && -n "$path" ]] || continue
        echo "== $name =="
        ptk_check_library "$path" || return $?
    done < <(ptk_load_libraries)
}
