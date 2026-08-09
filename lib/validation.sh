#!/usr/bin/env bash
# Legacy configuration validation compatibility layer.
#
# New code should use lib/config.sh.

validate_config() {
    local root="${ROOT:-${PTK_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}}"
    local missing=0

    for file in library.conf anime.yaml movies.yaml collections.yaml plex.yaml library.yaml; do
        if [[ ! -f "$root/config/$file" ]]; then
            printf '[ERROR] Missing configuration: %s\n' "$file" >&2
            missing=1
        fi
    done

    return "$missing"
}
