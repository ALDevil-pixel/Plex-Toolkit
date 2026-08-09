#!/usr/bin/env bash
# Détection des extensions non conformes

ptk_load_allowed_extensions() {
    local cfg="${1:-config/check.conf}"
    local VIDEO_EXTENSIONS="mkv mp4 ts"

    if [[ -f "$cfg" ]]; then
        # shellcheck disable=SC1090
        source "$cfg"
    fi

    echo "$VIDEO_EXTENSIONS"
}

ptk_find_invalid_extensions() {
    local path="$1"
    [[ -d "$path" ]] || return 1

    local allowed
    allowed="$(ptk_load_allowed_extensions)"

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
