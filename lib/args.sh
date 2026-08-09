#!/usr/bin/env bash
# Legacy argument compatibility layer.
#
# New commands must use lib/cli_options.sh.

DRY_RUN=false
VERBOSE=false
QUIET=false
FORCE=false
POSITIONAL=()

parse_args() {
    DRY_RUN=false
    VERBOSE=false
    QUIET=false
    FORCE=false
    POSITIONAL=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run)
                DRY_RUN=true
                ;;
            --verbose|-v)
                VERBOSE=true
                ;;
            --quiet|-q)
                QUIET=true
                ;;
            --force)
                FORCE=true
                ;;
            --config)
                shift
                if [[ $# -eq 0 ]]; then
                    printf '[ERROR] --config requires a value\n' >&2
                    return 2
                fi
                PLEXTK_CONFIG="$1"
                export PLEXTK_CONFIG
                ;;
            --)
                shift
                while [[ $# -gt 0 ]]; do
                    POSITIONAL+=("$1")
                    shift
                done
                break
                ;;
            *)
                POSITIONAL+=("$1")
                ;;
        esac
        shift
    done

    return 0
}
