#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/Movies"

printf 'same content\n' > "$TMP/Movies/Keep.mp4"
cp "$TMP/Movies/Keep.mp4" "$TMP/Movies/Duplicate.mkv"

# Normal scan is read-only.
"$ROOT/plex-toolkit" movie-duplicates "$TMP/Movies" >/tmp/ptk-dup-safety.out
test -f "$TMP/Movies/Keep.mp4"
test -f "$TMP/Movies/Duplicate.mkv"

# --fix must remove only the verified duplicate and keep the preferred MKV.
"$ROOT/plex-toolkit" movie-duplicates --fix "$TMP/Movies" >/tmp/ptk-dup-safety-fix.out
test ! -f "$TMP/Movies/Keep.mp4"
test -f "$TMP/Movies/Duplicate.mkv"

# Running --fix again must be harmless.
"$ROOT/plex-toolkit" movie-duplicates --fix "$TMP/Movies" >/dev/null
test -f "$TMP/Movies/Duplicate.mkv"

rm -f /tmp/ptk-dup-safety.out /tmp/ptk-dup-safety-fix.out
echo OK
