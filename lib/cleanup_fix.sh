#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/cleanup_logger.sh"

ptk_cleanup_remove() {
    local target="$1"
    local dry="${2:-1}"

    [[ -e "$target" ]] || return 0

    if [[ "$dry" -eq 1 ]]; then
        echo "[DRY-RUN] Remove: $target"
        return 0
    fi

    if rm -rf -- "$target"; then
        ptk_cleanup_log "REMOVED" "$target"
        echo "[REMOVED] $target"
        return 0
    fi

    ptk_cleanup_log "ERROR" "$target"
    echo "[ERROR] Unable to remove: $target" >&2
    return 1
}

ptk_cleanup_fix_empty_dirs() {
    local path="$1"
    local dry="${2:-1}"

    find "$path" -type d -empty -print0 |
    while IFS= read -r -d '' dir; do
        ptk_cleanup_remove "$dir" "$dry" || return 1
    done
}

ptk_cleanup_fix_junk_files() {
    local path="$1"
    local dry="${2:-1}"

    find "$path" -type f \( \
        -name "Thumbs.db" -o \
        -name ".DS_Store" -o \
        -name "desktop.ini" -o \
        -name "*.tmp" -o \
        -name "*.bak" -o \
        -name "*.old" \
    \) -print0 |
    while IFS= read -r -d '' file; do
        ptk_cleanup_remove "$file" "$dry" || return 1
    done
}

ptk_cleanup_fix_orphan_subtitles() {
    local path="$1"
    local dry="${2:-1}"

    find "$path" -type f \( \
        -iname "*.srt" -o \
        -iname "*.ass" -o \
        -iname "*.ssa" -o \
        -iname "*.sub" \
    \) -print0 |
    while IFS= read -r -d '' sub; do
        local base="${sub%.*}"
        local found=0

        for ext in mkv mp4 avi ts; do
            [[ -f "${base}.${ext}" ]] && found=1 && break
        done

        if [[ "$found" -eq 0 ]]; then
            ptk_cleanup_remove "$sub" "$dry" || return 1
        fi
    done
}
