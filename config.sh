#!/usr/bin/env bash
load_config(){
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.."&&pwd)"
CFG="${PLEXTK_CONFIG:-$ROOT/config/library.conf}"
[[ -f "$CFG" ]] || fatal "Missing config: $CFG"
# shellcheck source=/dev/null
source "$CFG"
}
