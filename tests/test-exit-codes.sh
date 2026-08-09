#!/usr/bin/env bash
set -e

source lib/exit_codes.sh

ptk_is_valid_exit_code 0
ptk_is_valid_exit_code 1
ptk_is_valid_exit_code 2

if ptk_is_valid_exit_code 3; then
    exit 1
fi

ptk_return 0
test "$?" -eq 0

if ptk_return 1; then
    exit 1
else
    test "$?" -eq 1
fi

if ptk_return 2; then
    exit 1
else
    test "$?" -eq 2
fi

echo OK
