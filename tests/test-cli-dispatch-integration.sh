#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Make the executable bit explicit for source ZIPs that do not preserve it.
chmod +x "$ROOT/plex-toolkit"

# Help proves that the dispatcher can load a command normally.
"$ROOT/plex-toolkit" help >/dev/null

# Hyphenated commands must resolve to underscore function names.
"$ROOT/plex-toolkit" plex-ping --config "$ROOT/config/plex.conf" --dry-run >/dev/null 2>&1 || true

# Unknown commands keep the expected usage error.
if "$ROOT/plex-toolkit" does-not-exist >/dev/null 2>&1; then
    exit 1
fi

echo OK
