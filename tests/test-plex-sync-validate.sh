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
touch "$TMP/Movies/notes.txt"

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

cat > "$TMP/plex-sync.conf" <<EOF
PLEX_SYNC_MODE="local-to-plex"
PLEX_SYNC_MOVIE_EXTENSIONS="mkv mp4 ts"
PLEX_SYNC_REQUIRE_YEAR=false
PLEX_SYNC_ALLOW_PLEX_ONLY=false
PLEX_SYNC_ALLOWED_ROOTS="$TMP/Movies"
EOF

output="$(PATH="$TMP/bin:$PATH" "$ROOT/plex-toolkit" plex-sync-validate \
    --config "$TMP/plex.conf" "$TMP/Movies/Film.mkv" 1)"

grep 'Plex sync target: VALID' <<<"$output" >/dev/null
grep 'Modification   : NONE' <<<"$output" >/dev/null

if grep -q 'test-token' <<<"$output"; then exit 1; fi

if PATH="$TMP/bin:$PATH" "$ROOT/plex-toolkit" plex-sync-validate \
    --config "$TMP/plex.conf" "$TMP/Movies/notes.txt" 1 >/dev/null 2>&1; then
    exit 1
fi

if PATH="$TMP/bin:$PATH" "$ROOT/plex-toolkit" plex-sync-validate \
    --config "$TMP/plex.conf" "$TMP/Movies/Film.mkv" 2 >/dev/null 2>&1; then
    exit 1
fi

if PATH="$TMP/bin:$PATH" "$ROOT/plex-toolkit" plex-sync-validate \
    --config "$TMP/plex.conf" --fix "$TMP/Movies/Film.mkv" 1 >/dev/null 2>&1; then
    exit 1
fi

test -f "$TMP/Movies/Film.mkv"
echo OK
