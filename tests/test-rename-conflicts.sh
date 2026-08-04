#!/usr/bin/env bash
source lib/rename_conflicts.sh

touch /tmp/existing.mkv

ptk_check_conflict /tmp/existing.mkv
test $? -eq 0

result=$(ptk_resolve_conflict /tmp/existing.mkv suffix)
echo "$result" | grep "_1.mkv" >/dev/null

rm -f /tmp/existing.mkv
echo OK
