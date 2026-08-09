#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

test -f config/anime.conf
test -f lib/anime_config.sh
test -f lib/anime_scanner.sh
test -f lib/anime_rename.sh
test -f commands/anime-scan
test -f commands/anime-rename-plan
test -f commands/anime-rename
test -f tests/test-anime-config.sh
test -f tests/test-anime-scan.sh
test -f tests/test-anime-rename-plan.sh
test -f tests/test-anime-rename.sh
test -f tests/test-anime-edge-cases.sh

grep -q 'Sprint: 1.11.0' SPRINT_STATE.md
grep -q 'Partie: 6' SPRINT_STATE.md

grep -q 'ptk_load_anime_config' commands/anime-scan
grep -q 'ptk_load_anime_config' commands/anime-rename-plan
grep -q 'ptk_load_anime_config' commands/anime-rename
grep -q 'ptk_anime_rename_proposals' commands/anime-rename-plan
grep -q 'ptk_anime_apply_renames' commands/anime-rename

echo "Sprint 1.11.0 coherence: OK"
