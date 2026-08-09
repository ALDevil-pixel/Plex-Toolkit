#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/Movies"
truncate -s 1000 "$TMP/Movies/Movie One.mkv"
truncate -s 2000 "$TMP/Movies/Movie Two.mp4"
touch "$TMP/Movies/readme.txt"
touch "$TMP/Movies/.hidden.mkv"

output="$("$ROOT/plex-toolkit" movie-scan "$TMP/Movies")"

grep 'Movie One.mkv' <<<"$output" >/dev/null
grep 'Movie Two.mp4' <<<"$output" >/dev/null
grep 'Unsupported' <<<"$output" >/dev/null
grep 'Files           : 3' <<<"$output" >/dev/null
grep 'Videos          : 2' <<<"$output" >/dev/null

# Scanner is read-only.
test -f "$TMP/Movies/Movie One.mkv"
test -f "$TMP/Movies/Movie Two.mp4"
test -f "$TMP/Movies/readme.txt"
test -f "$TMP/Movies/.hidden.mkv"

echo OK
