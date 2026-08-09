#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

if ! command -v jq >/dev/null 2>&1; then
    echo "SKIP: jq not installed"
    exit 0
fi

cat > "$TMP/inventory.txt" <<'EOF'
Film A (2020).mkv|mkv|100|2026-08-09 10:00:00||/media/Film A (2020).mkv
Local Only (2022).mkv|mkv|200|2026-08-09 10:00:00||/media/Local Only (2022).mkv
EOF

mkdir -p "$TMP/bin"

cat > "$TMP/bin/curl" <<'EOF'
#!/usr/bin/env bash
case "$*" in
  */library/sections*)
    cat <<'JSON'
{"MediaContainer":{"Directory":[
{"key":"1","type":"movie","title":"Films"}
]}}
JSON
    ;;
  */library/sections/1/all*)
    cat <<'JSON'
{"MediaContainer":{"size":1,"Metadata":[
{"ratingKey":"101","type":"movie","title":"Film A","year":2020,"updatedAt":1700000000}
]}}
JSON
    ;;
  *)
    exit 1
    ;;
esac
EOF
chmod +x "$TMP/bin/curl"

cat > "$TMP/plex.conf" <<'EOF'
PLEX_URL="http://plex.test:32400"
PLEX_TOKEN="test-token"
PLEX_TIMEOUT=5
PLEX_VERIFY_TLS=true
PLEX_RETRIES=0
EOF

output="$("$ROOT/plex-toolkit" inventory-plex-report \
    --config "$TMP/plex.conf" \
    "$TMP/inventory.txt" 1 "$TMP/report.txt")"

test -f "$TMP/report.txt"
grep '^Status|' "$TMP/report.txt" >/dev/null
grep '^MATCH|' "$TMP/report.txt" >/dev/null
grep '^LOCAL_ONLY|' "$TMP/report.txt" >/dev/null
grep 'Film A' "$TMP/report.txt" >/dev/null
grep 'Local Only' "$TMP/report.txt" >/dev/null

# The command is read-only and must reject --fix.
if "$ROOT/plex-toolkit" inventory-plex-report \
    --config "$TMP/plex.conf" --fix \
    "$TMP/inventory.txt" 1 "$TMP/report2.txt" >/dev/null 2>&1; then
    exit 1
fi

if grep -q 'test-token' "$TMP/report.txt"; then
    exit 1
fi

echo OK
