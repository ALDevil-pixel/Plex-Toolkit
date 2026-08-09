#!/usr/bin/env bash
# Protections communes pour les futures actions Plex.
# Ce module ne réalise aucune action destructive.

ptk_plex_validate_action_target() {
    local local_root="$1"
    local library_key="$2"

    [[ -d "$local_root" ]] || {
        echo "[ERROR] Local target directory not found: $local_root" >&2
        return 1
    }

    [[ "$library_key" =~ ^[0-9]+$ ]] || {
        echo "[ERROR] Invalid Plex library key: $library_key" >&2
        return 2
    }

    return 0
}

ptk_plex_confirm_library_type() {
    local library_key="$1"
    local expected_type="$2"

    local actual
    actual="$(ptk_plex_list_libraries |
        awk -F '\t' -v wanted="$library_key" '$1 == wanted {print $2; exit}')"

    [[ -n "$actual" ]] || {
        echo "[ERROR] Plex library not found: $library_key" >&2
        return 1
    }

    [[ "${actual,,}" == "${expected_type,,}" ]] || {
        echo "[ERROR] Plex library '$library_key' is type '$actual', expected '$expected_type'." >&2
        return 1
    }

    return 0
}

ptk_plex_action_allowed() {
    # Future destructive actions must explicitly opt in.
    ptk_is_fix_enabled || {
        echo "[ERROR] Destructive Plex actions require --fix." >&2
        return 2
    }

    return 0
}
