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
{"key":"1","type":"movie","title":"Films","Location":[{"path":"PLACEHOLDER"}]}
]}}
JSON
    ;;
  */library/sections/1/all*)
    cat <<'JSON'
{"MediaContainer":{"size":2,"Metadata":[
{"ratingKey":"101","type":"movie","title":"Film A","year":2020,"updatedAt":1700000000},
{"ratingKey":"102","type":"movie","title":"Plex Only","year":2021,"updatedAt":1700000100}
]}}
JSON
    ;;
  */library/sections/1/refresh*)
    printf '{"MediaContainer":{"size":1}}'
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

plan="$("$ROOT/plex-toolkit" plex-sync-plan \
    --config "$TMP/plex.conf" "$TMP/Movies" 1)"
grep 'ADD_TO_PLEX' <<<"$plan" >/dev/null
grep 'Local Only (2022).mp4' <<<"$plan" >/dev/null

validate="$("$ROOT/plex-toolkit" plex-sync-validate \
    --config "$TMP/plex.conf" "$TMP/Movies/Local Only (2022).mp4" 1)"
grep 'Plex sync target: VALID' <<<"$validate" >/dev/null

dry="$("$ROOT/plex-toolkit" plex-sync-add \
    --config "$TMP/plex.conf" "$TMP/Movies/Local Only (2022).mp4" 1)"
grep '\[DRY-RUN\] No Plex request sent.' <<<"$dry" >/dev/null

add="$("$ROOT/plex-toolkit" plex-sync-add \
    --config "$TMP/plex.conf" --fix "$TMP/Movies/Film A (2020).mkv" 1)"
grep 'Plex add request: OK' <<<"$add" >/dev/null
grep 'Plex media verification: FOUND' <<<"$add" >/dev/null

# No local modification happened during the complete workflow.
test -f "$TMP/Movies/Film A (2020).mkv"
test -f "$TMP/Movies/Local Only (2022).mp4"

# The token must never appear in command output.
for output in "$plan" "$validate" "$dry" "$add"; do
    if grep -q 'test-token' <<<"$output"; then
        exit 1
    fi
done

echo "Plex sync integration: OK"
