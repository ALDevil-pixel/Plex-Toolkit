#!/usr/bin/env bash
# Codes de sortie communs Plex Toolkit

PTK_EXIT_OK=0
PTK_EXIT_ERROR=1
PTK_EXIT_USAGE=2

ptk_is_valid_exit_code() {
    case "$1" in
        "$PTK_EXIT_OK"|"$PTK_EXIT_ERROR"|"$PTK_EXIT_USAGE") return 0 ;;
        *) return 1 ;;
    esac
}

ptk_return() {
    local code="$1"
    ptk_is_valid_exit_code "$code" || code="$PTK_EXIT_ERROR"
    return "$code"
}
