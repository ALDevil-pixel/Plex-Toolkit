#!/usr/bin/env bash
# Read-only comparison of two inventory files.
# Record format:
# name|extension|size|mtime|hash|path

ptk_inventory_compare_records() {
    local old_file="$1"
    local new_file="$2"

    [[ -f "$old_file" && -f "$new_file" ]] || {
        echo "[ERROR] Inventory input file missing." >&2
        return 1
    }

    local tmp_old tmp_new tmp_matched_new
    tmp_old="$(mktemp)"
    tmp_new="$(mktemp)"
    tmp_matched_new="$(mktemp)"
    trap 'rm -f -- "$tmp_old" "$tmp_new" "$tmp_matched_new"' RETURN

    awk -F'|' 'NF >= 6 {print $0}' "$old_file" > "$tmp_old"
    awk -F'|' 'NF >= 6 {print $0}' "$new_file" > "$tmp_new"

    echo "Status|Old path|New path|Name|Old size|New size|Identity"

    while IFS='|' read -r old_name old_ext old_size old_mtime old_hash old_path; do
        [[ -n "$old_name" ]] || continue

        local new_record=""
        local new_name new_ext new_size new_mtime new_hash new_path
        local identity
        identity="$(ptk_inventory_identity "$old_name" "$old_size" "$old_hash")"

        # First prefer the same path.
        while IFS='|' read -r c_name c_ext c_size c_mtime c_hash c_path; do
            [[ -n "$c_name" ]] || continue
            grep -Fqx "$c_path" "$tmp_matched_new" && continue
            if [[ "$old_path" == "$c_path" ]]; then
                new_record="$c_name|$c_ext|$c_size|$c_mtime|$c_hash|$c_path"
                break
            fi
        done < "$tmp_new"

        # If the path changed, use the stable identity.
        if [[ -z "$new_record" ]]; then
            while IFS='|' read -r c_name c_ext c_size c_mtime c_hash c_path; do
                [[ -n "$c_name" ]] || continue
                grep -Fqx "$c_path" "$tmp_matched_new" && continue
                local candidate_identity
                candidate_identity="$(ptk_inventory_identity "$c_name" "$c_size" "$c_hash")"
                if [[ "$identity" == "$candidate_identity" ]]; then
                    new_record="$c_name|$c_ext|$c_size|$c_mtime|$c_hash|$c_path"
                    break
                fi
            done < "$tmp_new"
        fi

        if [[ -n "$new_record" ]]; then
            IFS='|' read -r new_name new_ext new_size new_mtime new_hash new_path <<< "$new_record"
            printf '%s\n' "$new_path" >> "$tmp_matched_new"

            if [[ "$old_path" == "$new_path" &&
                  "$old_size" == "$new_size" &&
                  "$old_mtime" == "$new_mtime" &&
                  "$old_hash" == "$new_hash" ]]; then
                printf 'UNCHANGED|%s|%s|%s|%s|%s|%s\n' \
                    "$old_path" "$new_path" "$old_name" "$old_size" "$new_size" "$identity"
            else
                printf 'CHANGED|%s|%s|%s|%s|%s|%s\n' \
                    "$old_path" "$new_path" "$old_name" "$old_size" "$new_size" "$identity"
            fi
        else
            printf 'REMOVED|%s|-|%s|%s|-|%s\n' \
                "$old_path" "$old_name" "$old_size" "$identity"
        fi
    done < "$tmp_old"

    while IFS='|' read -r new_name new_ext new_size new_mtime new_hash new_path; do
        [[ -n "$new_name" ]] || continue
        if ! grep -Fqx "$new_path" "$tmp_matched_new"; then
            identity="$(ptk_inventory_identity "$new_name" "$new_size" "$new_hash")"
            printf 'ADDED|-|%s|%s|-|%s|%s\n' \
                "$new_path" "$new_name" "$new_size" "$identity"
        fi
    done < "$tmp_new"

    trap - RETURN
    rm -f -- "$tmp_old" "$tmp_new" "$tmp_matched_new"
}
