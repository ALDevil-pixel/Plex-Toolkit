#!/usr/bin/env bash
set -e

TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

mkdir -p "$TEST_ROOT/media"
cat > "$TEST_ROOT/library.conf" <<EOF
Movies="$TEST_ROOT/media"
EOF

source lib/exit_codes.sh
source lib/cli_errors.sh
source lib/cli_options.sh
source lib/logger.sh
source lib/library_audit.sh

ptk_parse_common_options --dry-run "$TEST_ROOT/library.conf"
test "$PTK_DRY_RUN" -eq 1

ptk_library_audit "$TEST_ROOT/library.conf" >/tmp/ptk-audit-test.out
grep "Movies" /tmp/ptk-audit-test.out >/dev/null

rm -f /tmp/ptk-audit-test.out
echo OK
