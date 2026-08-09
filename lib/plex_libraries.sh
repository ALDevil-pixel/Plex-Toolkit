#!/usr/bin/env bash
# Découverte et validation des bibliothèques Plex.

ptk_plex_libraries_json() {
    ptk_plex_request GET "/library/sections"
}

ptk_plex_library_type() {
    local type="$1"
    case "${type,,}" in
        movie) printf 'Movies\n' ;;
        show|tv) printf 'TV Shows\n' ;;
        artist) printf 'Music\n' ;;
        photo) printf 'Photos\n' ;;
        *) printf '%s\n' "$type" ;;
    esac
}

ptk_plex_list_libraries() {
    local json
    json="$(ptk_plex_libraries_json)" || return $?

    command -v jq >/dev/null 2>&1 || {
        echo "[ERROR] jq is required to parse Plex library responses." >&2
        return 2
    }

    jq -r '.MediaContainer.Directory[]? |
        [.key, .type, .title, (.agent // ""), (.scanner // "")] |
        @tsv' <<< "$json"
}

ptk_plex_library_exists() {
    local key="$1"
    [[ "$key" =~ ^[0-9]+$ ]] || return 2
    ptk_plex_list_libraries |
        awk -F '\t' -v wanted="$key" '$1 == wanted { found=1 } END { exit(found ? 0 : 1) }'
}

ptk_plex_library_locations() {
    local key="$1"
    [[ "$key" =~ ^[0-9]+$ ]] || {
        echo "[ERROR] Invalid Plex library key: $key" >&2
        return 2
    }

    local json
    json="$(ptk_plex_libraries_json)" || return $?

    jq -r --arg key "$key" '
        .MediaContainer.Directory[]?
        | select((.key // "") == $key)
        | .Location[]?.path
    ' <<< "$json"
}
