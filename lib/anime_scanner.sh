#!/usr/bin/env bash
# Anime media scanner
#
# Read-only scanner used to analyse an Anime library.
# It does not rename, move or delete files.

ptk_anime_extension_allowed() {
    local ext="${1,,}"
    local allowed="${ANIME_VIDEO_EXTENSIONS:-}"

    for item in $allowed; do
        [[ "${item,,}" == "$ext" ]] && return 0
    done

    return 1
}

ptk_anime_extract_episode() {
    local filename="$1"
    local season=""
    local episode=""

    # S01E02 / s01e02
    if [[ "$filename" =~ [Ss]([0-9]{1,3})[Ee]([0-9]{1,4}) ]]; then
        season="${BASH_REMATCH[1]}"
        episode="${BASH_REMATCH[2]}"
    # 1x02
    elif [[ "$filename" =~ ([0-9]{1,3})[xX]([0-9]{1,4}) ]]; then
        season="${BASH_REMATCH[1]}"
        episode="${BASH_REMATCH[2]}"
    fi

    printf '%s|%s\n' "$season" "$episode"
}

ptk_anime_scan() {
    local target="${1:-${ANIME_ROOT:-}}"

    if [[ -z "$target" ]]; then
        echo "[ERROR] Anime directory is required." >&2
        return 2
    fi

    if [[ ! -d "$target" ]]; then
        echo "[ERROR] Anime directory not found: $target" >&2
        return 1
    fi

    local total=0
    local videos=0
    local unsupported=0
    local missing_episode=0

    echo "Anime Scan"
    echo "Directory: $target"
    echo

    while IFS= read -r -d '' file; do
        total=$((total + 1))

        local filename="${file##*/}"
        local ext=""
        [[ "$filename" == *.* ]] && ext="${filename##*.}"

        if ! ptk_anime_extension_allowed "$ext"; then
            unsupported=$((unsupported + 1))
            printf '[WARN] Unsupported: %s\n' "$file"
            continue
        fi

        videos=$((videos + 1))

        local episode_data season episode
        episode_data="$(ptk_anime_extract_episode "$filename")"
        IFS='|' read -r season episode <<< "$episode_data"

        if [[ "${ANIME_REQUIRE_SEASON:-true}" == true && -z "$season" ]]; then
            missing_episode=$((missing_episode + 1))
            printf '[WARN] No season/episode detected: %s\n' "$file"
            continue
        fi

        printf '[ OK ] S%02sE%02s : %s\n' "${season:-??}" "${episode:-??}" "$file"
    done < <(find "$target" -type f -print0 | sort -z)

    echo
    echo "Files       : $total"
    echo "Videos      : $videos"
    echo "Unsupported : $unsupported"
    echo "Undetected  : $missing_episode"

    return 0
}
