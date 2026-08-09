#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

if ! command -v jq >/dev/null 2>&1; then
    echo "SKIP: jq not installed"
    exit 0
fi

mkdir -p "$TMP/bin"

cat > "$TMP/bin/curl" <<'EOF'
#!/usr/bin/env bash
case "$*" in
  */library/sections)
    cat <<'JSON'
{"MediaContainer":{"Directory":[
{"key":"1","type":"movie","title":"Films"}
]}}
JSON
    ;;
  */library/sections/1/all*)
    cat <<'JSON'
{"MediaContainer":{"size":2,"Metadata":[
{"ratingKey":"101","type":"movie","title":"Film A","year":2020,"librarySectionID":"1","librarySectionTitle":"Films","updatedAt":1700000000},
{"ratingKey":"102","type":"movie","title":"Film B","year":2021,"librarySectionID":"1","librarySectionTitle":"Films","updatedAt":1700000100}
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

output="$(PATH="$TMP/bin:$PATH" "$ROOT/plex-toolkit" plex-media --config "$TMP/plex.conf" 1)"

grep 'Film A' <<<"$output" >/dev/null
grep 'Film B' <<<"$output" >/dev/null
grep '101' <<<"$output" >/dev/null
grep '102' <<<"$output" >/dev/null

if grep -q 'test-token' <<<"$output"; then
    exit 1
fi

echo OK
