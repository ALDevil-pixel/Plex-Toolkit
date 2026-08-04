#!/usr/bin/env bash
source lib/duplicates_report.sh
echo "sample duplicate" >/tmp/ptk-dup-report.txt
ptk_duplicate_report /tmp/ptk-dup-report.txt /tmp/report.txt
test -f /tmp/report.txt
rm -f /tmp/ptk-dup-report.txt /tmp/report.txt
echo OK
