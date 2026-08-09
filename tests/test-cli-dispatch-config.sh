#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Dispatcher must translate command hyphens to function underscores.
grep -q '"cmd_${command//-/_}"' "$ROOT/plex-toolkit"

# Common parser must accept --config and route known config names.
source "$ROOT/lib/cli_errors.sh"
source "$ROOT/lib/cli_options.sh"

ptk_parse_common_options --config /tmp/plex.conf --dry-run
[[ "$PTK_CONFIG_FILE" == "/tmp/plex.conf" ]]
[[ "$PTK_PLEX_CONFIG" == "/tmp/plex.conf" ]]
[[ "$PLEXTK_CONFIG" == "/tmp/plex.conf" ]]

ptk_parse_common_options --config /tmp/inventory.conf
[[ "$PTK_INVENTORY_CONFIG" == "/tmp/inventory.conf" ]]

ptk_parse_common_options --config /tmp/anime.yaml
[[ "$PTK_ANIME_CONFIG" == "/tmp/anime.yaml" ]]

ptk_parse_common_options --config /tmp/movies.conf
[[ "$PTK_MOVIE_CONFIG" == "/tmp/movies.conf" ]]

# Missing value must be rejected.
if ptk_parse_common_options --config >/dev/null 2>&1; then
    exit 1
fi

echo OK
