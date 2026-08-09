#!/usr/bin/env bash
# Chargement et validation centralisés de la configuration Plex Toolkit.

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

    ptk_validate_config || return $?
    return 0
}

ptk_config_bool() {
    case "${1,,}" in
        true|yes|1|on) return 0 ;;
        false|no|0|off) return 1 ;;
        *) return 2 ;;
    esac
}

ptk_config_require_nonempty() {
    local name="$1"
    local value="${!name:-}"

    if [[ -z "$value" ]]; then
        echo "[ERROR] Configuration value is empty: $name" >&2
        return 1
    fi

    return 0
}

ptk_config_validate_path() {
    local name="$1"
    local value="${!name:-}"

    ptk_config_require_nonempty "$name" || return 1

    if [[ "$value" == *$'\n'* || "$value" == *$'\r'* ]]; then
        echo "[ERROR] Configuration path contains a newline: $name" >&2
        return 1
    fi

    return 0
}

ptk_validate_config() {
    ptk_config_validate_path PTK_LOG_DIR || return 1
    ptk_config_validate_path PTK_REPORT_DIR || return 1

    ptk_config_bool "$PTK_DRY_RUN" >/dev/null || {
        echo "[ERROR] Invalid boolean: PTK_DRY_RUN=$PTK_DRY_RUN" >&2
        return 1
    }

    ptk_config_bool "$PTK_VERBOSE" >/dev/null || {
        echo "[ERROR] Invalid boolean: PTK_VERBOSE=$PTK_VERBOSE" >&2
        return 1
    }

    ptk_config_bool "$PTK_COLOR" >/dev/null || {
        echo "[ERROR] Invalid boolean: PTK_COLOR=$PTK_COLOR" >&2
        return 1
    }

    ptk_config_require_nonempty PTK_VIDEO_EXTENSIONS || return 1

    return 0
}
