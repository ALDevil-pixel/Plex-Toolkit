#!/usr/bin/env bash
mkdir -p /tmp/ptk-report
touch /tmp/ptk-report/test.mkv
source lib/check_report.sh
ptk_check_report /tmp/ptk-report | grep "Files scanned" >/dev/null
rm -rf /tmp/ptk-report
echo OK
