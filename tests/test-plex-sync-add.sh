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
printf 'movie\n' > "$TMP/Movies/Film A (2020).mkv"

cat > "$TMP/bin/curl" <<'EOF'
#!/usr/bin/env bash
case "$*" in
  */library/sections)
    cat <<'JSON'
{"MediaContainer":{"Directory":[
{"key":"1","type":"movie","title":"Films","Location":[{"path":"PLACEHOLDER"}]}
]}}
JSON
    ;;
  */library/sections/1/refresh*)
    printf '{"MediaContainer":{"size":1}}'
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
sed -i "s|PLACEHOLDER|$TMP/Movies|" "$TMP/bin/curl"
chmod +x "$TMP/bin/curl"

cat > "$TMP/plex.conf" <<'EOF'
PLEX_URL="http://plex.test:32400"
PLEX_TOKEN="test-token"
PLEX_TIMEOUT=5
PLEX_VERIFY_TLS=true
PLEX_RETRIES=0
EOF

cat > "$TMP/plex-sync.conf" <<EOF
PLEX_SYNC_MODE="local-to-plex"
PLEX_SYNC_MOVIE_EXTENSIONS="mkv mp4 ts"
PLEX_SYNC_REQUIRE_YEAR=false
PLEX_SYNC_ALLOW_PLEX_ONLY=false
PLEX_SYNC_ALLOWED_ROOTS="$TMP/Movies"
EOF

export PATH="$TMP/bin:$PATH"

dry="$("$ROOT/plex-toolkit" plex-sync-add \
    --config "$TMP/plex.conf" "$TMP/Movies/Film A (2020).mkv" 1)"
grep '\[DRY-RUN\] No Plex request sent.' <<<"$dry" >/dev/null

fix="$("$ROOT/plex-toolkit" plex-sync-add \
    --config "$TMP/plex.conf" --fix "$TMP/Movies/Film A (2020).mkv" 1)"
grep 'Plex add request: OK' <<<"$fix" >/dev/null
grep 'Plex media verification: FOUND' <<<"$fix" >/dev/null

if grep -q 'test-token' <<<"$fix"; then exit 1; fi
test -f "$TMP/Movies/Film A (2020).mkv"

echo OK
