#!/usr/bin/env bash
# Anime rename proposal generator.
#
# This module NEVER renames, moves or deletes files.
# It only produces old -> new proposals.

ptk_anime_format_pattern() {
    local pattern="$1"
    local title="$2"
    local season="$3"
    local episode="$4"

    pattern="${pattern//\{title\}/$title}"
    pattern="${pattern//\{season:02d\}/$(printf '%02d' "$season")}"
    pattern="${pattern//\{season\}/$season}"
    pattern="${pattern//\{episode:02d\}/$(printf '%02d' "$episode")}"
    pattern="${pattern//\{episode\}/$episode}"

    printf '%s\n' "$pattern"
}

ptk_anime_sanitize_title() {
    local title="$1"
    title="${title//_/ }"
    title="${title//./ }"
    title="${title//-/ }"
    printf '%s\n' "$title" | sed -E 's/[[:space:]]+/ /g; s/^ +//; s/ +$//'
}

ptk_anime_extract_title() {
    local filename="$1"
    local base="${filename%.*}"

    base="$(printf '%s\n' "$base" | sed -E \
        's/[[:space:._-]*[Ss][0-9]{1,3}[Ee][0-9]{1,4}.*$//;
         s/[[:space:._-]*[0-9]{1,3}[xX][0-9]{1,4}.*$//')"

    ptk_anime_sanitize_title "$base"
}

ptk_anime_build_episode_name() {
    local file="$1"
    local season="$2"
    local episode="$3"

    local filename="${file##*/}"
    local extension=""
    [[ "$filename" == *.* ]] && extension=".${filename##*.}"

    local title
    title="$(ptk_anime_extract_title "$filename")"

    [[ -n "$title" ]] || title="Unknown"

    local name
    name="$(ptk_anime_format_pattern \
        "$ANIME_EPISODE_PATTERN" "$title" "$season" "$episode")"

    printf '%s%s\n' "$name" "$extension"
}

ptk_anime_rename_proposals() {
    local target="${1:-${ANIME_ROOT:-}}"

    [[ -n "$target" ]] || {
        echo "[ERROR] Anime directory is required." >&2
        return 2
    }

    [[ -d "$target" ]] || {
        echo "[ERROR] Anime directory not found: $target" >&2
        return 1
    }

    while IFS= read -r -d '' file; do
        local filename="${file##*/}"
        local ext=""
        [[ "$filename" == *.* ]] && ext="${filename##*.}"

        ptk_anime_extension_allowed "$ext" || continue

        local episode_data season episode
        episode_data="$(ptk_anime_extract_episode "$filename")"
        IFS='|' read -r season episode <<< "$episode_data"

        if [[ -z "$season" || -z "$episode" ]]; then
            printf '[SKIP] No episode detected: %s\n' "$file"
            continue
        fi

        local new_name new_path
        new_name="$(ptk_anime_build_episode_name "$file" "$season" "$episode")"
        new_path="$(dirname "$file")/$new_name"

        if [[ "$file" == "$new_path" ]]; then
            printf '[ OK ] Already normalized: %s\n' "$file"
        elif [[ -e "$new_path" ]]; then
            printf '[WARN] Target exists: %s -> %s\n' "$file" "$new_path"
        else
            printf '[RENAME] %s -> %s\n' "$file" "$new_path"
        fi
    done < <(find "$target" -type f -print0 | sort -z)

    return 0
}
