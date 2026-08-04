#!/usr/bin/env bash
source lib/inventory_stats.sh

cat >/tmp/inventory.txt <<EOF
movie1.mkv|mkv|100|2026-01-01|/tmp/movie1.mkv
movie2.mp4|mp4|300|2026-01-01|/tmp/movie2.mp4
EOF

ptk_inventory_stats /tmp/inventory.txt | grep "Files :" >/dev/null

rm -f /tmp/inventory.txt
echo OK
