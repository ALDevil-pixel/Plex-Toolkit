#!/usr/bin/env bash
mkdir -p /tmp/ptk-sub
touch /tmp/ptk-sub/movie.srt
touch /tmp/ptk-sub/video.mkv
touch /tmp/ptk-sub/orphan.ass

source lib/cleanup_orphan_subtitles.sh

ptk_find_orphan_subtitles /tmp/ptk-sub | grep orphan.ass >/dev/null

rm -rf /tmp/ptk-sub
echo OK
