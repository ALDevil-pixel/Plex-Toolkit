#!/usr/bin/env bash
set -e

source lib/plugin.sh

test -n "$(ptk_plugin_root)"
test -f "$(ptk_plugin_path anime audit)"
test -f "$(ptk_plugin_path anime rename)"
test -f "$(ptk_plugin_path movies duplicates)"
test -f "$(ptk_plugin_path plex verify)"

ptk_plugin_exists anime audit
ptk_plugin_exists anime rename
ptk_plugin_exists movies duplicates
ptk_plugin_exists plex verify

listed="$(ptk_plugin_list)"
grep -qx 'anime/audit.sh' <<<"$listed"
grep -qx 'anime/rename.sh' <<<"$listed"
grep -qx 'movies/duplicates.sh' <<<"$listed"
grep -qx 'plex/verify.sh' <<<"$listed"

ptk_plugin_run anime audit >/tmp/ptk-plugin-test.out
grep 'not implemented yet' /tmp/ptk-plugin-test.out >/dev/null

if ptk_plugin_run does-not-exist plugin >/dev/null 2>&1; then
    exit 1
else
    test "$?" -eq 1
fi

rm -f /tmp/ptk-plugin-test.out
echo OK
