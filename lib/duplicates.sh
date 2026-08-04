#!/usr/bin/env bash
# Incremental improvements for duplicate detection

ptk_file_hash() {
    local f="$1"
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$f" | awk '{print $1}'
    elif command -v shasum >/dev/null 2>&1; then
        shasum -a 256 "$f" | awk '{print $1}'
    else
        return 1
    fi
}

ptk_find_duplicates() {
    local deep=0 root="."
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --deep) deep=1 ;;
            *) root="$1" ;;
        esac
        shift
    done

    [[ -d "$root" ]] || { echo "[ERROR] Directory not found: $root"; return 1; }

    tmp=$(mktemp)
    find "$root" -type f -printf "%f|%s|%p\n" > "$tmp"

    if [[ $deep -eq 0 ]]; then
        awk -F'|' '{k=$1 FS $2; c[k]++; p[k]=p[k]"\n - "$3}
            END{for(i in c) if(c[i]>1){print "[WARN]",i,p[i]}}' "$tmp"
    else
        while IFS='|' read -r name size path; do
            hash=$(ptk_file_hash "$path" 2>/dev/null || echo "NOHASH")
            printf "%s|%s|%s|%s\n" "$hash" "$size" "$name" "$path"
        done < "$tmp" | awk -F'|' '{k=$1 FS $2; c[k]++; p[k]=p[k]"\n - "$4}
            END{for(i in c) if(c[i]>1){print "[WARN] HASH",i,p[i]}}'
    fi
    rm -f "$tmp"
}
