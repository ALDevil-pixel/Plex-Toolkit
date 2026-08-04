#!/usr/bin/env bash
ptk_report_summary() {
    local json="$1"
    mkdir -p logs
    if [[ "$json" == "1" ]]; then
cat <<EOF | tee logs/audit.json
{"status":"ok","message":"Audit completed"}
EOF
    else
        echo "Audit completed" | tee logs/audit.log
    fi
}
