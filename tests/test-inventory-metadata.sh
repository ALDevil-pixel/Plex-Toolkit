#!/usr/bin/env bash
mkdir -p /tmp/ptk-meta
echo test >/tmp/ptk-meta/movie.mkv
source lib/inventory_metadata.sh
ptk_inventory_metadata /tmp/ptk-meta/movie.mkv | grep "movie.mkv" >/dev/null
rm -rf /tmp/ptk-meta
echo OK
