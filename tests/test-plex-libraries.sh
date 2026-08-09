#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

if ! command -v jq >/dev/null 2>&1; then
    echo "SKIP: jq not installed"
    exit 0
fi

# Mock curl so the test does not need a Plex server.
mkdir -p "$TMP/bin"
cat > "$TMP/bin/curl" <<'EOF'
#!/usr/bin/env bash
cat <<'JSON'
{"MediaContainer":{"Directory":[
{"key":"1","type":"movie","title":"Films","agent":"tv.plex.agents.movie","scanner":"Plex Movie"},
{"key":"2","type":"show","title":"Séries","agent":"tv.plex.agents.series","scanner":"Plex TV Series"},
{"key":"3","type":"artist","title":"Musique","agent":"tv.plex.agents.music","scanner":"Plex Music"}
]}}
JSON
EOF
chmod +x "$TMP/bin/curl"

cat > "$TMP/plex.conf" <<'EOF'
PLEX_URL="http://plex.test:32400"
PLEX_TOKEN="test-token"
PLEX_TIMEOUT=5
PLEX_VERIFY_TLS=true
PLEX_RETRIES=0
EOF

output="$(PATH="$TMP/bin:$PATH" "$ROOT/plex-toolkit" plex-libraries --config "$TMP/plex.conf")"

grep $'1\tmovie\tFilms' <<<"$output" >/dev/null
grep $'2\tshow\tSéries' <<<"$output" >/dev/null
grep $'3\tartist\tMusique' <<<"$output" >/dev/null

if grep -q 'test-token' <<<"$output"; then
    exit 1
fi

echo OK
