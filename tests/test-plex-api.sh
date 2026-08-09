#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

cat > "$TMP/plex.conf" <<'EOF'
PLEX_URL="http://127.0.0.1:1"
PLEX_TOKEN="test-token"
PLEX_TIMEOUT=1
PLEX_VERIFY_TLS=true
PLEX_RETRIES=0
EOF

# Configuration validation remains separate from network access.
source lib/plex_config.sh
source lib/plex_api.sh
ptk_load_plex_config "$TMP/plex.conf"
test "$(ptk_plex_url "/identity")" = "http://127.0.0.1:1/identity"

# The command must not leak the token.
if "$ROOT/plex-toolkit" plex-ping --config "$TMP/plex.conf" >/tmp/ptk-plex-ping.out 2>&1; then
    exit 1
fi
if grep -q 'test-token' /tmp/ptk-plex-ping.out; then
    exit 1
fi

rm -f /tmp/ptk-plex-ping.out
echo OK
