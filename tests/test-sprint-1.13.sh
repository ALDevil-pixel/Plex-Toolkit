#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

for f in \
    config/plex.conf \
    lib/plex_config.sh \
    lib/plex_api.sh \
    lib/plex_libraries.sh \
    lib/plex_media.sh \
    lib/plex_compare.sh \
    lib/plex_safety.sh \
    commands/plex-config \
    commands/plex-ping \
    commands/plex-libraries \
    commands/plex-media \
    commands/plex-compare \
    tests/test-plex-config.sh \
    tests/test-plex-api.sh \
    tests/test-plex-libraries.sh \
    tests/test-plex-media.sh \
    tests/test-plex-compare.sh \
    tests/test-plex-safety.sh
do
    test -f "$f"
done

grep -q 'ptk_plex_request' lib/plex_api.sh
grep -q 'ptk_plex_list_libraries' lib/plex_libraries.sh
grep -q 'ptk_plex_list_media' lib/plex_media.sh
grep -q 'ptk_plex_compare_media' lib/plex_compare.sh
grep -q 'ptk_plex_validate_action_target' lib/plex_safety.sh

echo "Sprint 1.13.0 coherence: OK"
