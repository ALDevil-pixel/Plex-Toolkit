#!/usr/bin/env bash
# Validation des cibles qui pourraient être utilisées par une future
# synchronisation local -> Plex. Aucune modification.

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

    # Refuse obvious special files even if the filesystem reports them as readable.
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
