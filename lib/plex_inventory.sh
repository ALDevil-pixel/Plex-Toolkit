#!/usr/bin/env bash
# Convert Plex media metadata into the common inventory identity model.
# This module is read-only.

ptk_plex_inventory_records() {
    local library_key="$1"

    command -v jq >/dev/null 2>&1 || {
        echo "[ERROR] jq is required for Plex inventory." >&2
        return 2
    }

    local json
    json="$(ptk_plex_library_media_json "$library_key")" || return $?

    jq -r '
        .MediaContainer.Metadata[]?
        | select((.type // "") == "movie")
        | [
            (.title // ""),
            (.year // ""),
            (.duration // ""),
            (.ratingKey // ""),
            (.updatedAt // ""),
            ([.Media[]?.Part[]?.file] | map(select(. != null)) | join(";"))
          ]
        | @tsv
    ' <<< "$json"
}

ptk_plex_inventory_export() {
    local library_key="$1"

    while IFS=$'\t' read -r title year duration rating_key updated_at paths; do
        [[ -n "$title" ]] || continue
        printf '%s|%s|%s|%s|%s|%s\n' \
            "$title" "$year" "$duration" "$rating_key" "$updated_at" "$paths"
    done < <(ptk_plex_inventory_records "$library_key")
}
