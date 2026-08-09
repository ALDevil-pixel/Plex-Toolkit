#!/usr/bin/env bash
set -e

TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

touch "$TEST_ROOT/Avatar.2009.1080p.x264.mkv"

source lib/rename.sh

ptk_rename --dry-run "$TEST_ROOT" >/dev/null
test -f "$TEST_ROOT/Avatar.2009.1080p.x264.mkv"

ptk_rename --fix "$TEST_ROOT" >/dev/null
test -f "$TEST_ROOT/Avatar (2009).mkv"
test ! -f "$TEST_ROOT/Avatar.2009.1080p.x264.mkv"

echo OK
