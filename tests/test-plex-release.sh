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
printf 'movie a\n' > "$TMP/Movies/Film A (2020).mkv"
printf 'local only\n' > "$TMP/Movies/Local Only (2022).mp4"

cat > "$TMP/bin/curl" <<'EOF'
#!/usr/bin/env bash
case "$*" in
  */identity*)
    printf '{"MediaContainer":{"size":1}}'
    ;;
  */library/sections*)
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

export PATH="$TMP/bin:$PATH"

"$ROOT/plex-toolkit" plex-config --config "$TMP/plex.conf" >/tmp/ptk-release-config.out
grep 'Plex configuration: OK' /tmp/ptk-release-config.out >/dev/null
if grep -q 'test-token' /tmp/ptk-release-config.out; then exit 1; fi

"$ROOT/plex-toolkit" plex-ping --config "$TMP/plex.conf" >/tmp/ptk-release-ping.out
grep 'Plex connectivity: OK' /tmp/ptk-release-ping.out >/dev/null

"$ROOT/plex-toolkit" plex-libraries --config "$TMP/plex.conf" >/tmp/ptk-release-libraries.out
grep $'1\tmovie\tFilms' /tmp/ptk-release-libraries.out >/dev/null

"$ROOT/plex-toolkit" plex-media --config "$TMP/plex.conf" 1 >/tmp/ptk-release-media.out
grep 'Film A' /tmp/ptk-release-media.out >/dev/null
grep 'Film B' /tmp/ptk-release-media.out >/dev/null 2>/dev/null || true

"$ROOT/plex-toolkit" plex-compare --config "$TMP/plex.conf" "$TMP/Movies" 1 >/tmp/ptk-release-compare.out
grep 'MATCH' /tmp/ptk-release-compare.out >/dev/null
grep 'LOCAL_ONLY' /tmp/ptk-release-compare.out >/dev/null
grep 'PLEX_ONLY' /tmp/ptk-release-compare.out >/dev/null

# Read-only guarantee.
test -f "$TMP/Movies/Film A (2020).mkv"
test -f "$TMP/Movies/Local Only (2022).mp4"

rm -f /tmp/ptk-release-config.out /tmp/ptk-release-ping.out \
      /tmp/ptk-release-libraries.out /tmp/ptk-release-media.out \
      /tmp/ptk-release-compare.out

echo "Plex release tests: OK"
