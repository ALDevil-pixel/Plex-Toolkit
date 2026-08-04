#!/usr/bin/env bash
# Build cleanup recommendations from duplicate report

ptk_cleanup_report() {
    local input="$1"
    local output="${2:-logs/duplicates-cleanup.txt}"

    mkdir -p "$(dirname "$output")"

    {
        echo "Plex-Toolkit Duplicate Cleanup Report"
        echo "Generated: $(date)"
        echo
        awk '
            /^\[WARN\]/ {print; next}
            /^ - / {files[++n]=$0}
            END {
                if (n>0) {
                    print ""
                    print "Recommendation:"
                    print " KEEP :", files[1]
                    for(i=2;i<=n;i++) print " REMOVE:", files[i]
                } else {
                    print "No duplicate candidates found."
                }
            }' "$input"
    } > "$output"

    echo "Cleanup report written to: $output"
}
