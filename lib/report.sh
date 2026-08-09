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

ptk_report_write_atomic() {
    local target="$1"
    local content="$2"
    local directory
    local tmp

    directory="$(dirname "$target")"
    mkdir -p "$directory" || return 1

    tmp="$(mktemp "$directory/.ptk-report.XXXXXX")" || {
        echo "[ERROR] Unable to create temporary report: $target" >&2
        return 1
    }

    if ! printf '%s\n' "$content" > "$tmp"; then
        rm -f -- "$tmp"
        return 1
    fi

    if ! mv -f -- "$tmp" "$target"; then
        rm -f -- "$tmp"
        echo "[ERROR] Unable to replace report: $target" >&2
        return 1
    fi

    return 0
}

ptk_report_summary() {
    local json="${1:-0}"

    ptk_report_init || return 1

    if [[ "$json" == "1" ]]; then
        local target="$REPORT_DIR/$AUDIT_JSON_REPORT"
        local content='{"status":"ok","message":"Audit completed"}'

        ptk_report_write_atomic "$target" "$content" || return 1
        cat "$target"
    else
        local target="$REPORT_DIR/$AUDIT_TEXT_REPORT"
        ptk_report_write_atomic "$target" "Audit completed" || return 1
        cat "$target"
    fi
}
