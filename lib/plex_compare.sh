#!/usr/bin/env bash
# Comparaison locale <-> Plex.
#
# Cette couche ne modifie ni les fichiers locaux ni le serveur Plex.

ptk_plex_normalize_title() {
    local value="$1"
    printf '%s\n' "$value" |
        sed -E 's/[[:space:]]+/ /g; s/^ +//; s/ +$//' |
        tr '[:upper:]' '[:lower:]'
}

ptk_plex_compare_media() {
    local local_root="$1"
    local library_key="$2"

    [[ -d "$local_root" ]] || {
        echo "[ERROR] Local media directory not found: $local_root" >&2
        return 1
    }

    [[ "$library_key" =~ ^[0-9]+$ ]] || {
        echo "[ERROR] Invalid Plex library key: $library_key" >&2
        return 2
    }

    command -v jq >/dev/null 2>&1 || {
        echo "[ERROR] jq is required for Plex comparison." >&2
        return 2
    }

    local plex_json
    plex_json="$(ptk_plex_library_media_json "$library_key")" || return $?

    local plex_tmp local_tmp
    plex_tmp="$(mktemp)"
    local_tmp="$(mktemp)"

    cleanup_compare_tmp() {
        rm -f -- "$plex_tmp" "$local_tmp"
    }
    trap cleanup_compare_tmp RETURN

    jq -r '
        .MediaContainer.Metadata[]? |
        select((.type // "") == "movie") |
        [(.title // ""), (.year // "")] | @tsv
    ' <<< "$plex_json" |
        while IFS=$'\t' read -r title year; do
            [[ -n "$title" ]] || continue
            printf '%s\t%s\n' "$(ptk_plex_normalize_title "$title")" "$year"
        done | sort -u > "$plex_tmp"

    while IFS= read -r -d '' file; do
        local filename="${file##*/}"
        local base="${filename%.*}"
        local year=""
        local title="$base"

        if [[ "$base" =~ (^|[^0-9])((19|20)[0-9]{2})([^0-9]|$) ]]; then
            year="${BASH_REMATCH[2]}"
            title="${base/${BASH_REMATCH[2]}/}"
        fi

        title="$(printf '%s\n' "$title" |
            sed -E 's/\([[:space:]]*\)//g; s/[._-]+/ /g; s/[[:space:]]+/ /g; s/^ +//; s/ +$//')"

        printf '%s\t%s\t%s\n' \
            "$(ptk_plex_normalize_title "$title")" "$year" "$file"
    done < <(find "$local_root" -type f \( \
        -iname '*.mkv' -o -iname '*.mp4' -o -iname '*.ts' \
    \) -print0 | sort -z) > "$local_tmp"

    echo "Status	Local file	Plex title	Year"

    while IFS=$'\t' read -r local_title local_year file; do
        [[ -n "$file" ]] || continue

        if awk -F '\t' -v t="$local_title" -v y="$local_year" \
            '$1 == t && ($2 == y || y == "" || $2 == "") { found=1; title=$1; year=$2 }
             END { if (found) print title "\t" year }' "$plex_tmp" |
            grep -q .; then
            local match
            match="$(awk -F '\t' -v t="$local_title" -v y="$local_year" \
                '$1 == t && ($2 == y || y == "" || $2 == "") { print $1 "\t" $2; exit }' "$plex_tmp")"
            printf 'MATCH\t%s\t%s\t%s\n' "$file" "${match%%$'\t'*}" "${match#*$'\t'}"
        else
            printf 'LOCAL_ONLY\t%s\t-\t%s\n' "$file" "${local_year:--}"
        fi
    done < "$local_tmp"

    while IFS=$'\t' read -r plex_title plex_year; do
        [[ -n "$plex_title" ]] || continue

        if ! awk -F '\t' -v t="$plex_title" -v y="$plex_year" \
            '$1 == t && ($2 == y || y == "" || $2 == "") { found=1 }
             END { exit(found ? 0 : 1) }' "$local_tmp"; then
            printf 'PLEX_ONLY\t-\t%s\t%s\n' "$plex_title" "${plex_year:--}"
        fi
    done < "$plex_tmp"

    trap - RETURN
    cleanup_compare_tmp
    return 0
}
