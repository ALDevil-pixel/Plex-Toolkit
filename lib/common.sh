#!/usr/bin/env bash
# Plex-Toolkit - common.sh

ptk_timestamp() { date +"%Y-%m-%d %H:%M:%S"; }

ptk_info()    { printf "[INFO] %s\n" "$*"; }
ptk_success() { printf "[ OK ] %s\n" "$*"; }
ptk_warn()    { printf "[WARN] %s\n" "$*"; }
ptk_error()   { printf "[FAIL] %s\n" "$*" >&2; }

require_command() {
    command -v "$1" >/dev/null 2>&1 || {
        ptk_error "Commande introuvable : $1"
        return 1
    }
}
