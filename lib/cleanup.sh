#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/cleanup_empty_dirs.sh"
source "$(dirname "${BASH_SOURCE[0]}")/cleanup_junk_files.sh"
source "$(dirname "${BASH_SOURCE[0]}")/cleanup_orphan_subtitles.sh"
source "$(dirname "${BASH_SOURCE[0]}")/library_loader.sh"
ptk_cleanup_library(){ local p="$1"; find "$p" -type f|while read -r f;do echo "[SCAN] $f";done; ptk_find_empty_dirs "$p"; ptk_find_junk_files "$p"; ptk_find_orphan_subtitles "$p"; }
ptk_cleanup(){ if [[ $# -eq 0 ]]; then while IFS='|' read -r n p;do echo "== $n =="; ptk_cleanup_library "$p"; done < <(ptk_load_libraries); else ptk_cleanup_library "$1"; fi; }
