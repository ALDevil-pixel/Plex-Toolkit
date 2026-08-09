#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/Movies"
printf 'same movie content\n' > "$TMP/Movies/Movie A.mp4"
cp "$TMP/Movies/Movie A.mp4" "$TMP/Movies/Movie B.mkv"
printf 'different content\n' > "$TMP/Movies/Different.mkv"

output="$("$ROOT/plex-toolkit" movie-duplicates "$TMP/Movies")"

grep '\[DUPLICATE\]' <<<"$output" >/dev/null
grep 'Movie A.mp4' <<<"$output" >/dev/null
grep 'Movie B.mkv' <<<"$output" >/dev/null
grep 'Duplicate groups found: 1' <<<"$output" >/dev/null
grep 'Duplicate files found: 1' <<<"$output" >/dev/null
grep '\[KEEP\]' <<<"$output" >/dev/null

# Default mode is read-only.
test -f "$TMP/Movies/Movie A.mp4"
test -f "$TMP/Movies/Movie B.mkv"

# MKV is preferred by configuration, therefore it is kept.
"$ROOT/plex-toolkit" movie-duplicates --fix "$TMP/Movies" >/tmp/ptk-movie-duplicates-fix.out
grep 'Movie B.mkv' /tmp/ptk-movie-duplicates-fix.out >/dev/null
test ! -f "$TMP/Movies/Movie A.mp4"
test -f "$TMP/Movies/Movie B.mkv"
test -f "$TMP/Movies/Different.mkv"

rm -f /tmp/ptk-movie-duplicates-fix.out
echo OK
