#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

source "$ROOT/lib/inventory_metadata.sh"
source "$ROOT/lib/inventory_identity.sh"
source "$ROOT/lib/inventory_compare.sh"

cat > "$TMP/old.txt" <<'EOF'
Film A.mkv|mkv|100|2026-08-01 10:00:00|aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa|/media/Film A.mkv
Film B.mkv|mkv|200|2026-08-01 10:00:00|bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb|/media/Film B.mkv
Old.mkv|mkv|300|2026-08-01 10:00:00|cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc|/media/Old.mkv
Moved.mkv|mkv|400|2026-08-01 10:00:00|dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd|/media/Moved.mkv
EOF

cat > "$TMP/new.txt" <<'EOF'
Film A.mkv|mkv|100|2026-08-01 10:00:00|aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa|/media/Film A.mkv
Film B.mkv|mkv|250|2026-08-02 10:00:00|dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd|/media/Film B.mkv
New.mkv|mkv|400|2026-08-09 10:00:00|eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee|/media/New.mkv
Moved.mkv|mkv|400|2026-08-09 10:00:00|dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd|/media/New/Moved.mkv
EOF

output="$(ptk_inventory_compare_records "$TMP/old.txt" "$TMP/new.txt")"

grep '^UNCHANGED|.*Film A' <<<"$output" >/dev/null
grep '^CHANGED|.*Film B' <<<"$output" >/dev/null
grep '^REMOVED|.*Old.mkv' <<<"$output" >/dev/null
grep '^ADDED|.*New.mkv' <<<"$output" >/dev/null
grep '^CHANGED|.*Moved.mkv' <<<"$output" >/dev/null

if grep '^REMOVED|' <<<"$output" | grep -q 'Moved.mkv'; then exit 1; fi
if grep '^ADDED|' <<<"$output" | grep -q 'Moved.mkv'; then exit 1; fi
if grep '^REMOVED|' <<<"$output" | grep -q 'Film B.mkv'; then exit 1; fi
if grep '^ADDED|' <<<"$output" | grep -q 'Film B.mkv'; then exit 1; fi

echo "Inventory comparison: OK"
