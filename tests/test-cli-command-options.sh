#!/usr/bin/env bash
set -e
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT/lib/cli_errors.sh"
source "$ROOT/lib/cli_options.sh"

ptk_parse_common_options --config /tmp/duplicates.conf --dry-run --deep --min-size 1024 --extensions mkv,mp4 --summary /media

printf '%s\n' "${PTK_POSITIONAL[@]}" | grep -Fx -- '--deep' >/dev/null
printf '%s\n' "${PTK_POSITIONAL[@]}" | grep -Fx -- '--min-size' >/dev/null
printf '%s\n' "${PTK_POSITIONAL[@]}" | grep -Fx -- '1024' >/dev/null
printf '%s\n' "${PTK_POSITIONAL[@]}" | grep -Fx -- '--extensions' >/dev/null
printf '%s\n' "${PTK_POSITIONAL[@]}" | grep -Fx -- 'mkv,mp4' >/dev/null
printf '%s\n' "${PTK_POSITIONAL[@]}" | grep -Fx -- '--summary' >/dev/null
printf '%s\n' "${PTK_POSITIONAL[@]}" | grep -Fx -- '/media' >/dev/null
[[ "$PTK_DRY_RUN" -eq 1 ]]
[[ "$PTK_CONFIG_FILE" == "/tmp/duplicates.conf" ]]
echo "Command-specific options: OK"
