#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

required_files=(
  config/inventory.conf
  lib/inventory.sh
  lib/inventory_metadata.sh
  lib/inventory_identity.sh
  lib/inventory_compare.sh
  lib/plex_inventory.sh
  lib/inventory_plex_compare.sh
  commands/inventory-compare
  commands/inventory-plex-compare
  commands/inventory-plex-report
  tests/test-inventory-v2.sh
  tests/test-inventory-identity.sh
  tests/test-inventory-compare.sh
  tests/test-inventory-plex-compare.sh
  tests/test-inventory-plex-report.sh
)

for file in "${required_files[@]}"; do
  test -f "$file"
done

grep -q 'inventory-compare' plex-toolkit
grep -q 'inventory-plex-compare' plex-toolkit
grep -q 'inventory-plex-report' plex-toolkit

grep -q 'INVENTORY_HASH_ENABLED' config/inventory.conf
grep -q 'INVENTORY_FOLLOW_SYMLINKS' config/inventory.conf
grep -q 'ptk_inventory_identity' lib/inventory_identity.sh
grep -q 'ptk_inventory_compare_records' lib/inventory_compare.sh
grep -q 'ptk_plex_inventory_records' lib/plex_inventory.sh
grep -q 'ptk_inventory_plex_compare' lib/inventory_plex_compare.sh
grep -q 'ptk_inventory_plex_build_report' lib/inventory_plex_compare.sh

echo "Sprint 1.15.0 coherence: OK"
