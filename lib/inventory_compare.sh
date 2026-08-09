#!/usr/bin/env bash
# Read-only comparison of two inventory records.

ptk_inventory_compare_records() {
    local old_file="$1"
    local new_file="$2"

    [[ -f "$old_file" && -f "$new_file" ]] || {
        echo "[ERROR] Inventory input file missing." >&2
        return 1
    }

    local tmp_old tmp_new
    tmp_old="$(mktemp)"
    tmp_new="$(mktemp)"
    trap 'rm -f -- "$tmp_old" "$tmp_new"' RETURN

    awk -F'|' 'NF >= 6 {print $1 "|" $2 "|" $3 "|" $4 "|" $5 "|" $6}' \
        "$old_file" | sort -t'|' -k5,5 -k1,1 > "$tmp_old"

    awk -F'|' 'NF >= 6 {print $1 "|" $2 "|" $3 "|" $4 "|" $5 "|" $6}' \
        "$new_file" | sort -t'|' -k5,5 -k1,1 > "$tmp_new"

    echo "Status|Old path|New path|Name|Old size|New size|Identity"

    # Compare records using hash when available, otherwise name + size.
    while IFS='|' read -r old_name old_ext old_size old_mtime old_hash old_path; do
        [[ -n "$old_name" ]] || continue

        local identity
        identity="$(ptk_inventory_identity "$old_name" "$old_size" "$old_hash")"

        local match=""
        while IFS='|' read -r new_name new_ext new_size new_mtime new_hash new_path; do
            [[ -n "$new_name" ]] || continue
            local new_identity
            new_identity="$(ptk_inventory_identity "$new_name" "$new_size" "$new_hash")"
            if [[ "$identity" == "$new_identity" ]]; then
                match="$new_name|$new_ext|$new_size|$new_mtime|$new_hash|$new_path"
                break
            fi
        done < "$tmp_new"

        if [[ -n "$match" ]]; then
            IFS='|' read -r new_name new_ext new_size new_mtime new_hash new_path <<< "$match"
            if [[ "$old_path" == "$new_path" && "$old_size" == "$new_size" && "$old_mtime" == "$new_mtime" ]]; then
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

        local identity
        identity="$(ptk_inventory_identity "$new_name" "$new_size" "$new_hash")"

        if ! awk -F'|' -v identity="$identity" '
            {
                name=$1; size=$3; hash=$5;
                current=(hash != "" ? "hash:" hash : "name-size:" name "|" size)
                if (current == identity) found=1
            }
            END { exit(found ? 0 : 1) }
        ' "$tmp_old"; then
            printf 'ADDED|-|%s|%s|-|%s|%s\n' \
                "$new_path" "$new_name" "$new_size" "$identity"
        fi
    done < "$tmp_new"

    trap - RETURN
    rm -f -- "$tmp_old" "$tmp_new"
}
