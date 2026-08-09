#!/usr/bin/env bash
set -e

TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

mkdir -p "$TEST_ROOT/reports"
printf 'movie.mkv|mkv|12|2026-01-01 00:00:00|/media/movie.mkv\n' > "$TEST_ROOT/input.txt"

cat > "$TEST_ROOT/inventory.conf" <<EOF
REPORT_DIR="$TEST_ROOT/reports"
INVENTORY_CSV_REPORT="custom.csv"
INVENTORY_JSON_REPORT="custom.json"
INVENTORY_LOG="custom.log"
EOF

(
    cd "$TEST_ROOT"
    source "$OLDPWD/lib/inventory_csv.sh"
    source "$OLDPWD/lib/inventory_json.sh"
    source "$OLDPWD/lib/inventory_logger.sh"
    PTK_INVENTORY_CONFIG="$TEST_ROOT/inventory.conf"

    ptk_inventory_export_csv "$TEST_ROOT/input.txt" >/dev/null
    ptk_inventory_export_json "$TEST_ROOT/input.txt" >/dev/null
    ptk_inventory_log "test"

    test -f "$TEST_ROOT/reports/custom.csv"
    test -f "$TEST_ROOT/reports/custom.json"
    test -f "$TEST_ROOT/reports/custom.log"
)

echo OK
