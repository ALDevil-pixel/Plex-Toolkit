#!/usr/bin/env bash
# Détection des extensions non conformes

ptk_find_invalid_extensions() {
    local path="$1"
    [[ -d "$path" ]] || return 1

    local allowed="mkv mp4 ts"

    find "$path" -type f | while read -r file; do
        ext="${file##*.}"
        case " $allowed " in
            *" ${ext,,} "*) ;;
            *) echo "[INVALID-EXT] $file" ;;
        esac
    done
}
