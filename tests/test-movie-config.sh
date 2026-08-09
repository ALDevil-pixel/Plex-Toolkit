#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

source lib/movie_config.sh
ptk_load_movie_config config/movies.conf

test "$MOVIES_VIDEO_EXTENSIONS" = "mkv mp4 ts"
test "$MOVIES_MIN_SIZE" = "0"
test "$MOVIES_INCLUDE_HIDDEN" = "false"

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

cat > "$TMP" <<'EOF'
MOVIES_VIDEO_EXTENSIONS="mkv"
MOVIES_MIN_SIZE=invalid
MOVIES_INCLUDE_HIDDEN=false
EOF

if ptk_load_movie_config "$TMP" >/dev/null 2>&1; then
    exit 1
fi

echo OK
