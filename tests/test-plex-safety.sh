#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

if ! command -v jq >/dev/null 2>&1; then
    echo "SKIP: jq not installed"
    exit 0
fi

mkdir -p "$TMP/bin" "$TMP/Movies"
touch "$TMP/Movies/Film.mkv"

cat > "$TMP/bin/curl" <<'EOF'
#!/usr/bin/env bash
case "$*" in
  */library/sections)
    cat <<'JSON'
{"MediaContainer":{"Directory":[
{"key":"1","type":"movie","title":"Films"},
{"key":"2","type":"show","title":"Séries"}
]}}
JSON
    ;;
  */library/sections/1/all*)
    cat <<'JSON'
{"MediaContainer":{"size":1,"Metadata":[
{"ratingKey":"101","type":"movie","title":"Film","year":2020}
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

# Correct library type works.
PATH="$TMP/bin:$PATH" "$ROOT/plex-toolkit" plex-compare \
    --config "$TMP/plex.conf" "$TMP/Movies" 1 >/dev/null

# Wrong library type must fail before media processing.
if PATH="$TMP/bin:$PATH" "$ROOT/plex-toolkit" plex-compare \
    --config "$TMP/plex.conf" "$TMP/Movies" 2 >/dev/null 2>&1; then
    exit 1
fi

# Nonexistent local target must fail.
if PATH="$TMP/bin:$PATH" "$ROOT/plex-toolkit" plex-compare \
    --config "$TMP/plex.conf" "$TMP/does-not-exist" 1 >/dev/null 2>&1; then
    exit 1
fi

echo OK
