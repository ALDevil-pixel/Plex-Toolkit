#!/usr/bin/env bash
set -e

TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

mkdir -p "$TEST_ROOT/media"
touch "$TEST_ROOT/media/Thumbs.db"
touch "$TEST_ROOT/media/orphan.srt"
mkdir -p "$TEST_ROOT/media/empty"

source lib/cleanup.sh

ptk_cleanup "$TEST_ROOT/media" >/tmp/ptk-cleanup-test.out

test -f "$TEST_ROOT/media/Thumbs.db"
test -f "$TEST_ROOT/media/orphan.srt"
test -d "$TEST_ROOT/media/empty"

ptk_cleanup --fix "$TEST_ROOT/media" >/tmp/ptk-cleanup-test-fix.out

test ! -e "$TEST_ROOT/media/Thumbs.db"
test ! -e "$TEST_ROOT/media/orphan.srt"
test ! -e "$TEST_ROOT/media/empty"

echo OK
