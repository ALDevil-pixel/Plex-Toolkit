#!/usr/bin/env bash
# Chargement centralisé de la configuration Plex Toolkit.

ptk_load_config() {
    local config_file="${1:-}"
    local root="${PTK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
    local defaults="${PTK_DEFAULT_CONFIG:-$root/config/defaults.conf}"

    if [[ ! -f "$defaults" ]]; then
        echo "[ERROR] Default configuration not found: $defaults" >&2
        return 1
    fi

    # shellcheck disable=SC1090
    source "$defaults"

    if [[ -n "$config_file" ]]; then
        if [[ ! -f "$config_file" ]]; then
            echo "[ERROR] Configuration not found: $config_file" >&2
            return 1
        fi

        # shellcheck disable=SC1090
        source "$config_file"
    fi

    : "${PTK_LOG_DIR:=./logs}"
    : "${PTK_REPORT_DIR:=./reports}"
    : "${PTK_DRY_RUN:=true}"
    : "${PTK_VERBOSE:=false}"
    : "${PTK_COLOR:=true}"

    return 0
}

ptk_config_bool() {
    case "${1,,}" in
        true|yes|1|on) return 0 ;;
        false|no|0|off) return 1 ;;
        *) return 2 ;;
    esac
}
