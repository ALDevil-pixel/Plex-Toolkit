#!/usr/bin/env bash
set -e

source lib/common.sh
source lib/args.sh
source lib/cli.sh
source lib/errors.sh
source lib/validation.sh

ptk_require_command bash
require_command bash

parse_args --dry-run --verbose --quiet --force --config test.conf -- sample
test "$DRY_RUN" = true
test "$VERBOSE" = true
test "$QUIET" = true
test "$FORCE" = true
test "$PLEXTK_CONFIG" = "test.conf"
test "${POSITIONAL[0]}" = "sample"

if ptk_dispatch does-not-exist >/dev/null 2>&1; then
    exit 1
else
    test "$?" -eq 2
fi

if fatal "test" >/dev/null 2>&1; then
    :
else
    test "$?" -eq 1
fi

echo OK
