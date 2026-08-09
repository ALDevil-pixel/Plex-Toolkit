#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$ROOT/lib/cli_errors.sh"
source "$ROOT/lib/cli_options.sh"
source "$ROOT/lib/config.sh"

ptk_parse_common_options --config /tmp/plex.conf --dry-run --verbose
[[ "$PTK_CONFIG_FILE" == "/tmp/plex.conf" ]]
[[ "$PTK_PLEX_CONFIG" == "/tmp/plex.conf" ]]
[[ "$PTK_DRY_RUN" -eq 1 ]]
[[ "$PTK_VERBOSE" -eq 1 ]]

ptk_config_validate_bool true
ptk_config_validate_bool false
ptk_config_validate_bool 1
ptk_config_validate_bool 0

if ptk_config_validate_bool maybe; then
    exit 1
fi

[[ "$(ptk_config_bool_value true)" == "true" ]]
[[ "$(ptk_config_bool_value false)" == "false" ]]

grep -Fq 'cmd_${command//-/_}' "$ROOT/plex-toolkit"

test -x "$ROOT/plex-toolkit"

echo "Correction CLI/config: OK"
