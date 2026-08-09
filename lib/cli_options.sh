#!/usr/bin/env bash
# Options CLI communes

PTK_DRY_RUN=1
PTK_VERBOSE=0
PTK_QUIET=0
PTK_POSITIONAL=()

ptk_parse_common_options() {
    PTK_DRY_RUN=1
    PTK_VERBOSE=0
    PTK_QUIET=0
    PTK_POSITIONAL=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run) PTK_DRY_RUN=1 ;;
            --fix) PTK_DRY_RUN=0 ;;
            --verbose|-v) PTK_VERBOSE=1 ;;
            --quiet|-q) PTK_QUIET=1 ;;
            --)
                shift
                while [[ $# -gt 0 ]]; do
                    PTK_POSITIONAL+=("$1")
                    shift
                done
                break
                ;;
            *) PTK_POSITIONAL+=("$1") ;;
        esac
        shift
    done
}

ptk_log_info() {
    [[ "$PTK_QUIET" -eq 1 ]] && return 0
    echo "[INFO] $*"
}

ptk_log_verbose() {
    [[ "$PTK_VERBOSE" -eq 1 && "$PTK_QUIET" -eq 0 ]] || return 0
    echo "[DEBUG] $*"
}
