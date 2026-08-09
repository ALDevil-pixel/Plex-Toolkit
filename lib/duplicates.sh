#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/duplicates_fix.sh"
source "$(dirname "${BASH_SOURCE[0]}")/logger.sh"

ptk_match_extension() {
    local f="$1"
    shift

    [[ $# -eq 0 ]] && return 0

    local ext="${f##*.}"
    local e
    for e in "$@"; do
        [[ "${ext,,}" == "${e,,}" ]] && return 0
    done

    return 1
}

ptk_find_duplicates() {
    local rootdir="."
    local minsize=0
    local dry=1
    local deep=0
    local -a exts=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --fix)
                dry=0
                ;;
            --dry-run)
                dry=1
                ;;
            --deep)
                deep=1
                ;;
            --min-size)
                [[ $# -ge 2 ]] || return 2
                minsize="$2"
                shift
                ;;
            --extensions)
                [[ $# -ge 2 ]] || return 2
                IFS=',' read -r -a exts <<< "$2"
                shift
                ;;
            --)
                shift
                [[ $# -gt 0 ]] && rootdir="$1"
                ;;
            -*)
                echo "[ERROR] Unknown option: $1" >&2
                return 2
                ;;
            *)
                rootdir="$1"
                ;;
        esac
        shift
    done

    [[ "$minsize" =~ ^[0-9]+$ ]] || {
        echo "[ERROR] Invalid minimum size: $minsize" >&2
        return 2
    }

    [[ -d "$rootdir" ]] || {
        echo "[ERROR] Directory not found: $rootdir" >&2
        return 1
    }

    local tmp
    tmp="$(mktemp)" || return 1

    while IFS= read -r -d '' file; do
        ptk_match_extension "$file" "${exts[@]}" || continue

        local size
        size="$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file")"
        [[ "$size" -lt "$minsize" ]] && continue

        if [[ "$deep" -eq 1 ]]; then
            local hash
            hash="$(sha256sum "$file" 2>/dev/null | awk '{print $1}')"
            [[ -n "$hash" ]] || continue
            printf '%s|%s|%s\n' "$hash" "$size" "$file" >> "$tmp"
        else
            printf '%s|%s\n' "$size" "$file" >> "$tmp"
        fi
    done < <(find "$rootdir" -type f -print0)

    local duplicates=0
    declare -A first_seen

    while IFS='|' read -r key size file; do
        [[ -n "$file" ]] || continue

        if [[ -n "${first_seen[$key]:-}" ]]; then
            if [[ "$deep" -eq 1 ]]; then
                echo "[DUPLICATE] ${first_seen[$key]}"
                echo "[DUPLICATE] $file"
            else
                echo "[CANDIDATE] $file"
            fi

            duplicates=$((duplicates + 1))

            if [[ "$dry" -eq 0 && "$deep" -eq 1 ]]; then
                ptk_remove_duplicate "$file" "$dry" || {
                    rm -f "$tmp"
                    return 1
                }
            fi
        else
            first_seen["$key"]="$file"
        fi
    done < <(sort "$tmp")

    rm -f "$tmp"

    if [[ "$deep" -eq 0 ]]; then
        echo "Use --deep for SHA-256 verification before using --fix."
        return 0
    fi

    echo "Duplicate files found: $duplicates"
    return 0
}
