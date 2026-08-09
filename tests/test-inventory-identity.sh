#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT/lib/inventory_metadata.sh"
source "$ROOT/lib/inventory_identity.sh"

record='Film.mkv|mkv|123|2026-08-09 20:00:00|abcdef0123456789|/media/Film.mkv'

identity="$(ptk_inventory_metadata_identity "$record")"
[[ "$identity" == "hash:abcdef0123456789" ]]

identity="$(ptk_inventory_identity "Film.mkv" "123" "")"
[[ "$identity" == "name-size:Film.mkv|123" ]]

identity="$(ptk_inventory_identity "Other.mkv" "123" "")"
[[ "$identity" == "name-size:Other.mkv|123" ]]

echo OK
