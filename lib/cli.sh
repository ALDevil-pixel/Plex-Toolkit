#!/usr/bin/env bash
# lib/cli.sh

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
source "$(dirname "${BASH_SOURCE[0]}")/errors.sh"

ptk_dispatch() {
    local cmd="$1"; shift || true
    if [[ -z "$cmd" ]]; then
        ptk_error "No command specified"
        return $PTK_ERROR
    fi
    if command -v "cmd_${cmd}" >/dev/null 2>&1; then
        "cmd_${cmd}" "$@"
    else
        ptk_error "Unknown command: ${cmd}"
        return $PTK_ERROR
    fi
}
