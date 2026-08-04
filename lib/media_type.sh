#!/usr/bin/env bash
# Détection simple du type de média

ptk_detect_media_type() {
    local path="$1"

    case "${path,,}" in
        *anime*|*animation*)
            echo "anime"
            ;;
        *season*|*saison*|*series*|*tv*)
            echo "series"
            ;;
        *)
            echo "movie"
            ;;
    esac
}
