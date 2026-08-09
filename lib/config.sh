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

    # Backward-compatible configuration keys remain authoritative when present.
    # This is especially important for inventory/report configurations created
    # before the PTK_* common naming convention.
    if [[ -n "${REPORT_DIR:-}" ]]; then
        PTK_REPORT_DIR="$REPORT_DIR"
    fi

    : "${PTK_LOG_DIR:=./logs}"
    : "${PTK_REPORT_DIR:=./reports}"
    : "${PTK_DRY_RUN:=true}"
    : "${PTK_VERBOSE:=false}"
    : "${PTK_COLOR:=true}"

    ptk_validate_config || return $?

    # Explicit CLI values must remain authoritative over configuration files.
    if declare -F ptk_restore_cli_overrides >/dev/null 2>&1; then
        ptk_restore_cli_overrides
    fi

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

    ptk_config_validate_bool "$PTK_DRY_RUN"  >/dev/null || {
        echo "[ERROR] Invalid boolean: PTK_DRY_RUN=$PTK_DRY_RUN" >&2
        return 1
    }

    ptk_config_validate_bool "$PTK_VERBOSE"  >/dev/null || {
        echo "[ERROR] Invalid boolean: PTK_VERBOSE=$PTK_VERBOSE" >&2
        return 1
    }

    ptk_config_validate_bool "$PTK_COLOR"  >/dev/null || {
        echo "[ERROR] Invalid boolean: PTK_COLOR=$PTK_COLOR" >&2
        return 1
    }

    ptk_config_require_nonempty PTK_VIDEO_EXTENSIONS || return 1

    return 0
}


# Validate a boolean configuration value without using predicate semantics.
# Returns 0 for both valid "true" and valid "false".
ptk_config_validate_bool() {
    local value="${1:-}"
    case "${value,,}" in
        true|false) return 0 ;;
        1|0) return 0 ;;
        yes|no) return 0 ;;
        on|off) return 0 ;;
        *) return 1 ;;
    esac
}

ptk_config_bool_value() {
    local value="${1:-}"
    case "${value,,}" in
        true|1|yes|on) printf 'true\n' ;;
        false|0|no|off) printf 'false\n' ;;
        *) return 1 ;;
    esac
}

# Normalize common CLI booleans after configuration loading.
ptk_normalize_common_booleans() {
    # PTK_DRY_RUN is numeric and is controlled by the CLI.
    if [[ "${PTK_DRY_RUN:-1}" != "0" && "${PTK_DRY_RUN:-1}" != "1" ]]; then
        PTK_DRY_RUN=1
    fi

    # Configuration files may contain booleans, while the CLI parser uses
    # numeric flags. Normalize both forms without treating "false" as an
    # error.
    local verbose_value quiet_value
    verbose_value="$(ptk_config_bool_value "${PTK_VERBOSE:-false}" 2>/dev/null || printf 'false')"
    quiet_value="$(ptk_config_bool_value "${PTK_QUIET:-false}" 2>/dev/null || printf 'false')"

    if [[ "$verbose_value" == "true" ]]; then
        PTK_VERBOSE=1
    else
        PTK_VERBOSE=0
    fi

    if [[ "$quiet_value" == "true" ]]; then
        PTK_QUIET=1
    else
        PTK_QUIET=0
    fi
}

ptk_finalize_config_with_cli() {
    ptk_normalize_common_booleans
    if declare -F ptk_restore_cli_overrides >/dev/null 2>&1; then
        ptk_restore_cli_overrides
    fi
}
