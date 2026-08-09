#!/usr/bin/env bash
# Chargement et validation de la configuration Plex.
#
# Aucun appel réseau n'est effectué par ce module.

ptk_load_plex_config() {
    local config_file="${1:-config/plex.conf}"

    source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
    ptk_load_config "$config_file" || return 1

    : "${PLEX_URL:=}"
    : "${PLEX_TOKEN:=}"
    : "${PLEX_TIMEOUT:=10}"
    : "${PLEX_VERIFY_TLS:=true}"
    : "${PLEX_RETRIES:=2}"

    ptk_validate_plex_config
}

ptk_validate_plex_url() {
    local url="$1"

    [[ -n "$url" ]] || {
        echo "[ERROR] Configuration value is empty: PLEX_URL" >&2
        return 1
    }

    [[ "$url" =~ ^https?://[^/]+/?$ ]] || {
        echo "[ERROR] Invalid Plex URL: $url" >&2
        return 1
    }

    return 0
}

ptk_validate_plex_config() {
    ptk_validate_plex_url "$PLEX_URL" || return 1

    [[ -n "$PLEX_TOKEN" ]] || {
        echo "[ERROR] Configuration value is empty: PLEX_TOKEN" >&2
        return 1
    }

    [[ "$PLEX_TIMEOUT" =~ ^[1-9][0-9]*$ ]] || {
        echo "[ERROR] Invalid Plex timeout: $PLEX_TIMEOUT" >&2
        return 1
    }

    [[ "$PLEX_RETRIES" =~ ^[0-9]+$ ]] || {
        echo "[ERROR] Invalid Plex retries: $PLEX_RETRIES" >&2
        return 1
    }

    ptk_config_validate_bool "$PLEX_VERIFY_TLS"  >/dev/null || {
        echo "[ERROR] Invalid boolean: PLEX_VERIFY_TLS=$PLEX_VERIFY_TLS" >&2
        return 1
    }

    return 0
}

ptk_plex_url() {
    local path="${1:-}"
    printf '%s/%s\n' "${PLEX_URL%/}" "${path#/}"
}
