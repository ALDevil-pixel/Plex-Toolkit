#!/usr/bin/env bash
source lib/rename.sh
result=$(ptk_build_name "Avatar.2009.1080p.x264.mkv" movie)
test "$result" = "Avatar (2009).mkv"
echo OK
