#!/usr/bin/env bash
source lib/duplicates_export.sh
cat >/tmp/dup.txt <<EOF
[WARN] movie.mkv
 - /media/movie.mkv
EOF
ptk_export_duplicates_csv /tmp/dup.txt /tmp/out.csv
test -f /tmp/out.csv
rm -f /tmp/dup.txt /tmp/out.csv
echo OK
