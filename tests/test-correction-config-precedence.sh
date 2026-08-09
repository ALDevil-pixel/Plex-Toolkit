#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

source "$ROOT/lib/cli_errors.sh"
source "$ROOT/lib/cli_options.sh"
source "$ROOT/lib/config.sh"

cat > "$TMP/defaults.conf" <<'EOF'
PTK_VERBOSE=false
PTK_QUIET=false
EOF

ptk_parse_common_options --config "$TMP/defaults.conf" --verbose
ptk_load_config "$TMP/defaults.conf"
ptk_finalize_config_with_cli
[[ "$PTK_VERBOSE" -eq 1 ]]

ptk_parse_common_options --config "$TMP/defaults.conf" --quiet
ptk_load_config "$TMP/defaults.conf"
ptk_finalize_config_with_cli
[[ "$PTK_QUIET" -eq 1 ]]

ptk_parse_common_options --config "$TMP/defaults.conf" --fix
ptk_load_config "$TMP/defaults.conf"
ptk_finalize_config_with_cli
[[ "$PTK_DRY_RUN" -eq 0 ]]

ptk_parse_common_options --config "$TMP/defaults.conf" --dry-run
ptk_load_config "$TMP/defaults.conf"
ptk_finalize_config_with_cli
[[ "$PTK_DRY_RUN" -eq 1 ]]

echo "Correction config precedence: OK"
