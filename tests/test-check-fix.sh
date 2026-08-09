#!/usr/bin/env bash
set -e

TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

touch "$TEST_ROOT/empty.mkv"
echo "invalid extension" > "$TEST_ROOT/invalid.wmv"
echo "video" > "$TEST_ROOT/good.mkv"

source lib/check.sh

ptk_check --dry-run "$TEST_ROOT" >/tmp/ptk-check-dry.out
test -f "$TEST_ROOT/empty.mkv"
test -f "$TEST_ROOT/invalid.wmv"

ptk_check --fix "$TEST_ROOT" >/tmp/ptk-check-fix.out

test ! -f "$TEST_ROOT/empty.mkv"
test -f "$TEST_ROOT/invalid.wmv"
test -f "$TEST_ROOT/good.mkv"

grep "INVALID-EXT" /tmp/ptk-check-fix.out >/dev/null

rm -f /tmp/ptk-check-dry.out /tmp/ptk-check-fix.out
echo OK
