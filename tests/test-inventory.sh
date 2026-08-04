#!/usr/bin/env bash
mkdir -p /tmp/ptk-inventory
touch /tmp/ptk-inventory/movie.mkv
source lib/inventory.sh
ptk_inventory_library /tmp/ptk-inventory >/dev/null
rm -rf /tmp/ptk-inventory
echo OK
