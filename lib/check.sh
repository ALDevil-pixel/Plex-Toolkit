#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/check_zero_size.sh"
source "$(dirname "${BASH_SOURCE[0]}")/check_extensions.sh"
source "$(dirname "${BASH_SOURCE[0]}")/check_report.sh"
source "$(dirname "${BASH_SOURCE[0]}")/library_loader.sh"
ptk_check_library(){ local p="$1"; find "$p" -type f|while read -r f;do echo "[CHECK] $f";done; ptk_find_zero_size_files "$p"; ptk_find_invalid_extensions "$p"; ptk_check_report "$p"; }
ptk_check(){ if [[ $# -eq 0 ]]; then while IFS='|' read -r n p;do echo "== $n =="; ptk_check_library "$p"; done < <(ptk_load_libraries); else ptk_check_library "$1"; fi; }
