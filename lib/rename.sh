#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/media_type.sh"

ptk_apply_rename() {
    local src="$1"
    local dst="$2"
    local dry="$3"

    if [[ "$dry" -eq 1 ]]; then
        echo "[DRY-RUN] $(basename "$src") -> $(basename "$dst")"
    else
        if [[ -e "$dst" ]]; then
            echo "[WARN] Target already exists: $dst"
            return 2
        fi
        mv "$src" "$dst"
        echo "[OK] Renamed: $(basename "$dst")"
    fi
}

ptk_build_name() {
    local f="$1"
    local name="${f##*/}"
    local ext="${name##*.}"
    local base="${name%.*}"
    base=$(echo "$base"|sed -E 's/[._]+/ /g;s/ +(1080p|720p|2160p|480p).*//I;s/ +x26[45].*//I')
    if [[ "$base" =~ (19|20)[0-9]{2} ]]; then
      y="${BASH_REMATCH[0]}"
      t=$(echo "$base"|sed -E "s/$y.*//;s/[[:space:]]+$//")
      echo "${t} (${y}).${ext}"
    else
      echo "${base}.${ext}"
    fi
}

ptk_rename() {
    local dry=1 path="."
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --fix) dry=0;;
        *) path="$1";;
      esac
      shift
    done
    find "$path" -type f | while read -r f; do
      new=$(ptk_build_name "$f")
      ptk_apply_rename "$f" "$(dirname "$f")/$new" "$dry"
    done
}
