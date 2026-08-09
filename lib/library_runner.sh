#!/usr/bin/env bash
# Exécute une fonction sur une bibliothèque ou sur toutes les bibliothèques configurées.
#
# Usage:
#   ptk_run_libraries <callback> [target]
#
# Le callback reçoit :
#   $1 = nom de la bibliothèque
#   $2 = chemin de la bibliothèque

ptk_run_libraries() {
    local callback="$1"
    local target="${2:-}"

    [[ -n "$callback" ]] || return 2

    if [[ -n "$target" ]]; then
        "$callback" "$target" "$target"
        return $?
    fi

    while IFS='|' read -r name path; do
        [[ -n "$name" && -n "$path" ]] || continue
        "$callback" "$name" "$path" || return $?
    done < <(ptk_load_libraries)
}
