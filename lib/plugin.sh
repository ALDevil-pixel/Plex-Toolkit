#!/usr/bin/env bash
plugin_exists(){ [[ -x "$1" ]]; }
plugin_run(){ local p="$1"; shift; exec "$p" "$@"; }
