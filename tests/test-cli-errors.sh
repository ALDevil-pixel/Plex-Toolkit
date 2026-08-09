#!/usr/bin/env bash
set -e

source lib/exit_codes.sh
source lib/cli_errors.sh

ptk_require_directory /tmp
test "$?" -eq 0

if ptk_require_directory /path/that/does/not/exist; then
    exit 1
else
    test "$?" -eq 1
fi

echo OK
