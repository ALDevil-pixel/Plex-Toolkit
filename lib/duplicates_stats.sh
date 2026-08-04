#!/usr/bin/env bash
# Statistics helpers

ptk_duplicates_stats() {
    local report="$1"
    local groups files

    groups=$(grep -c "^\[WARN\]" "$report" 2>/dev/null || echo 0)
    files=$(grep -c "^ -" "$report" 2>/dev/null || echo 0)

    echo "Duplicate groups : $groups"
    echo "Duplicate files  : $files"
}
