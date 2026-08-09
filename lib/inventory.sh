#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/inventory_metadata.sh"
source "$(dirname "${BASH_SOURCE[0]}")/inventory_csv.sh"
source "$(dirname "${BASH_SOURCE[0]}")/inventory_json.sh"
source "$(dirname "${BASH_SOURCE[0]}")/inventory_stats.sh"
source "$(dirname "${BASH_SOURCE[0]}")/library_loader.sh"
ptk_inventory_library(){ local p="$1"; tmp=$(mktemp); find "$p" -type f|while read -r f;do ptk_inventory_metadata "$f">>"$tmp";done; ptk_inventory_export_csv "$tmp"; ptk_inventory_export_json "$tmp"; ptk_inventory_stats "$tmp"; rm -f "$tmp"; }
ptk_inventory(){ if [[ $# -eq 0 ]]; then while IFS='|' read -r n p;do echo "== $n =="; ptk_inventory_library "$p"; done < <(ptk_load_libraries); else ptk_inventory_library "$1"; fi; }
