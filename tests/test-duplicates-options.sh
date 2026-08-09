#!/usr/bin/env bash
set -e
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/media"
printf 'same' > "$TMP/media/a.mkv"
cp "$TMP/media/a.mkv" "$TMP/media/b.mkv"

output="$("$ROOT/plex-toolkit" duplicates --dry-run --deep --min-size 1 --extensions mkv "$TMP/media" 2>&1)"
if grep -q 'Unknown option: --deep' <<<"$output"; then exit 1; fi
if grep -q 'Unknown option: --min-size' <<<"$output"; then exit 1; fi
if grep -q 'Unknown option: --extensions' <<<"$output"; then exit 1; fi
echo "Duplicates options: OK"
