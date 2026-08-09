#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOL="$ROOT/plex-toolkit"

version="$("$TOOL" version)"
test -n "$version"

"$TOOL" help >/tmp/ptk-dispatch-help.out
grep "Plex Toolkit Help" /tmp/ptk-dispatch-help.out >/dev/null

"$TOOL" self-check >/tmp/ptk-dispatch-self-check.out
grep "Self-check OK" /tmp/ptk-dispatch-self-check.out >/dev/null

if "$TOOL" command-that-does-not-exist >/tmp/ptk-dispatch-unknown.out 2>&1; then
    exit 1
else
    test "$?" -eq 2
fi

rm -f /tmp/ptk-dispatch-help.out /tmp/ptk-dispatch-self-check.out /tmp/ptk-dispatch-unknown.out
echo OK
