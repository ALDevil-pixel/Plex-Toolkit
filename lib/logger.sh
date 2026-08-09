#!/usr/bin/env bash
# Journalisation commune Plex Toolkit

if [[ -z "${PTK_LOG_FILE:-}" ]]; then
    if [[ -n "${PTK_LOG_DIR:-}" ]]; then
        PTK_LOG_FILE="$PTK_LOG_DIR/plex-toolkit.log"
    else
        PTK_LOG_FILE="logs/plex-toolkit.log"
    fi
fi

ptk_log() {
    local level="$1"
    shift
    local message="$*"

    mkdir -p "$(dirname "$PTK_LOG_FILE")"
    printf '[%s] [%s] %s\n' \
        "$(date '+%F %T')" "$level" "$message" >> "$PTK_LOG_FILE"

    if [[ "${PTK_QUIET:-0}" -eq 0 ]]; then
        case "$level" in
            ERROR) echo "[ERROR] $message" >&2 ;;
            WARN)  echo "[WARN] $message" ;;
            *)     echo "[$level] $message" ;;
        esac
    fi
}

ptk_log_command_start() {
    ptk_log INFO "Starting: $1"
}

ptk_log_command_end() {
    local command="$1"
    local code="$2"
    if [[ "$code" -eq 0 ]]; then
        ptk_log INFO "Completed: $command (exit=$code)"
    else
        ptk_log ERROR "Failed: $command (exit=$code)"
    fi
}
