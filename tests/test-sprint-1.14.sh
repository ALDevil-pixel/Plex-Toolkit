#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

for f in \
    config/plex-sync.conf \
    lib/plex_sync_config.sh \
    lib/plex_sync_plan.sh \
    lib/plex_sync_validate.sh \
    lib/plex_sync_add.sh \
    lib/plex_sync_verify.sh \
    commands/plex-sync-plan \
    commands/plex-sync-validate \
    commands/plex-sync-add \
    tests/test-plex-sync-plan.sh \
    tests/test-plex-sync-validate.sh \
    tests/test-plex-sync-add.sh \
    tests/test-plex-sync-integration.sh \
    tests/test-plex-sync-failure.sh
do
    test -f "$f"
done

grep -q 'ptk_plex_sync_plan' lib/plex_sync_plan.sh
grep -q 'ptk_plex_sync_validate_file' lib/plex_sync_validate.sh
grep -q 'ptk_plex_sync_add' lib/plex_sync_add.sh
grep -q 'ptk_plex_sync_verify_add' lib/plex_sync_verify.sh

grep -q 'plex-sync-plan' plex-toolkit
grep -q 'plex-sync-validate' plex-toolkit
grep -q 'plex-sync-add' plex-toolkit

echo "Sprint 1.14.0 coherence: OK"
