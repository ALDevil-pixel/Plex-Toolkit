#!/usr/bin/env bash
# Summary report

ptk_check_report() {
    local path="$1"

    local files zero invalid

    files=$(find "$path" -type f 2>/dev/null | wc -l)
    zero=$(find "$path" -type f -size 0 2>/dev/null | wc -l)
    invalid=$(find "$path" -type f | grep -E '\.(avi|wmv|flv|mov)$' | wc -l)

    cat <<EOF
========== Check Summary ==========
Files scanned      : $files
Zero-byte files    : $zero
Invalid extensions : $invalid
===================================
EOF
}
