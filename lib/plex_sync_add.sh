#!/usr/bin/env bash
# Ajout logique d'un média local à une bibliothèque Plex.
# Le Toolkit demande un refresh ciblé du répertoire du média.

ptk_plex_sync_add() {
    local file="$1"
    local library_key="$2"

    ptk_plex_sync_validate_file "$file" || return $?
    ptk_plex_sync_validate_library "$library_key" || return $?

    local scan_dir
    scan_dir="$(ptk_plex_sync_validate_library_path "$file" "$library_key")" || return $?

    command -v jq >/dev/null 2>&1 || {
        echo "[ERROR] jq is required for Plex refresh requests." >&2
        return 2
    }

    local encoded_path
    encoded_path="$(jq -rn --arg path "$scan_dir" '$path|@uri')" || {
        echo "[ERROR] Unable to URL-encode Plex scan path." >&2
        return 2
    }

    ptk_plex_request GET \
        "/library/sections/${library_key}/refresh?path=${encoded_path}" >/dev/null || return $?

    echo "Plex add request: OK"
    echo "Library key   : $library_key"
    echo "File          : $file"
    echo "Scan path     : $scan_dir"
    return 0
}
