#!/usr/bin/env bash
set -e

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo 'Movies=/tmp' > "$TMP/library.conf"
source "$PWD/lib/library_loader.sh"
ptk_load_libraries "$TMP/library.conf" >/dev/null

echo OK
