#!/usr/bin/env bash
# Export duplicate report to CSV

ptk_export_duplicates_csv() {
    local input="$1"
    local output="${2:-logs/duplicates.csv}"

    mkdir -p "$(dirname "$output")"
    echo "status,file" > "$output"

    awk '
    /^\[WARN\]/ {next}
    /^ - / {
        gsub(/^ - /,"",$0)
        print "duplicate,\"" $0 "\""
    }' "$input" >> "$output"

    echo "CSV exported to: $output"
}
