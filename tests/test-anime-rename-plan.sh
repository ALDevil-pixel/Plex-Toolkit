#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/Anime/Show"
touch "$TMP/Anime/Show/My.Anime.S01E02.mkv"
touch "$TMP/Anime/Show/My Anime - S01E03.mp4"
touch "$TMP/Anime/Show/readme.txt"

output="$("$ROOT/plex-toolkit" anime-rename-plan "$TMP/Anime")"

grep '\[RENAME\]' <<<"$output" >/dev/null
grep 'My Anime - S01E02.mkv' <<<"$output" >/dev/null
grep 'My Anime - S01E03.mp4' <<<"$output" >/dev/null
grep '\[SKIP\]' <<<"$output" >/dev/null || true

test -f "$TMP/Anime/Show/My.Anime.S01E02.mkv"
test ! -e "$TMP/Anime/Show/My Anime - S01E02.mkv"

echo OK
