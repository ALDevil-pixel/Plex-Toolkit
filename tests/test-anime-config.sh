#!/usr/bin/env bash
set -e

source lib/anime_config.sh

ptk_load_anime_config config/anime.conf

test "$ANIME_SERIES_PATTERN" = "{title}"
test "$ANIME_SEASON_PATTERN" = "Season {season:02d}"
test "$ANIME_EPISODE_PATTERN" = "{title} - S{season:02d}E{episode:02d}"
test "$ANIME_VIDEO_EXTENSIONS" = "mkv mp4 ts"

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

cat > "$TMP" <<'EOF'
ANIME_SERIES_PATTERN="{title}"
ANIME_SEASON_PATTERN="Season {season:02d}"
ANIME_EPISODE_PATTERN=""
ANIME_VIDEO_EXTENSIONS="mkv"
ANIME_REQUIRE_SEASON=true
ANIME_REQUIRE_EPISODE=true
EOF

if ptk_load_anime_config "$TMP" >/dev/null 2>&1; then
    exit 1
fi

echo OK
