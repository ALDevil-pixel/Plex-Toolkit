#!/usr/bin/env bash
# Chargement et validation de la configuration Films.

ptk_load_movie_config() {
    local config_file="${1:-config/movies.conf}"

    source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
    ptk_load_config "$config_file" || return 1

    : "${MOVIES_ROOT:=}"
    : "${MOVIES_VIDEO_EXTENSIONS:=}"
    : "${MOVIES_MIN_SIZE:=0}"
    : "${MOVIES_INCLUDE_HIDDEN:=false}"

    ptk_validate_movie_config
}

ptk_validate_movie_config() {
    ptk_config_bool "$MOVIES_INCLUDE_HIDDEN" >/dev/null || {
        echo "[ERROR] Invalid boolean: MOVIES_INCLUDE_HIDDEN=$MOVIES_INCLUDE_HIDDEN" >&2
        return 1
    }

    [[ "$MOVIES_MIN_SIZE" =~ ^[0-9]+$ ]] || {
        echo "[ERROR] Invalid integer: MOVIES_MIN_SIZE=$MOVIES_MIN_SIZE" >&2
        return 1
    }

    [[ -n "$MOVIES_VIDEO_EXTENSIONS" ]] || {
        echo "[ERROR] Configuration value is empty: MOVIES_VIDEO_EXTENSIONS" >&2
        return 1
    }

    return 0
}
