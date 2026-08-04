#!/usr/bin/env bash
source lib/inventory_csv.sh
mkdir -p logs
echo "movie.mkv|mkv|123|2026-01-01|/tmp/movie.mkv" >/tmp/inventory.txt
ptk_inventory_export_csv /tmp/inventory.txt /tmp/inventory.csv
test -f /tmp/inventory.csv
rm -f /tmp/inventory.txt /tmp/inventory.csv
echo OK
