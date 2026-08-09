#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

test -f VERSION
test -f Makefile
test -f plex-toolkit
test -f config/defaults.conf
test -f lib/config.sh
test -f lib/plugin.sh
test -f lib/cli_options.sh
test -f lib/cli_errors.sh
test -f lib/exit_codes.sh
test -f lib/logger.sh

for command_file in audit check cleanup doctor duplicates help info inventory list rename self-check version; do
    test -f "commands/$command_file"
done

# Verify the common architecture is actually referenced.
grep -q 'ptk_load_config' lib/report.sh
grep -q 'ptk_load_config' lib/inventory_csv.sh
grep -q 'ptk_plugin_root' lib/plugin.sh
grep -q 'ptk_parse_common_options' commands/help
grep -q 'PTK_EXIT_USAGE' plex-toolkit

# Verify plugin tree.
for plugin in \
    plugins/anime/audit.sh \
    plugins/anime/rename.sh \
    plugins/movies/duplicates.sh \
    plugins/plex/verify.sh
do
    test -x "$plugin"
done

echo "Sprint 1.10.0 coherence: OK"
