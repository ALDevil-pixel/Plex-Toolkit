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

ptk_file_size() {
    local file="$1"
    stat -c%s -- "$file" 2>/dev/null || stat -f%z -- "$file" 2>/dev/null
}

ptk_file_sha256() {
    local file="$1"
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum -- "$file" | awk '{print $1}'
    elif command -v shasum >/dev/null 2>&1; then
        shasum -a 256 -- "$file" | awk '{print $1}'
    else
        return 1
    fi
}

ptk_find_duplicates() {
    local rootdir="."
    local minsize=0
    local dry=1
    local deep=0
    local -a exts=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --fix) dry=0 ;;
            --dry-run) dry=1 ;;
            --deep) deep=1 ;;
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

    # Stage 1: collect files by size. Different sizes cannot be exact duplicates.
    while IFS= read -r -d '' file; do
        ptk_match_extension "$file" "${exts[@]}" || continue

        local size
        size="$(ptk_file_size "$file")" || {
            rm -f -- "$tmp"
            echo "[ERROR] Unable to read size: $file" >&2
            return 1
        }

        (( size < minsize )) && continue
        printf '%s\t%s\0' "$size" "$file" >> "$tmp"
    done < <(find "$rootdir" -type f -print0)

    if [[ ! -s "$tmp" ]]; then
        rm -f -- "$tmp"
        echo "Duplicate files found: 0"
        return 0
    fi

    local duplicate_groups=0
    local duplicate_files=0
    local current_size=""
    local -a candidates=()

    flush_size_group() {
        [[ "${#candidates[@]}" -gt 1 ]] || {
            candidates=()
            return 0
        }

        if [[ "$deep" -eq 0 ]]; then
            printf '[CANDIDATE] Same-size files (%s bytes):\n' "$current_size"
            printf '  %s\n' "${candidates[@]}"
            duplicate_groups=$((duplicate_groups + 1))
            duplicate_files=$((duplicate_files + ${#candidates[@]} - 1))
            candidates=()
            return 0
        fi

        local hash_tmp
        hash_tmp="$(mktemp)" || return 1

        local file hash
        for file in "${candidates[@]}"; do
            hash="$(ptk_file_sha256 "$file")" || {
                rm -f -- "$hash_tmp"
                echo "[ERROR] SHA-256 unavailable or failed: $file" >&2
                return 1
            }
            printf '%s\t%s\0' "$hash" "$file" >> "$hash_tmp"
        done

        local group_hash=""
        local -a hash_group=()

        flush_hash_group() {
            [[ "${#hash_group[@]}" -gt 1 ]] || {
                hash_group=()
                return 0
            }

            duplicate_groups=$((duplicate_groups + 1))
            duplicate_files=$((duplicate_files + ${#hash_group[@]} - 1))

            printf '[DUPLICATE] SHA-256 %s\n' "$group_hash"
            local duplicate_file
            for duplicate_file in "${hash_group[@]}"; do
                printf '  %s\n' "$duplicate_file"
            done

            if [[ "$dry" -eq 0 ]]; then
                local keep="${hash_group[0]}"
                local i
                for ((i=1; i<${#hash_group[@]}; i++)); do
                    ptk_remove_duplicate "${hash_group[$i]}" "$dry" || {
                        rm -f -- "$hash_tmp"
                        return 1
                    }
                done
                printf '[KEEP] %s\n' "$keep"
            fi

            hash_group=()
        }

        while IFS=$'\t' read -r -d '' hash file; do
            if [[ "$hash" != "$group_hash" && "${#hash_group[@]}" -gt 0 ]]; then
                flush_hash_group || {
                    rm -f -- "$hash_tmp"
                    return 1
                }
            fi
            group_hash="$hash"
            hash_group+=("$file")
        done < <(sort -z "$hash_tmp")

        flush_hash_group || {
            rm -f -- "$hash_tmp"
            return 1
        }

        rm -f -- "$hash_tmp"
        candidates=()
    }

    while IFS=$'\t' read -r -d '' size file; do
        if [[ "$size" != "$current_size" && "${#candidates[@]}" -gt 0 ]]; then
            flush_size_group || {
                rm -f -- "$tmp"
                return 1
            }
        fi
        current_size="$size"
        candidates+=("$file")
    done < <(sort -z "$tmp")

    flush_size_group || {
        rm -f -- "$tmp"
        return 1
    }

    rm -f -- "$tmp"

    if [[ "$deep" -eq 0 ]]; then
        echo "Use --deep for SHA-256 verification before using --fix."
    fi

    echo "Duplicate groups found: $duplicate_groups"
    echo "Duplicate files found: $duplicate_files"
    return 0
}
