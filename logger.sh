#!/usr/bin/env bash
log(){ lvl="$1"; shift; mkdir -p "${LOG_DIR:-logs}"; printf "%s [%s] %s\n" "$(date '+%F %T')" "$lvl" "$*"|tee -a "${LOG_DIR:-logs}/$(date +%F).log" >/dev/null;}
log_info(){ log INFO "$@"; }
log_warn(){ log WARN "$@"; }
log_error(){ log ERROR "$@"; }
log_success(){ log SUCCESS "$@"; }
