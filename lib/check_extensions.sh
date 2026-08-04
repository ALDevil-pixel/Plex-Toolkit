#!/usr/bin/env bash
# Détection des extensions non conformes

ptk_load_allowed_extensions() {
    local cfg="${1:-config/check.conf}"
    VIDEO_EXTENSIONS="mkv mp4 ts"
    [[ -f "$cfg" ]] && source "$cfg"
    echo "$VIDEO_EXTENSIONS"
}

ptk_find_invalid_extensions() {
    local path="$1"
    [[ -d "$path" ]] || return 1

    local allowed
    allowed="$(ptk_load_allowed_extensions)"

    find "$path" -type f | while read -r file; do
        ext="${file##*.}"
        case " $allowed " in
            *" ${ext,,} "*) ;;
            *) echo "[INVALID-EXT] $file" ;;
        esac
    done
}
