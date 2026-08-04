#!/usr/bin/env bash
DRY_RUN=false;VERBOSE=false;QUIET=false;FORCE=false;POSITIONAL=()
parse_args(){ while (($#));do case "$1" in
--dry-run)DRY_RUN=true;;
--verbose)VERBOSE=true;;
--quiet)QUIET=true;;
--force)FORCE=true;;
--config)shift;export PLEXTK_CONFIG="$1";;
*)POSITIONAL+=("$1");;
esac;shift||true;done;}
