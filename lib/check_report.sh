#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/check_logger.sh"

ptk_check_report() {
    local path="$1"

    local files zero invalid
    files=$(find "$path" -type f 2>/dev/null | wc -l)
    zero=$(find "$path" -type f -size 0 2>/dev/null | wc -l)
    invalid=$(find "$path" -type f | grep -E '\.(avi|wmv|flv|mov)$' | wc -l)

    ptk_check_log INFO "Files scanned: $files"
    ptk_check_log INFO "Zero-byte files: $zero"
    ptk_check_log INFO "Invalid extensions: $invalid"

    cat <<EOF
========== Check Summary ==========
Files scanned      : $files
Zero-byte files    : $zero
Invalid extensions : $invalid
===================================
EOF
}
