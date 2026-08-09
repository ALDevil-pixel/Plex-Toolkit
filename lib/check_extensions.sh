#!/usr/bin/env bash
# Détection des extensions non conformes

ptk_load_allowed_extensions() {
    local cfg="${1:-config/check.conf}"

    source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
    ptk_load_config "$cfg" || return 1

    echo "${VIDEO_EXTENSIONS:-${PTK_VIDEO_EXTENSIONS}}"
}

ptk_find_invalid_extensions() {
    local path="$1"
    [[ -d "$path" ]] || return 1

    local allowed
    allowed="$(ptk_load_allowed_extensions)" || return 1

    find "$path" -type f -print0 |
    while IFS= read -r -d '' file; do
        local name="${file##*/}"
        local ext=""

        [[ "$name" == *.* ]] && ext="${name##*.}"

        case " $allowed " in
            *" ${ext,,} "*) ;;
            *) echo "[INVALID-EXT] $file" ;;
        esac
    done
}
