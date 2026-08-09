#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

for entry in \
    "$ROOT/plex-toolkit" \
    "$ROOT/plugins/anime/audit.sh" \
    "$ROOT/plugins/anime/rename.sh" \
    "$ROOT/plugins/movies/duplicates.sh" \
    "$ROOT/plugins/plex/verify.sh"
do
    [[ -x "$entry" ]] || {
        echo "Not executable: $entry" >&2
        exit 1
    }
done

echo "Plugin permissions: OK"
