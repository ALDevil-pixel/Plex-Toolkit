#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

cat > "$TMP/plex.conf" <<'EOF'
PLEX_URL="https://plex.example.test:32400"
PLEX_TOKEN="secret-token"
PLEX_TIMEOUT=15
PLEX_VERIFY_TLS=true
PLEX_RETRIES=3
EOF

source lib/plex_config.sh
ptk_load_plex_config "$TMP/plex.conf"

test "$PLEX_URL" = "https://plex.example.test:32400"
test "$PLEX_TIMEOUT" = "15"
test "$PLEX_VERIFY_TLS" = "true"
test "$PLEX_RETRIES" = "3"
test "$(ptk_plex_url /library/sections)" = "https://plex.example.test:32400/library/sections"

output="$("$ROOT/plex-toolkit" plex-config --config "$TMP/plex.conf")"
grep 'Plex configuration: OK' <<<"$output" >/dev/null
grep 'Token          : configured' <<<"$output" >/dev/null
if grep -q 'secret-token' <<<"$output"; then
    exit 1
fi

cat > "$TMP/bad.conf" <<'EOF'
PLEX_URL="ftp://plex.example.test"
PLEX_TOKEN="secret"
PLEX_TIMEOUT=10
PLEX_VERIFY_TLS=true
PLEX_RETRIES=2
EOF

if ptk_load_plex_config "$TMP/bad.conf" >/dev/null 2>&1; then
    exit 1
fi

cat > "$TMP/bad2.conf" <<'EOF'
PLEX_URL="https://plex.example.test"
PLEX_TOKEN=""
PLEX_TIMEOUT=10
PLEX_VERIFY_TLS=true
PLEX_RETRIES=2
EOF

if ptk_load_plex_config "$TMP/bad2.conf" >/dev/null 2>&1; then
    exit 1
fi

echo OK
