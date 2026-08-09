#!/usr/bin/env bash
# Common CLI options. Command-specific parsers may consume additional options
# after this parser has handled the common ones.

PTK_DRY_RUN=1
PTK_VERBOSE=0
PTK_QUIET=0
PTK_POSITIONAL=()
PTK_CONFIG_FILE=""
PTK_COMMON_OPTIONS_REMAINING=()
PTK_CLI_DRY_RUN_SET=0
PTK_CLI_VERBOSE_SET=0
PTK_CLI_QUIET_SET=0
PTK_CLI_FIX_SET=0

ptk_set_config_override() {
    local config_file="$1"
    local base
    base="$(basename -- "$config_file")"

    PTK_CONFIG_FILE="$config_file"
    export PTK_CONFIG_FILE
    PLEXTK_CONFIG="$config_file"
    export PLEXTK_CONFIG

    case "$base" in
        plex.conf|plex.yaml) PTK_PLEX_CONFIG="$config_file"; export PTK_PLEX_CONFIG ;;
        plex-sync.conf|plex-sync.yaml) PTK_PLEX_SYNC_CONFIG="$config_file"; export PTK_PLEX_SYNC_CONFIG ;;
        inventory.conf|inventory.yaml) PTK_INVENTORY_CONFIG="$config_file"; export PTK_INVENTORY_CONFIG ;;
        anime.conf|anime.yaml) PTK_ANIME_CONFIG="$config_file"; export PTK_ANIME_CONFIG ;;
        movies.conf|movies.yaml) PTK_MOVIE_CONFIG="$config_file"; export PTK_MOVIE_CONFIG ;;
        report.conf|report.yaml) PTK_REPORT_CONFIG="$config_file"; export PTK_REPORT_CONFIG ;;
        check.conf|check.yaml) PTK_CHECK_CONFIG="$config_file"; export PTK_CHECK_CONFIG ;;
    esac
}

ptk_parse_common_options() {
    PTK_DRY_RUN=1
    PTK_VERBOSE=0
    PTK_QUIET=0
    PTK_POSITIONAL=()
    PTK_CONFIG_FILE=""
    PTK_COMMON_OPTIONS_REMAINING=()
PTK_CLI_DRY_RUN_SET=0
PTK_CLI_VERBOSE_SET=0
PTK_CLI_QUIET_SET=0
PTK_CLI_FIX_SET=0

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run) PTK_DRY_RUN=1; PTK_CLI_DRY_RUN_SET=1 ;;
            --fix) PTK_DRY_RUN=0; PTK_CLI_DRY_RUN_SET=1; PTK_CLI_FIX_SET=1 ;;
            --verbose|-v) PTK_VERBOSE=1; PTK_CLI_VERBOSE_SET=1 ;;
            --quiet|-q) PTK_QUIET=1; PTK_CLI_QUIET_SET=1 ;;
            --config)
                shift
                if [[ $# -eq 0 ]]; then
                    ptk_usage_error "--config requires a value"
                    return $?
                fi
                ptk_set_config_override "$1"
                ;;
            --)
                shift
                while [[ $# -gt 0 ]]; do PTK_POSITIONAL+=("$1"); shift; done
                break
                ;;
            --deep|--summary)
                PTK_POSITIONAL+=("$1")
                ;;
            --min-size|--extensions)
                PTK_POSITIONAL+=("$1")
                shift
                if [[ $# -eq 0 ]]; then
                    ptk_usage_error "$1 requires a value"
                    return $?
                fi
                PTK_POSITIONAL+=("$1")
                ;;
            -*)
                ptk_usage_error "Unknown option: $1"
                return $?
                ;;
            *) PTK_POSITIONAL+=("$1") ;;
        esac
        shift
    done
}

ptk_is_fix_enabled() { [[ "$PTK_DRY_RUN" -eq 0 ]]; }
ptk_is_dry_run() { [[ "$PTK_DRY_RUN" -eq 1 ]]; }

ptk_log_info() {
    [[ "$PTK_QUIET" -eq 1 ]] && return 0
    echo "[INFO] $*"
}
ptk_log_verbose() {
    [[ "$PTK_VERBOSE" -eq 1 && "$PTK_QUIET" -eq 0 ]] || return 0
    echo "[DEBUG] $*"
}

ptk_restore_cli_overrides() {
    # Restore each explicitly supplied CLI option independently.
    if [[ "${PTK_CLI_DRY_RUN_SET:-0}" -eq 1 ]]; then
        if [[ "${PTK_CLI_FIX_SET:-0}" -eq 1 ]]; then
            PTK_DRY_RUN=0
        else
            PTK_DRY_RUN=1
        fi
    fi

    if [[ "${PTK_CLI_VERBOSE_SET:-0}" -eq 1 ]]; then
        PTK_VERBOSE=1
    fi

    if [[ "${PTK_CLI_QUIET_SET:-0}" -eq 1 ]]; then
        PTK_QUIET=1
    fi
}
