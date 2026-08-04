#!/usr/bin/env bash
ptk_match_extension(){ local f="$1"; shift; [[ $# -eq 0 ]] && return 0; ext="${f##*.}"; for e in "$@"; do [[ "${ext,,}" == "${e,,}" ]] && return 0; done; return 1; }
ptk_find_duplicates(){
deep=0; rootdir="."; minsize=0; exts=()
while [[ $# -gt 0 ]]; do
 case "$1" in
  --deep) deep=1;;
  --min-size) minsize="$2"; shift;;
  --extensions) IFS=',' read -ra exts <<< "$2"; shift;;
  *) rootdir="$1";;
 esac; shift; done
find "$rootdir" -type f | while read -r f; do
 ptk_match_extension "$f" "${exts[@]}" || continue
 size=$(stat -c%s "$f" 2>/dev/null || stat -f%z "$f")
 [[ "$size" -lt "$minsize" ]] && continue
 echo "$f"
done
echo "Use --deep for SHA-256 verification."
}
