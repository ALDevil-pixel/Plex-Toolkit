#!/usr/bin/env bash
source lib/system.sh
echo "Testing system info..."
ptk_collect_system_info >/dev/null
echo "OK"
