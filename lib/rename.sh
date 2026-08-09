#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/media_type.sh"
source "$(dirname "${BASH_SOURCE[0]}")/rename_logger.sh"
source "$(dirname "${BASH_SOURCE[0]}")/rename_conflicts.sh"

ptk_build_name() {
    local f="$1"
    local n="${f##*/}"
    local e="${n##*.}"
    local b="${n%.*}"
    local y t

    b=$(echo "$b" | sed -E 's/[._]+/ /g;s/ +(480p|720p|1080p|2160p).*//I;s/ +x26[45].*//I')

    if [[ "$b" =~ (19|20)[0-9]{2} ]]; then
        y="${BASH_REMATCH[0]}"
        t=$(echo "$b" | sed -E "s/$y.*//;s/[[:space:]]+$//")
        echo "$t ($y).$e"
    else
        echo "$b.$e"
    fi
}

ptk_apply_rename() {
    local src="$1"
    local dst="$2"
    local dry="${3:-1}"

    [[ -f "$src" ]] || return 1

    if [[ "$src" == "$dst" ]]; then
        return 0
    fi

    if ptk_check_conflict "$dst"; then
        ptk_resolve_conflict "$dst" skip
        return 1
    fi

    if [[ "$dry" -eq 1 ]]; then
        echo "[DRY-RUN] $(basename "$src") -> $(basename "$dst")"
        return 0
    fi

    if mv -- "$src" "$dst"; then
        ptk_log_rename "$src" "$dst"
        echo "[RENAMED] $(basename "$src") -> $(basename "$dst")"
        return 0
    fi

    echo "[ERROR] Unable to rename: $src" >&2
    return 1
}

ptk_rename_library() {
    local path="$1"
    local dry="${2:-1}"

    [[ -d "$path" ]] || return 1

    find "$path" -type f -print0 |
    while IFS= read -r -d '' file; do
        local name destination
        name="$(ptk_build_name "$file")"
        destination="$(dirname "$file")/$name"

        ptk_apply_rename "$file" "$destination" "$dry" || {
            [[ "$dry" -eq 1 ]] || return 1
        }
    done
}

ptk_rename() {
    local dry=1
    local target="."

    if [[ "$1" == "--fix" ]]; then
        dry=0
        shift
    elif [[ "$1" == "--dry-run" ]]; then
        dry=1
        shift
    fi

    [[ -n "$1" ]] && target="$1"

    ptk_rename_library "$target" "$dry"
}
