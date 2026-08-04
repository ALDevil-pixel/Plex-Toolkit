#!/usr/bin/env bash
# Détection des sous-titres orphelins

ptk_find_orphan_subtitles() {
    local path="$1"
    [[ -d "$path" ]] || return 1

    find "$path" -type f \( -iname "*.srt" -o -iname "*.ass" -o -iname "*.ssa" -o -iname "*.sub" \) |
    while read -r sub; do
        base="${sub%.*}"
        found=0
        for ext in mkv mp4 avi ts; do
            [[ -f "${base}.${ext}" ]] && found=1 && break
        done
        [[ $found -eq 0 ]] && echo "[ORPHAN-SUB] $sub"
    done
}
