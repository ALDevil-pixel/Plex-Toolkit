#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

[[ -f "$ROOT/VERSION" ]]
[[ -f "$ROOT/version" ]]
[[ -f "$ROOT/CHANGELOG.md" ]]

version="$(tr -d '[:space:]' < "$ROOT/VERSION")"
legacy_version="$(tr -d '[:space:]' < "$ROOT/version")"

[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
[[ "$version" == "$legacy_version" ]]

grep -Fq "## v$version" "$ROOT/CHANGELOG.md"
grep -Fq "Version: \`$version\`" "$ROOT/README.md"

echo "Version consistency: OK"
