#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/check_zero_size.sh"
source "$(dirname "${BASH_SOURCE[0]}")/check_extensions.sh"
source "$(dirname "${BASH_SOURCE[0]}")/check_report.sh"
source "$(dirname "${BASH_SOURCE[0]}")/check_fix.sh"
source "$(dirname "${BASH_SOURCE[0]}")/library_loader.sh"

ptk_check_library() {
    local p="$1"
    [[ -d "$p" ]] || return 1

    echo "== Checking: $p =="

    find "$p" -type f -print0 |
    while IFS= read -r -d '' f; do
        echo "[CHECK] $f"
    done

    ptk_find_zero_size_files "$p"
    ptk_find_invalid_extensions "$p"
    ptk_check_report "$p"
}

ptk_check_fix_library() {
    local p="$1"
    local dry="${2:-1}"

    [[ -d "$p" ]] || return 1

    echo "== Check Fix: $p =="

    # Les fichiers de 0 octet peuvent être supprimés sans ambiguïté.
    ptk_check_fix_zero_size "$p" "$dry"

    # Une extension incorrecte ne doit pas être renommée ou supprimée
    # automatiquement : l'extension ne permet pas de déterminer le codec réel.
    ptk_find_invalid_extensions "$p"
}

ptk_check() {
    local target="${1:-}"
    local dry=1

    if [[ "$target" == "--fix" ]]; then
        dry=0
        shift
        target="${1:-}"
    elif [[ "$target" == "--dry-run" ]]; then
        dry=1
        shift
        target="${1:-}"
    fi

    if [[ -n "$target" ]]; then
        if [[ "$dry" -eq 0 ]]; then
            ptk_check_fix_library "$target" "$dry"
        else
            ptk_check_library "$target"
        fi
        return $?
    fi

    while IFS='|' read -r name path; do
        [[ -n "$name" && -n "$path" ]] || continue
        echo "== $name =="

        if [[ "$dry" -eq 0 ]]; then
            ptk_check_fix_library "$path" "$dry" || return $?
        else
            ptk_check_library "$path" || return $?
        fi
    done < <(ptk_load_libraries)
}
