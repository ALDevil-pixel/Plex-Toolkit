#!/usr/bin/env bash
# Media analyzer

PTK_ALLOWED_EXTENSIONS=("mkv" "mp4" "avi" "ts" "m4v")

ptk_media_scan() {
    local dir="$1"
    [[ -d "$dir" ]] || return 1

    local videos=0 empty=0 unknown=0

    while IFS= read -r -d '' f; do
        ext="${f##*.}"
        ok=0
        for a in "${PTK_ALLOWED_EXTENSIONS[@]}"; do
            [[ "${ext,,}" == "$a" ]] && ok=1 && break
        done
        if [[ $ok -eq 1 ]]; then
            videos=$((videos+1))
        else
            unknown=$((unknown+1))
            printf "[WARN] Unsupported extension: %s\n" "$f"
        fi
        [[ ! -s "$f" ]] && empty=$((empty+1))
    done < <(find "$dir" -type f -print0)

    echo "Videos : $videos"
    echo "Unknown: $unknown"
    echo "Empty  : $empty"
}
