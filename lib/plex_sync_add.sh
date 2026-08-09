#!/usr/bin/env bash
# Ajout logique d'un média local à une bibliothèque Plex.
#
# Plex ajoute les médias en actualisant la section. Pour éviter un scan
# de toute la bibliothèque, le chemin du répertoire contenant le fichier
# est toujours transmis.

ptk_plex_sync_add() {
    local file="$1"
    local library_key="$2"

    ptk_plex_sync_validate_file "$file" || return $?
    ptk_plex_sync_validate_library "$library_key" || return $?

    local scan_dir
    scan_dir="$(ptk_plex_sync_validate_library_path "$file" "$library_key")" || return $?

    local encoded_path
    encoded_path="$(jq -rn --arg path "$scan_dir" '$path|@uri')" || {
        echo "[ERROR] Unable to URL-encode Plex scan path." >&2
        return 2
    }

    # Always use the narrowest valid directory. Never refresh the entire library.
    ptk_plex_request GET "/library/sections/${library_key}/refresh?path=${encoded_path}" >/dev/null || return $?

    echo "Plex add request: OK"
    echo "Library key   : $library_key"
    echo "File          : $file"
    echo "Scan path     : $scan_dir"
    return 0
}
