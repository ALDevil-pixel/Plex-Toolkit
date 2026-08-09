#!/usr/bin/env bash
# Lecture des médias d'une bibliothèque Plex.
# Ce module est strictement en lecture seule.

ptk_plex_library_media_json() {
    local library_key="$1"
    local path="/library/sections/${library_key}/all"

    [[ "$library_key" =~ ^[0-9]+$ ]] || {
        echo "[ERROR] Invalid Plex library key: $library_key" >&2
        return 2
    }

    ptk_plex_request GET "$path"
}

ptk_plex_list_media() {
    local library_key="$1"
    local json
    json="$(ptk_plex_library_media_json "$library_key")" || return $?

    command -v jq >/dev/null 2>&1 || {
        echo "[ERROR] jq is required to parse Plex media responses." >&2
        return 2
    }

    jq -r '
        .MediaContainer.Metadata[]? |
        [
            (.ratingKey // ""),
            (.type // ""),
            (.title // ""),
            (.year // ""),
            (.librarySectionID // ""),
            (.librarySectionTitle // ""),
            (.updatedAt // "")
        ] | @tsv
    ' <<< "$json"
}

ptk_plex_media_count() {
    local library_key="$1"
    local json
    json="$(ptk_plex_library_media_json "$library_key")" || return $?

    command -v jq >/dev/null 2>&1 || return 2
    jq -r '.MediaContainer.size // (.MediaContainer.Metadata | length) // 0' <<< "$json"
}
