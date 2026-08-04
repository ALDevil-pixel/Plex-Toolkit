#!/usr/bin/env bash
mkdir -p /tmp/ptkdup2
echo a >/tmp/ptkdup2/a.mkv
cp /tmp/ptkdup2/a.mkv /tmp/ptkdup2/b.mkv
source lib/duplicates.sh
ptk_find_duplicates --deep /tmp/ptkdup2 >/dev/null
rm -rf /tmp/ptkdup2
echo OK
