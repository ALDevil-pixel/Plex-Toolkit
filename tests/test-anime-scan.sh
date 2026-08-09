#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/Anime/Show" "$TMP/Anime/Other"
touch "$TMP/Anime/Show/Show - S01E01.mkv"
touch "$TMP/Anime/Show/Show - S01E02.mp4"
touch "$TMP/Anime/Other/README.txt"

(
    cd "$ROOT"
    source lib/anime_config.sh
    source lib/anime_scanner.sh

    ptk_load_anime_config config/anime.conf
    output="$(ptk_anime_scan "$TMP/Anime")"

    grep 'S01E01' <<<"$output" >/dev/null
    grep 'S01E02' <<<"$output" >/dev/null
    grep 'Unsupported' <<<"$output" >/dev/null
    grep 'Videos      : 2' <<<"$output" >/dev/null

    # Scanner must not modify files.
    test -f "$TMP/Anime/Show/Show - S01E01.mkv"
    test -f "$TMP/Anime/Show/Show - S01E02.mp4"
)

output="$("$ROOT/plex-toolkit" anime-scan "$TMP/Anime")"
grep 'Anime Scan' <<<"$output" >/dev/null
grep 'Videos      : 2' <<<"$output" >/dev/null

echo OK
