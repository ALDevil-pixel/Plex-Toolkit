#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

test -f VERSION
test -f SPRINT_STATE.md
test -f release-notes.md
test -f config/defaults.conf
test -f config/report.conf
test -f config/inventory.conf
test -f config/check.conf
test -f lib/config.sh
test -f lib/report.sh
test -f lib/logger.sh

# Ensure the common configuration layer is actually used by the
# modules modified during the sprint.
grep -q 'ptk_load_config' lib/report.sh
grep -q 'ptk_load_config' lib/inventory_csv.sh
grep -q 'ptk_load_config' lib/inventory_json.sh
grep -q 'ptk_load_config' lib/inventory_logger.sh
grep -q 'ptk_validate_config' lib/config.sh

echo "Sprint 1.9.0 coherence: OK"
