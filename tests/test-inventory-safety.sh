#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/media" "$TMP/reports"
printf 'safe\n' > "$TMP/media/Safe.mkv"
ln -s "$TMP/media/Safe.mkv" "$TMP/media/Link.mkv"

cat > "$TMP/inventory.conf" <<EOF
REPORT_DIR="$TMP/reports"
INVENTORY_CSV_REPORT="inventory.csv"
INVENTORY_JSON_REPORT="inventory.json"
INVENTORY_LOG="inventory.log"
INVENTORY_FOLLOW_SYMLINKS=false
INVENTORY_INCLUDE_HIDDEN=true
INVENTORY_HASH_ENABLED=false
INVENTORY_HASH_ALGORITHM="sha256"
EOF

# Inventory must not follow links by default.
output="$("$ROOT/plex-toolkit" inventory \
  --config "$TMP/inventory.conf" "$TMP/media")"

grep 'Files :' <<<"$output" >/dev/null
if grep -q 'Link.mkv' "$TMP/reports/inventory.csv"; then
  exit 1
fi

# Comparison commands must remain read-only and reject --fix.
printf 'Safe.mkv|mkv|5|2026-08-09 10:00:00||/media/Safe.mkv\n' > "$TMP/a.txt"
cp "$TMP/a.txt" "$TMP/b.txt"

if "$ROOT/plex-toolkit" inventory-compare \
    --config "$TMP/inventory.conf" --fix "$TMP/a.txt" "$TMP/b.txt" >/dev/null 2>&1; then
  exit 1
fi

# The source inventory remains unchanged.
grep 'Safe.mkv' "$TMP/a.txt" >/dev/null

echo "Inventory safety: OK"
