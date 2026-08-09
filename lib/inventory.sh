#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/inventory_metadata.sh"
source "$(dirname "${BASH_SOURCE[0]}")/inventory_csv.sh"
source "$(dirname "${BASH_SOURCE[0]}")/inventory_json.sh"
source "$(dirname "${BASH_SOURCE[0]}")/inventory_stats.sh"
source "$(dirname "${BASH_SOURCE[0]}")/library_loader.sh"

ptk_inventory_load_config() {
    local config_file="${1:-config/inventory.conf}"

    source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
    ptk_load_config "$config_file" || return 1

    : "${REPORT_DIR:=./reports}"
    : "${INVENTORY_CSV_REPORT:=inventory.csv}"
    : "${INVENTORY_JSON_REPORT:=inventory.json}"
    : "${INVENTORY_LOG:=inventory.log}"
    : "${INVENTORY_FOLLOW_SYMLINKS:=false}"
    : "${INVENTORY_INCLUDE_HIDDEN:=true}"
    : "${INVENTORY_HASH_ENABLED:=false}"
    : "${INVENTORY_HASH_ALGORITHM:=sha256}"

    ptk_config_bool "$INVENTORY_FOLLOW_SYMLINKS" >/dev/null || return 1
    ptk_config_bool "$INVENTORY_INCLUDE_HIDDEN" >/dev/null || return 1
    ptk_config_bool "$INVENTORY_HASH_ENABLED" >/dev/null || return 1

    case "${INVENTORY_HASH_ALGORITHM,,}" in
        sha256|md5) ;;
        *) echo "[ERROR] Unsupported inventory hash algorithm: $INVENTORY_HASH_ALGORITHM" >&2; return 1 ;;
    esac
}

ptk_inventory_find_files() {
    local path="$1"
    local -a find_args=("$path")

    if [[ "$INVENTORY_FOLLOW_SYMLINKS" == "true" ]]; then
        find_args+=("-L")
    fi

    if [[ "$INVENTORY_INCLUDE_HIDDEN" != "true" ]]; then
        find_args+=("-not" "-path" "$path/.*" "-not" "-path" "*/.*/*")
    fi

    find "${find_args[@]}" -type f -print0
}

ptk_inventory_library() {
    local path="$1"
    [[ -d "$path" ]] || return 1

    mkdir -p -- "$REPORT_DIR" || return 1

    local tmp
    tmp="$(mktemp)"
    trap 'rm -f -- "$tmp"' RETURN

    while IFS= read -r -d '' file; do
        ptk_inventory_metadata "$file" >> "$tmp" || return $?
    done < <(ptk_inventory_find_files "$path")

    ptk_inventory_export_csv "$tmp" || return $?
    ptk_inventory_export_json "$tmp" || return $?
    ptk_inventory_stats "$tmp" || return $?

    trap - RETURN
    rm -f -- "$tmp"
}

ptk_inventory() {
    local target="${1:-}"

    if [[ -n "$target" ]]; then
        ptk_inventory_library "$target"
        return $?
    fi

    while IFS='|' read -r name path; do
        [[ -n "$name" && -n "$path" ]] || continue
        echo "== $name =="
        ptk_inventory_library "$path" || return $?
    done < <(ptk_load_libraries)
}
