#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/media_type.sh"

ptk_build_name() {
    local file="$1"
    local type="$2"

    local name="${file##*/}"
    local ext="${name##*.}"
    local base="${name%.*}"

    # Nettoyage simple
    base=$(echo "$base" | sed -E 's/[._]+/ /g')
    base=$(echo "$base" | sed -E 's/ +(1080p|720p|2160p|480p).*//I')
    base=$(echo "$base" | sed -E 's/ +x26[45].*//I')

    if [[ "$type" == "movie" ]]; then
        if [[ "$base" =~ (19|20)[0-9]{2} ]]; then
            year="${BASH_REMATCH[0]}"
            title=$(echo "$base" | sed -E "s/$year.*//")
            title=$(echo "$title" | sed -E 's/[[:space:]]+$//')
            echo "${title} (${year}).${ext}"
        else
            echo "${base}.${ext}"
        fi
    else
        echo "${base}.${ext}"
    fi
}

ptk_rename_library() {
    local path="$1"
    [[ -d "$path" ]] || return 1
    local type
    type=$(ptk_detect_media_type "$path")

    find "$path" -type f | while read -r file; do
        new=$(ptk_build_name "$file" "$type")
        echo "[DRY-RUN] $(basename "$file") -> $new"
    done
}
