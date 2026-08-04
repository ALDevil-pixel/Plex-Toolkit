#!/usr/bin/env bash
source lib/duplicates_cleanup.sh
mkdir -p logs
cat >/tmp/dup.txt <<EOF
[WARN] movie.mkv
 - /media/A/movie.mkv
 - /media/B/movie.mkv
EOF
ptk_cleanup_report /tmp/dup.txt /tmp/report.txt
test -f /tmp/report.txt
rm -f /tmp/dup.txt /tmp/report.txt
echo OK
