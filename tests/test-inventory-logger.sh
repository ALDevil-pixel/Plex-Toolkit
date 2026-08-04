#!/usr/bin/env bash
source lib/inventory_logger.sh
rm -rf logs
ptk_inventory_log "Inventory test"
test -f logs/inventory.log
grep "Inventory test" logs/inventory.log >/dev/null
rm -rf logs
echo OK
