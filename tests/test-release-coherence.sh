#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

test -f VERSION
test -f CHANGELOG.md
test -f README.md
test -f LICENSE
test -f Makefile
test -f plex-toolkit

version="$(tr -d '[:space:]' < VERSION)"
test -n "$version"

for command_file in \
    audit check cleanup doctor duplicates help info inventory list rename self-check version
do
    test -f "commands/$command_file"
done

for required in \
    exit_codes.sh cli_errors.sh cli_options.sh logger.sh
do
    test -f "lib/$required"
done

grep -q "v$version" CHANGELOG.md
grep -q "Sprint 1.8.0" SPRINT_STATE.md

echo "Release coherence: OK"
echo "Version: $version"
echo "Commands: 12"
echo "Common libraries: 4"
