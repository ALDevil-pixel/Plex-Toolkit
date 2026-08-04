#!/usr/bin/env bash
source lib/inventory_json.sh

echo "movie.mkv|mkv|123|2026-01-01|/tmp/movie.mkv" >/tmp/inventory.txt
ptk_inventory_export_json /tmp/inventory.txt /tmp/inventory.json

test -f /tmp/inventory.json
grep '"name":"movie.mkv"' /tmp/inventory.json >/dev/null

rm -f /tmp/inventory.txt /tmp/inventory.json

echo OK
