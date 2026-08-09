#!/usr/bin/env bash
# Compare local inventory records with Plex metadata.
# This is diagnostic/read-only.

ptk_inventory_plex_compare() {
    local local_inventory="$1"
    local plex_library="$2"

    [[ -f "$local_inventory" ]] || {
        echo "[ERROR] Local inventory not found: $local_inventory" >&2
        return 1
    }

    [[ "$plex_library" =~ ^[0-9]+$ ]] || {
        echo "[ERROR] Invalid Plex library key: $plex_library" >&2
        return 2
    }

    local plex_records
    plex_records="$(mktemp)"

    ptk_plex_inventory_export "$plex_library" > "$plex_records" || {
        local rc=$?
        rm -f -- "$plex_records"
        return "$rc"
    }

    echo "Status|Local path|Local name|Plex title|Year|Plex ratingKey"

    while IFS='|' read -r name ext size mtime hash path; do
        [[ -n "$name" ]] || continue

        local found=""
        while IFS='|' read -r plex_title plex_year duration rating_key updated_at plex_paths; do
            [[ -n "$plex_title" ]] || continue

            local normalized_local normalized_plex
            normalized_local="$(ptk_plex_normalize_title "${name%.*}")"
            normalized_plex="$(ptk_plex_normalize_title "$plex_title")"

            if [[ "$normalized_local" == "$normalized_plex" &&
                  ( -z "$plex_year" || "$name" == *"$plex_year"* ) ]]; then
                found="$plex_title|$plex_year|$rating_key"
                break
            fi
        done < "$plex_records"

        if [[ -n "$found" ]]; then
            IFS='|' read -r plex_title plex_year rating_key <<< "$found"
            printf 'MATCH|%s|%s|%s|%s|%s\n' \
                "$path" "$name" "$plex_title" "${plex_year:--}" "$rating_key"
        else
            printf 'LOCAL_ONLY|%s|%s|-|-|-\n' "$path" "$name"
        fi
    done < "$local_inventory"

    rm -f -- "$plex_records"
}
