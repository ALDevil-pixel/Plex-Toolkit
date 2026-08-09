#!/usr/bin/env bash
set -e

test -f Makefile
grep -E '^test:' Makefile >/dev/null
grep -E '^lint:' Makefile >/dev/null
grep -E '^validate:' Makefile >/dev/null
grep -E '^install:' Makefile >/dev/null

echo OK
