#!/usr/bin/env bash
source lib/duplicates_ignore.sh
echo "sample" >/tmp/ignore.txt
ptk_load_ignore_file /tmp/ignore.txt >/dev/null
rm -f /tmp/ignore.txt
echo OK
