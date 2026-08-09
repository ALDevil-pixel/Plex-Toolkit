#!/usr/bin/env bash
# Plan de synchronisation Plex.
#
# IMPORTANT : ce module ne modifie ni Plex ni le stockage local.
# Il transforme le résultat de comparaison en actions proposées.

ptk_plex_sync_extension_allowed() {
    local file="$1"
    local ext="${file##*.}"
    local allowed

    for allowed in $PLEX_SYNC_MOVIE_EXTENSIONS; do
        [[ "${allowed,,}" == "${ext,,}" ]] && return 0
    done

    return 1
}

ptk_plex_sync_plan() {
    local local_root="$1"
    local library_key="$2"

    ptk_plex_validate_action_target "$local_root" "$library_key" || return $?
    ptk_plex_confirm_library_type "$library_key" "movie" || return $?

    local compare_output
    compare_output="$(ptk_plex_compare_media "$local_root" "$library_key")" || return $?

    echo "Action	Status	Local file	Plex title	Year"

    while IFS=$'\t' read -r status local_file plex_title year; do
        case "$status" in
            MATCH)
                printf 'NONE\tMATCH\t%s\t%s\t%s\n' \
                    "$local_file" "$plex_title" "${year:--}"
                ;;
            LOCAL_ONLY)
                if ptk_plex_sync_extension_allowed "$local_file"; then
                    if [[ "$PLEX_SYNC_REQUIRE_YEAR" == "true" && "$year" == "-" ]]; then
                        printf 'REVIEW\tLOCAL_ONLY\t%s\t-\t-\n' "$local_file"
                    else
                        printf 'ADD_TO_PLEX\tLOCAL_ONLY\t%s\t-\t%s\n' \
                            "$local_file" "${year:--}"
                    fi
                else
                    printf 'REVIEW\tUNSUPPORTED_EXTENSION\t%s\t-\t%s\n' \
                        "$local_file" "${year:--}"
                fi
                ;;
            PLEX_ONLY)
                printf 'NONE\tPLEX_ONLY\t-\t%s\t%s\n' \
                    "$plex_title" "${year:--}"
                ;;
        esac
    done <<< "$compare_output"
}
