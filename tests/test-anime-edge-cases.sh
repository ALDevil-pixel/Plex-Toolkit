#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/Anime/Show"

touch "$TMP/Anime/Show/My.Anime.S01E02.mkv"
touch "$TMP/Anime/Show/My-Anime.S01E02.mp4"
touch "$TMP/Anime/Show/My Anime S01E03.ts"
touch "$TMP/Anime/Show/readme.txt"

# Existing destination must never be overwritten.
touch "$TMP/Anime/Show/My Anime - S01E02.mkv"
output="$("$ROOT/plex-toolkit" anime-rename-plan "$TMP/Anime")"
grep 'Target exists' <<<"$output" >/dev/null

# Two different source files generating the same target must be reported.
grep 'Duplicate target' <<<"$output" >/dev/null

# Invalid placeholders must be rejected.
BAD="$TMP/bad.conf"
cat > "$BAD" <<'EOF'
ANIME_SERIES_PATTERN="{title}"
ANIME_SEASON_PATTERN="Season {season:02d}"
ANIME_EPISODE_PATTERN="{title} - {foo}"
ANIME_VIDEO_EXTENSIONS="mkv"
ANIME_REQUIRE_SEASON=true
ANIME_REQUIRE_EPISODE=true
EOF

if (
    cd "$ROOT"
    source lib/anime_config.sh
    ptk_load_anime_config "$BAD"
) >/dev/null 2>&1; then
    exit 1
fi

echo OK
