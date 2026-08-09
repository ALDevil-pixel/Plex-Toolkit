#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/Anime/Show"
touch "$TMP/Anime/Show/My.Anime.S01E02.mkv"
touch "$TMP/Anime/Show/My Anime - S01E03.mp4"

"$ROOT/plex-toolkit" anime-rename "$TMP/Anime" >/tmp/ptk-anime-dry.out
grep '\[RENAME\]' /tmp/ptk-anime-dry.out >/dev/null
test -f "$TMP/Anime/Show/My.Anime.S01E02.mkv"
test ! -e "$TMP/Anime/Show/My Anime - S01E02.mkv"

"$ROOT/plex-toolkit" anime-rename --fix "$TMP/Anime" >/tmp/ptk-anime-fix.out
grep '\[DONE\]' /tmp/ptk-anime-fix.out >/dev/null
test ! -e "$TMP/Anime/Show/My.Anime.S01E02.mkv"
test -f "$TMP/Anime/Show/My Anime - S01E02.mkv"

"$ROOT/plex-toolkit" anime-rename --fix "$TMP/Anime" >/tmp/ptk-anime-second.out
grep 'Already normalized' /tmp/ptk-anime-second.out >/dev/null

rm -f /tmp/ptk-anime-dry.out /tmp/ptk-anime-fix.out /tmp/ptk-anime-second.out
echo OK
