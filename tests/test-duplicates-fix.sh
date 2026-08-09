#!/usr/bin/env bash
set -e

TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

mkdir -p "$TEST_ROOT/A" "$TEST_ROOT/B"

echo "same content" > "$TEST_ROOT/A/movie.mkv"
cp "$TEST_ROOT/A/movie.mkv" "$TEST_ROOT/B/movie.mkv"

source lib/duplicates.sh

ptk_find_duplicates --deep --dry-run "$TEST_ROOT" >/tmp/ptk-dup-dry.out
test -f "$TEST_ROOT/A/movie.mkv"
test -f "$TEST_ROOT/B/movie.mkv"

ptk_find_duplicates --deep --fix "$TEST_ROOT" >/tmp/ptk-dup-fix.out

test -f "$TEST_ROOT/A/movie.mkv"
test ! -f "$TEST_ROOT/B/movie.mkv"

echo OK
