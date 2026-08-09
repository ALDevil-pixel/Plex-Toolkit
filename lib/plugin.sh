#!/usr/bin/env bash
# Plugin discovery and execution helpers.

ptk_plugin_root() {
    printf '%s\n' "${PTK_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../plugins" && pwd)}"
}

ptk_plugin_path() {
    local category="${1:-}"
    local name="${2:-}"

    if [[ -z "$category" || -z "$name" ]]; then
        printf '[ERROR] Plugin category and name are required.\n' >&2
        return 2
    fi

    printf '%s/%s/%s.sh\n' "$(ptk_plugin_root)" "$category" "$name"
}

ptk_plugin_exists() {
    local plugin
    plugin="$(ptk_plugin_path "$1" "$2")" || return $?

    [[ -f "$plugin" && -x "$plugin" ]]
}

plugin_exists() {
    if [[ $# -eq 1 ]]; then
        [[ -f "$1" && -x "$1" ]]
        return $?
    fi
    ptk_plugin_exists "$@"
}

ptk_plugin_list() {
    local root
    root="$(ptk_plugin_root)"

    [[ -d "$root" ]] || return 0

    find "$root" -mindepth 2 -maxdepth 2 -type f -name '*.sh' -perm -u+x \
        -printf '%P\n' 2>/dev/null | sort
}

ptk_plugin_run() {
    local category="${1:-}"
    local name="${2:-}"
    shift 2 || true

    local plugin
    plugin="$(ptk_plugin_path "$category" "$name")" || return $?

    if [[ ! -f "$plugin" ]]; then
        printf '[ERROR] Plugin not found: %s/%s\n' "$category" "$name" >&2
        return 1
    fi

    if [[ ! -x "$plugin" ]]; then
        printf '[ERROR] Plugin is not executable: %s\n' "$plugin" >&2
        return 1
    fi

    "$plugin" "$@"
}

plugin_run() {
    local plugin="${1:-}"
    shift || true

    [[ -n "$plugin" ]] || {
        printf '[ERROR] Plugin path is required.\n' >&2
        return 2
    }

    [[ -f "$plugin" ]] || {
        printf '[ERROR] Plugin not found: %s\n' "$plugin" >&2
        return 1
    }

    [[ -x "$plugin" ]] || {
        printf '[ERROR] Plugin is not executable: %s\n' "$plugin" >&2
        return 1
    }

    "$plugin" "$@"
}
