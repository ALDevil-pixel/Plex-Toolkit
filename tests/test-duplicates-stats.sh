#!/usr/bin/env bash
source lib/duplicates_stats.sh
cat >/tmp/ptk-stats.txt <<EOF
[WARN] movie.mkv
 - /a/movie.mkv
 - /b/movie.mkv
EOF
ptk_duplicates_stats /tmp/ptk-stats.txt >/dev/null
rm -f /tmp/ptk-stats.txt
echo OK
