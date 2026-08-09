#!/usr/bin/env bash
# Plex Toolkit - common helpers
#
# Legacy compatibility layer.
# New commands should use the dedicated modules:
#   cli_errors.sh
#   logger.sh
#   config.sh
#   exit_codes.sh

ptk_timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

ptk_info() {
    printf "[INFO] %s\n" "$*"
}

ptk_success() {
    printf "[ OK ] %s\n" "$*"
}

ptk_warn() {
    printf "[WARN] %s\n" "$*"
}

ptk_error() {
    printf "[ERROR] %s\n" "$*" >&2
}

ptk_require_command() {
    local command_name="${1:-}"

    if [[ -z "$command_name" ]]; then
        ptk_error "A command name is required."
        return 2
    fi

    if ! command -v "$command_name" >/dev/null 2>&1; then
        ptk_error "Command not found: $command_name"
        return 1
    fi

    return 0
}

require_command() {
    ptk_require_command "$@"
}
