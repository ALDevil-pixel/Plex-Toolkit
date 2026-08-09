#!/usr/bin/env bash
# Validation des cibles de synchronisation local -> Plex.
# Aucune modification.

ptk_plex_sync_file_allowed() {
    local file="$1"
    local ext="${file##*.}"
    local allowed

    [[ -f "$file" ]] || {
        echo "[ERROR] File not found: $file" >&2
        return 1
    }

    [[ -r "$file" ]] || {
        echo "[ERROR] File is not readable: $file" >&2
        return 1
    }

    for allowed in $PLEX_SYNC_MOVIE_EXTENSIONS; do
        [[ "${allowed,,}" == "${ext,,}" ]] && return 0
    done

    echo "[ERROR] Unsupported media extension: $file" >&2
    return 1
}

ptk_plex_sync_root_allowed() {
    local file="$1"
    local root

    [[ -n "$PLEX_SYNC_ALLOWED_ROOTS" ]] || return 0

    for root in $PLEX_SYNC_ALLOWED_ROOTS; do
        root="${root%/}"
        [[ "$file" == "$root" || "$file" == "$root/"* ]] && return 0
    done

    echo "[ERROR] File is outside configured synchronization roots: $file" >&2
    return 1
}

ptk_plex_sync_validate_file() {
    local file="$1"

    ptk_plex_sync_file_allowed "$file" || return $?
    ptk_plex_sync_root_allowed "$file" || return $?

    [[ -L "$file" ]] && {
        echo "[ERROR] Symbolic links are not valid synchronization targets: $file" >&2
        return 1
    }

    return 0
}

ptk_plex_sync_validate_library() {
    local library_key="$1"

    ptk_plex_library_exists "$library_key" || {
        echo "[ERROR] Plex library not found: $library_key" >&2
        return 1
    }

    ptk_plex_confirm_library_type "$library_key" "movie"
}

ptk_plex_sync_validate_library_path() {
    local file="$1"
    local library_key="$2"

    command -v realpath >/dev/null 2>&1 || {
        echo "[ERROR] realpath is required for Plex path validation." >&2
        return 2
    }

    local real_file real_dir
    real_file="$(realpath -- "$file")" || return 1
    real_dir="$(realpath -- "$(dirname "$real_file")")" || return 1

    local location location_real
    local found=0

    while IFS= read -r location; do
        [[ -n "$location" ]] || continue
        location_real="$(realpath -m -- "$location" 2>/dev/null || true)"
        [[ -n "$location_real" ]] || continue

        if [[ "$real_file" == "$location_real/"* || "$real_file" == "$location_real" ]]; then
            found=1
            break
        fi
    done < <(ptk_plex_library_locations "$library_key")

    (( found == 1 )) || {
        echo "[ERROR] File is outside Plex library locations: $real_file" >&2
        return 1
    }

    printf '%s\n' "$real_dir"
}
