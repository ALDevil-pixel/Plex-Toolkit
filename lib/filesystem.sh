#!/usr/bin/env bash
# Filesystem compatibility helpers.

ptk_require_dir() {
    local path="${1:-}"

    if [[ -z "$path" ]]; then
        printf '[ERROR] Directory path is required.\n' >&2
        return 2
    fi

    [[ -d "$path" ]] || mkdir -p -- "$path"
}

require_dir() {
    ptk_require_dir "$@"
}

ptk_safe_remove() {
    local path="${1:-}"

    if [[ -z "$path" ]]; then
        printf '[ERROR] Path is required.\n' >&2
        return 2
    fi

    if [[ "${PTK_DRY_RUN:-1}" -eq 1 || "${DRY_RUN:-false}" == true ]]; then
        printf '[DRY-RUN] rm %s\n' "$path"
        return 0
    fi

    rm -rf -- "$path"
}

safe_remove() {
    ptk_safe_remove "$@"
}
