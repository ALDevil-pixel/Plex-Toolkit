#!/usr/bin/env bash
# Anime rename planning and execution.
#
# Planning is read-only. Execution is only allowed when explicitly requested
# by the caller (--fix).

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

    # Characters which are unsafe or inconvenient in a filename are replaced.
    title="${title//:/ -}"
    title="${title//\// -}"
    title="${title//\\/ -}"

    printf '%s\n' "$title" |
        sed -E 's/[[:space:]]+/ /g; s/^ +//; s/ +$//'
}

ptk_anime_extract_title() {
    local filename="$1"
    local base="${filename%.*}"

    base="$(printf '%s\n' "$base" | sed -E \
        's/[[:space:._-]*[Ss][0-9]{1,3}[Ee][0-9]{1,4}.*$//;
         s/[[:space:._-]*[0-9]{1,3}[xX][0-9]{1,4}.*$//')"

    ptk_anime_sanitize_title "$base"
}

ptk_anime_validate_episode_numbers() {
    local season="$1"
    local episode="$2"

    [[ "$season" =~ ^[0-9]+$ && "$episode" =~ ^[0-9]+$ ]] || return 1
    (( 10#$season >= 0 && 10#$episode >= 0 )) || return 1
}

ptk_anime_build_episode_name() {
    local file="$1"
    local season="$2"
    local episode="$3"

    ptk_anime_validate_episode_numbers "$season" "$episode" || return 1

    local filename="${file##*/}"
    local extension=""
    [[ "$filename" == *.* ]] && extension=".${filename##*.}"

    local title
    title="$(ptk_anime_extract_title "$filename")"
    [[ -n "$title" ]] || title="Unknown"

    local name
    name="$(ptk_anime_format_pattern \
        "$ANIME_EPISODE_PATTERN" "$title" "$season" "$episode")"

    [[ -n "$name" ]] || return 1

    printf '%s%s\n' "$name" "$extension"
}

ptk_anime_collect_renames() {
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

        ptk_anime_validate_episode_numbers "$season" "$episode" || continue

        local new_name new_path
        new_name="$(ptk_anime_build_episode_name "$file" "$season" "$episode")" || continue
        new_path="$(dirname "$file")/$new_name"

        printf '%s|%s\n' "$file" "$new_path"
    done < <(find "$target" -type f -print0 | sort -z)
}

ptk_anime_rename_proposals() {
    local target="${1:-${ANIME_ROOT:-}}"
    local -A planned_targets=()
    local collision=0

    while IFS='|' read -r file new_path; do
        [[ -z "$file" ]] && continue

        if [[ "$file" == "$new_path" ]]; then
            printf '[ OK ] Already normalized: %s\n' "$file"
            continue
        fi

        if [[ -n "${planned_targets[$new_path]:-}" &&
              "${planned_targets[$new_path]}" != "$file" ]]; then
            printf '[WARN] Duplicate target: %s and %s -> %s\n' \
                "${planned_targets[$new_path]}" "$file" "$new_path"
            collision=1
            continue
        fi

        planned_targets["$new_path"]="$file"

        if [[ -e "$new_path" ]]; then
            printf '[WARN] Target exists: %s -> %s\n' "$file" "$new_path"
        else
            printf '[RENAME] %s -> %s\n' "$file" "$new_path"
        fi
    done < <(ptk_anime_collect_renames "$target")

    return "$collision"
}

ptk_anime_apply_renames() {
    local target="${1:-${ANIME_ROOT:-}}"
    local applied=0
    local skipped=0
    local conflicts=0
    local errors=0
    local -A planned_targets=()

    while IFS='|' read -r file new_path; do
        [[ -z "$file" ]] && continue

        if [[ "$file" == "$new_path" ]]; then
            printf '[ OK ] Already normalized: %s\n' "$file"
            skipped=$((skipped + 1))
            continue
        fi

        if [[ -n "${planned_targets[$new_path]:-}" &&
              "${planned_targets[$new_path]}" != "$file" ]]; then
            printf '[WARN] Duplicate target, skipped: %s -> %s\n' "$file" "$new_path"
            conflicts=$((conflicts + 1))
            continue
        fi
        planned_targets["$new_path"]="$file"

        if [[ -e "$new_path" ]]; then
            printf '[WARN] Target exists, skipped: %s -> %s\n' "$file" "$new_path"
            conflicts=$((conflicts + 1))
            continue
        fi

        if mv -- "$file" "$new_path"; then
            printf '[DONE] %s -> %s\n' "$file" "$new_path"
            applied=$((applied + 1))
        else
            printf '[ERROR] Unable to rename: %s -> %s\n' "$file" "$new_path" >&2
            errors=$((errors + 1))
        fi
    done < <(ptk_anime_collect_renames "$target")

    echo
    echo "Renamed   : $applied"
    echo "Skipped   : $skipped"
    echo "Conflicts : $conflicts"
    echo "Errors    : $errors"

    [[ "$errors" -eq 0 ]] || return 1
    return 0
}
