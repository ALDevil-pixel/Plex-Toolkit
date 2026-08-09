#!/usr/bin/env bash
# Scanner Films - lecture seule.
#
# Ce module analyse les fichiers vidéo et ne modifie jamais le contenu
# du répertoire.

ptk_movie_extension_allowed() {
    local ext="${1,,}"

    for item in $MOVIES_VIDEO_EXTENSIONS; do
        [[ "${item,,}" == "$ext" ]] && return 0
    done

    return 1
}

ptk_movie_scan() {
    local target="${1:-${MOVIES_ROOT:-}}"

    [[ -n "$target" ]] || {
        echo "[ERROR] Movies directory is required." >&2
        return 2
    }

    [[ -d "$target" ]] || {
        echo "[ERROR] Movies directory not found: $target" >&2
        return 1
    }

    local total=0
    local videos=0
    local unsupported=0
    local below_min_size=0

    echo "Movies Scan"
    echo "Directory: $target"
    echo

    while IFS= read -r -d '' file; do
        local filename="${file##*/}"

        if [[ "$MOVIES_INCLUDE_HIDDEN" != true && "$filename" == .* ]]; then
            continue
        fi

        total=$((total + 1))

        local ext=""
        [[ "$filename" == *.* ]] && ext="${filename##*.}"

        if ! ptk_movie_extension_allowed "$ext"; then
            unsupported=$((unsupported + 1))
            printf '[WARN] Unsupported: %s\n' "$file"
            continue
        fi

        local size
        size="$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null)" || {
            printf '[ERROR] Unable to read size: %s\n' "$file" >&2
            return 1
        }

        if (( size < MOVIES_MIN_SIZE )); then
            below_min_size=$((below_min_size + 1))
            printf '[WARN] Below minimum size: %s\n' "$file"
            continue
        fi

        videos=$((videos + 1))
        printf '[ OK ] %s | %s bytes\n' "$file" "$size"
    done < <(find "$target" -type f -print0 | sort -z)

    echo
    echo "Files           : $total"
    echo "Videos          : $videos"
    echo "Unsupported     : $unsupported"
    echo "Below min size  : $below_min_size"

    return 0
}
