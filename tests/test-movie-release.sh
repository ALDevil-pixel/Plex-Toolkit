#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/Movies"

printf 'same movie\n' > "$TMP/Movies/Movie.mp4"
cp "$TMP/Movies/Movie.mp4" "$TMP/Movies/Movie.mkv"
printf 'different movie\n' > "$TMP/Movies/Other.mkv"

# Scan is read-only.
"$ROOT/plex-toolkit" movie-scan "$TMP/Movies" >/dev/null
test -f "$TMP/Movies/Movie.mp4"
test -f "$TMP/Movies/Movie.mkv"

# Duplicate plan is read-only.
"$ROOT/plex-toolkit" movie-duplicates "$TMP/Movies" >/tmp/ptk-movie-release-plan.out
grep '\[DUPLICATE\]' /tmp/ptk-movie-release-plan.out >/dev/null
test -f "$TMP/Movies/Movie.mp4"
test -f "$TMP/Movies/Movie.mkv"

# Fix keeps the preferred MKV and removes the verified MP4 duplicate.
"$ROOT/plex-toolkit" movie-duplicates --fix "$TMP/Movies" >/tmp/ptk-movie-release-fix.out
test ! -f "$TMP/Movies/Movie.mp4"
test -f "$TMP/Movies/Movie.mkv"
test -f "$TMP/Movies/Other.mkv"

# A second fix is idempotent.
"$ROOT/plex-toolkit" movie-duplicates --fix "$TMP/Movies" >/dev/null
test -f "$TMP/Movies/Movie.mkv"
test -f "$TMP/Movies/Other.mkv"

rm -f /tmp/ptk-movie-release-plan.out /tmp/ptk-movie-release-fix.out

echo "Movie release tests: OK"
