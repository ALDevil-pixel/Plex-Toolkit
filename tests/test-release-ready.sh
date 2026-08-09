#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

version="$(tr -d '[:space:]' < VERSION)"
test -n "$version"

bash tests/test-sprint-1.10.sh
bash tests/test-cli.sh
bash tests/test-integration.sh
bash tests/test-regression.sh

echo "Release readiness: OK"
echo "Version: $version"
