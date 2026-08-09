#!/usr/bin/env bash
# CLI dispatcher compatibility layer.
#
# The root plex-toolkit dispatcher is the primary entry point.
# This function remains available for legacy callers.

ptk_dispatch() {
    local cmd="${1:-}"
    shift || true

    if [[ -z "$cmd" ]]; then
        printf '[ERROR] No command specified\n' >&2
        return "${PTK_EXIT_USAGE:-2}"
    fi

    if declare -F "cmd_${cmd}" >/dev/null 2>&1; then
        "cmd_${cmd}" "$@"
        return $?
    fi

    printf '[ERROR] Unknown command: %s\n' "$cmd" >&2
    return "${PTK_EXIT_USAGE:-2}"
}
