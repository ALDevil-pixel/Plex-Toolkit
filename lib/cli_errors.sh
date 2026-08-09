#!/usr/bin/env bash
# Gestion commune des erreurs CLI.

ptk_error() {
    echo "[ERROR] $*" >&2
}

ptk_usage_error() {
    ptk_error "$*"
    return "${PTK_EXIT_USAGE:-2}"
}

ptk_require_directory() {
    local path="${1:-}"

    if [[ -z "$path" ]]; then
        ptk_usage_error "A directory is required."
        return $?
    fi

    if [[ ! -d "$path" ]]; then
        ptk_error "Directory not found: $path"
        return "${PTK_EXIT_ERROR:-1}"
    fi

    return "${PTK_EXIT_OK:-0}"
}

ptk_require_option_value() {
    local option="${1:-}"
    local value="${2:-}"

    if [[ -z "$option" || -z "$value" ]]; then
        ptk_usage_error "Option requires a value: ${option:-unknown}"
        return $?
    fi

    return "${PTK_EXIT_OK:-0}"
}
