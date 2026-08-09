#!/usr/bin/env bash
# Progress display helpers.

ptk_progress() {
    local current="${1:-0}"
    local total="${2:-0}"

    if [[ "$total" -le 0 || "$current" -lt 0 ]]; then
        return 2
    fi

    if [[ "$current" -gt "$total" ]]; then
        current="$total"
    fi

    printf '\r[%3d%%]' "$((current * 100 / total))"
}

progress() {
    ptk_progress "$@"
}
