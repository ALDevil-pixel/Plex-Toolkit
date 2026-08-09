#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/media" "$TMP/reports"
printf 'hello\n' > "$TMP/media/Film A.mkv"
printf 'hidden\n' > "$TMP/media/.hidden.mkv"
ln -s "$TMP/media/Film A.mkv" "$TMP/media/link.mkv"

cat > "$TMP/inventory.conf" <<EOF
REPORT_DIR="$TMP/reports"
INVENTORY_CSV_REPORT="inventory.csv"
INVENTORY_JSON_REPORT="inventory.json"
INVENTORY_LOG="inventory.log"
INVENTORY_FOLLOW_SYMLINKS=false
INVENTORY_INCLUDE_HIDDEN=false
INVENTORY_HASH_ENABLED=true
INVENTORY_HASH_ALGORITHM="sha256"
EOF

# Use the existing command with the test configuration.
output="$("$ROOT/plex-toolkit" inventory --config "$TMP/inventory.conf" "$TMP/media")"

grep 'Files :' <<<"$output" >/dev/null
grep 'Total size' <<<"$output" >/dev/null

test -f "$TMP/reports/inventory.csv"
test -f "$TMP/reports/inventory.json"

# Hidden file excluded; symlink is not followed.
if grep -q '\.hidden\.mkv' "$TMP/reports/inventory.csv"; then
    exit 1
fi
if grep -q 'link\.mkv' "$TMP/reports/inventory.csv"; then
    exit 1
fi

# Hash is present for the real media file.
grep 'Film A.mkv' "$TMP/reports/inventory.csv" >/dev/null
grep -E '[0-9a-f]{64}' "$TMP/reports/inventory.csv" >/dev/null

echo OK
