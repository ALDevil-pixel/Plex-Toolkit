#!/usr/bin/env bash
set -e

TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

mkdir -p "$TEST_ROOT/A" "$TEST_ROOT/B"
printf 'same content\n' > "$TEST_ROOT/A/movie.mkv"
cp "$TEST_ROOT/A/movie.mkv" "$TEST_ROOT/B/movie.mkv"

# The command wrapper must pass command-specific options to the engine.
# Source the wrapper in isolation with a stub summary function.
source lib/exit_codes.sh
source lib/cli_errors.sh
source lib/cli_options.sh
source lib/logger.sh
source lib/duplicates.sh
source lib/duplicates_summary.sh
source commands/duplicates

cmd_duplicates --deep --dry-run "$TEST_ROOT" >/tmp/ptk-duplicates-cli.out
grep "DUPLICATE" /tmp/ptk-duplicates-cli.out >/dev/null

test -f "$TEST_ROOT/A/movie.mkv"
test -f "$TEST_ROOT/B/movie.mkv"

rm -f /tmp/ptk-duplicates-cli.out
echo OK
