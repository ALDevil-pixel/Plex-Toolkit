#!/usr/bin/env bash
# Inventory statistics

ptk_inventory_stats() {
    local input="$1"

    awk -F'|' '
    {
        count++
        size+=$3
        ext[$2]++
    }
    END{
        print "========== Inventory Summary =========="
        print "Files :",count
        print "Total size (bytes):",size
        print "Average size (bytes):",(count?int(size/count):0)
        print ""
        print "Extensions:"
        for(e in ext)
            printf(" - %s : %d\n",e,ext[e])
        print "======================================="
    }' "$input"
}
