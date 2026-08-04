#!/usr/bin/env bash
# Duplicate detection by filename and size

ptk_find_duplicates() {
    local root="$1"
    [[ -d "$root" ]] || {
        echo "[ERROR] Directory not found: $root"
        return 1
    }

    echo "Scanning: $root"
    find "$root" -type f -printf "%f|%s|%p\n" \
    | sort \
    | awk -F'|' '
    {
        key=$1 "|" $2
        files[key]=files[key] "\n  - " $3
        count[key]++
    }
    END {
        dup=0
        for (k in count) {
            if (count[k] > 1) {
                dup++
                split(k,a,"|")
                printf("[WARN] Duplicate: %s (%s bytes)%s\n\n",a[1],a[2],files[k])
            }
        }
        printf("Summary: %d duplicate group(s)\n",dup)
    }'
}
