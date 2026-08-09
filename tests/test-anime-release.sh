#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/Anime/Show"

touch "$TMP/Anime/Show/My.Anime.S01E01.mkv"
touch "$TMP/Anime/Show/My.Anime.S01E02.mkv"

"$ROOT/plex-toolkit" anime-scan "$TMP/Anime" >/dev/null
"$ROOT/plex-toolkit" anime-rename-plan "$TMP/Anime" >/tmp/ptk-anime-release-plan.out

grep '\[RENAME\]' /tmp/ptk-anime-release-plan.out >/dev/null

# Release candidate must still be read-only without --fix.
test -f "$TMP/Anime/Show/My.Anime.S01E01.mkv"
test -f "$TMP/Anime/Show/My.Anime.S01E02.mkv"

"$ROOT/plex-toolkit" anime-rename --fix "$TMP/Anime" >/tmp/ptk-anime-release-fix.out

test -f "$TMP/Anime/Show/My Anime - S01E01.mkv"
test -f "$TMP/Anime/Show/My Anime - S01E02.mkv"

rm -f /tmp/ptk-anime-release-plan.out /tmp/ptk-anime-release-fix.out

echo "Anime release tests: OK"
