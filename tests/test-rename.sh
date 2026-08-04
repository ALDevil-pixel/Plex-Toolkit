#!/usr/bin/env bash
mkdir -p /tmp/ptk-rename
touch /tmp/ptk-rename/movie.mkv
source lib/rename.sh
ptk_rename_library /tmp/ptk-rename 1 >/dev/null
rm -rf /tmp/ptk-rename
echo OK
