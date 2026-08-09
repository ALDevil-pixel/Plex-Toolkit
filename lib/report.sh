#!/usr/bin/env bash
# Reporting commun du Toolkit.

ptk_report_load_config() {
    local cfg="${PTK_REPORT_CONFIG:-config/report.conf}"

    source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
    ptk_load_config "$cfg" || return 1

    : "${AUDIT_TEXT_REPORT:=${PTK_AUDIT_TEXT_REPORT}}"
    : "${AUDIT_JSON_REPORT:=${PTK_AUDIT_JSON_REPORT}}"
    REPORT_DIR="${PTK_REPORT_DIR}"
}

ptk_report_init() {
    ptk_report_load_config || return 1

    mkdir -p "$REPORT_DIR" || {
        echo "[ERROR] Unable to create report directory: $REPORT_DIR" >&2
        return 1
    }
}

ptk_report_summary() {
    local json="${1:-0}"

    ptk_report_init || return 1

    if [[ "$json" == "1" ]]; then
        local target="$REPORT_DIR/$AUDIT_JSON_REPORT"
        cat > "$target" <<'EOF'
{"status":"ok","message":"Audit completed"}
EOF
        cat "$target"
    else
        local target="$REPORT_DIR/$AUDIT_TEXT_REPORT"
        printf '%s\n' "Audit completed" | tee "$target"
    fi
}
