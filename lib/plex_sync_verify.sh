#!/usr/bin/env bash
# Vérification post-action d'un refresh Plex.
# Aucun changement n'est effectué par ce module.

ptk_plex_find_media_by_title_year() {
    local library_key="$1"
    local title="$2"
    local year="$3"

    command -v jq >/dev/null 2>&1 || {
        echo "[ERROR] jq is required for Plex verification." >&2
        return 2
    }

    local json
    json="$(ptk_plex_library_media_json "$library_key")" || return $?

    jq -r --arg title "$title" --arg year "$year" '
        .MediaContainer.Metadata[]?
        | select((.type // "") == "movie")
        | select((.title // "") == $title)
        | select(($year == "") or (($year | tonumber?) == (.year // null)))
        | [(.ratingKey // ""), (.title // ""), (.year // ""), (.updatedAt // "")]
        | @tsv
    ' <<< "$json"
}

ptk_plex_sync_extract_title_year() {
    local file="$1"
    local base="${file##*/}"
    base="${base%.*}"

    local year=""
    local title="$base"

    if [[ "$base" =~ (^|[^0-9])((19|20)[0-9]{2})([^0-9]|$) ]]; then
        year="${BASH_REMATCH[2]}"
        title="${base/${BASH_REMATCH[2]}/}"
    fi

    title="$(printf '%s\n' "$title" |
        sed -E 's/\([[:space:]]*\)//g; s/[._-]+/ /g; s/[[:space:]]+/ /g; s/^ +//; s/ +$//')"

    printf '%s\t%s\n' "$title" "$year"
}

ptk_plex_sync_verify_add() {
    local file="$1"
    local library_key="$2"

    local metadata
    metadata="$(ptk_plex_sync_extract_title_year "$file")" || return $?
    local title="${metadata%%$'\t'*}"
    local year="${metadata#*$'\t'}"

    local result
    result="$(ptk_plex_find_media_by_title_year "$library_key" "$title" "$year")" || return $?

    if [[ -n "$result" ]]; then
        printf '%s\n' "$result"
        return 0
    fi

    return 1
}
