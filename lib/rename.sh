#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/media_type.sh"
source "$(dirname "${BASH_SOURCE[0]}")/rename_logger.sh"
source "$(dirname "${BASH_SOURCE[0]}")/rename_conflicts.sh"

ptk_build_name(){ local f="$1"; local n="${f##*/}"; local e="${n##*.}"; local b="${n%.*}"; b=$(echo "$b"|sed -E 's/[._]+/ /g;s/ +(480p|720p|1080p|2160p).*//I;s/ +x26[45].*//I'); if [[ "$b" =~ (19|20)[0-9]{2} ]]; then y=${BASH_REMATCH[0]}; t=$(echo "$b"|sed -E "s/$y.*//;s/[[:space:]]+$//"); echo "$t ($y).$e"; else echo "$b.$e"; fi; }
ptk_apply_rename(){ local s="$1" d="$2" dry="${3:-1}"; if ptk_check_conflict "$d"; then return 1; fi; if [[ $dry -eq 1 ]]; then echo "[DRY-RUN] $(basename "$s") -> $(basename "$d")"; else mv "$s" "$d" && ptk_log_rename "$s" "$d"; fi; }
ptk_rename_library(){ local p="$1"; local dry="${2:-1}"; find "$p" -type f|while read -r f; do n=$(ptk_build_name "$f"); ptk_apply_rename "$f" "$(dirname "$f")/$n" "$dry"; done; }
ptk_rename(){ local dry=1 target="."; [[ "$1" == "--fix" ]] && dry=0 && shift; [[ -n "$1" ]]&&target="$1"; ptk_rename_library "$target" "$dry"; }
