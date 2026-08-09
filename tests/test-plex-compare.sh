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
printf 'movie A\n' > "$TMP/Movies/Film A (2020).mkv"
printf 'local only\n' > "$TMP/Movies/Local Only (2022).mp4"

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
{"ratingKey":"101","type":"movie","title":"Film A","year":2020},
{"ratingKey":"102","type":"movie","title":"Plex Only","year":2021}
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

output="$(PATH="$TMP/bin:$PATH" "$ROOT/plex-toolkit" plex-compare \
    --config "$TMP/plex.conf" "$TMP/Movies" 1)"

grep 'MATCH' <<<"$output" >/dev/null
grep 'Film A (2020).mkv' <<<"$output" >/dev/null
grep 'LOCAL_ONLY' <<<"$output" >/dev/null
grep 'Local Only (2022).mp4' <<<"$output" >/dev/null
grep 'PLEX_ONLY' <<<"$output" >/dev/null
grep 'plex only' <<<"$output" >/dev/null

if grep -q 'test-token' <<<"$output"; then
    exit 1
fi

# Comparison is read-only.
test -f "$TMP/Movies/Film A (2020).mkv"
test -f "$TMP/Movies/Local Only (2022).mp4"

echo OK
