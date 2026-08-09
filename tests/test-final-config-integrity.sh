#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

for f in "$ROOT"/config/*; do
    [[ -f "$f" ]] || continue
    test -s "$f"
done

# The repository must still contain all tracked configuration files after the
# complete test suite has run.
for f in \
    anime.conf anime.yaml check.conf collections.yaml defaults.conf \
    inventory.conf library.conf library.yaml movies.conf movies.yaml \
    plex-sync.conf plex.conf plex.yaml report.conf
do
    test -s "$ROOT/config/$f"
done

echo "Final config integrity: OK"
