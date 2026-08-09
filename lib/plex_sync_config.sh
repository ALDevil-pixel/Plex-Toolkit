#!/usr/bin/env bash
# Configuration de synchronisation Plex.
# Cette partie ne réalise aucune modification.

ptk_load_plex_sync_config() {
    local config_file="${1:-config/plex-sync.conf}"

    source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
    ptk_load_config "$config_file" || return 1

    : "${PLEX_SYNC_MODE:=local-to-plex}"
    : "${PLEX_SYNC_MOVIE_EXTENSIONS:=mkv mp4 ts}"
    : "${PLEX_SYNC_REQUIRE_YEAR:=false}"
    : "${PLEX_SYNC_ALLOW_PLEX_ONLY:=false}"

    ptk_validate_plex_sync_config
}

ptk_validate_plex_sync_config() {
    [[ "$PLEX_SYNC_MODE" == "local-to-plex" ]] || {
        echo "[ERROR] Unsupported Plex sync mode: $PLEX_SYNC_MODE" >&2
        return 1
    }

    [[ -n "$PLEX_SYNC_MOVIE_EXTENSIONS" ]] || {
        echo "[ERROR] PLEX_SYNC_MOVIE_EXTENSIONS cannot be empty." >&2
        return 1
    }

    ptk_config_bool "$PLEX_SYNC_REQUIRE_YEAR" >/dev/null || {
        echo "[ERROR] Invalid boolean: PLEX_SYNC_REQUIRE_YEAR=$PLEX_SYNC_REQUIRE_YEAR" >&2
        return 1
    }

    ptk_config_bool "$PLEX_SYNC_ALLOW_PLEX_ONLY" >/dev/null || {
        echo "[ERROR] Invalid boolean: PLEX_SYNC_ALLOW_PLEX_ONLY=$PLEX_SYNC_ALLOW_PLEX_ONLY" >&2
        return 1
    }

    if [[ "$PLEX_SYNC_ALLOW_PLEX_ONLY" == "true" ]]; then
        echo "[ERROR] Plex-only actions are disabled in Sprint 1.14.0.1." >&2
        return 1
    fi

    return 0
}
