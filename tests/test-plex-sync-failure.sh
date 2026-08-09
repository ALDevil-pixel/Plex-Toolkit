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
printf 'movie\n' > "$TMP/Movies/Film.mkv"

cat > "$TMP/bin/curl" <<'EOF'
#!/usr/bin/env bash
case "$*" in
  */library/sections*)
    cat <<'JSON'
{"MediaContainer":{"Directory":[
{"key":"1","type":"movie","title":"Films","Location":[{"path":"PLACEHOLDER"}]}
]}}
JSON
    ;;
  */library/sections/1/refresh*)
    exit 22
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
PLEX_TIMEOUT=1
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

if PATH="$TMP/bin:$PATH" "$ROOT/plex-toolkit" plex-sync-add \
    --config "$TMP/plex.conf" --fix "$TMP/Movies/Film.mkv" 1 >/dev/null 2>&1; then
    exit 1
fi

test -f "$TMP/Movies/Film.mkv"
echo OK
