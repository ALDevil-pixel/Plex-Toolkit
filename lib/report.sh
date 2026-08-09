#!/usr/bin/env bash
# Reporting commun du Toolkit.

ptk_report_load_config() {
    local cfg="${PTK_REPORT_CONFIG:-config/report.conf}"

    if [[ ! -f "$cfg" ]]; then
        echo "[ERROR] Report configuration not found: $cfg" >&2
        return 1
    fi

    # shellcheck disable=SC1090
    source "$cfg"

    : "${REPORT_DIR:=./reports}"
    : "${AUDIT_TEXT_REPORT:=audit.log}"
    : "${AUDIT_JSON_REPORT:=audit.json}"
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
