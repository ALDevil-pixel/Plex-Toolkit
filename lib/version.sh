#!/usr/bin/env bash

ptk_version_show() {
    local version_file="${PTK_VERSION_FILE:-VERSION}"

    if [[ ! -f "$version_file" ]]; then
        echo "[ERROR] Version file not found: $version_file" >&2
        return 1
    fi

    local version
    version="$(head -n 1 "$version_file" | tr -d '[:space:]')"

    if [[ -z "$version" ]]; then
        echo "[ERROR] Version file is empty: $version_file" >&2
        return 1
    fi

    echo "$version"
    return 0
}
