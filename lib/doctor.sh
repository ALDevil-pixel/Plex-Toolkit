#!/usr/bin/env bash

_check_cmd() {
    command -v "$1" >/dev/null 2>&1
}

_doctor_command_status() {
    local command_name="$1"

    if _check_cmd "$command_name"; then
        echo "installed"
    else
        echo "missing"
    fi
}

_emit_text() {
    local ok=0 warn=0

    for c in bash ffmpeg ffprobe HandBrakeCLI mediainfo jq curl git python3; do
        if _check_cmd "$c"; then
            printf "[ OK ] %-12s\n" "$c"
            ok=$((ok+1))
        else
            printf "[WARN] %-12s missing\n" "$c"
            warn=$((warn+1))
        fi
    done

    echo
    echo "Directories:"

    for d in config commands plugins tests logs docs; do
        if [[ -d "$d" ]]; then
            printf "[ OK ] %s\n" "$d"
            ok=$((ok+1))
        else
            printf "[WARN] %s missing\n" "$d"
            warn=$((warn+1))
        fi
    done

    echo
    echo "Summary"
    echo "Success : $ok"
    echo "Warning : $warn"

    # Doctor completed successfully even when optional tools/directories
    # are missing: these are diagnostics, not execution failures.
    return 0
}

_emit_json() {
    cat <<EOF
{
  "bash": "$(_doctor_command_status bash)",
  "ffmpeg": "$(_doctor_command_status ffmpeg)",
  "ffprobe": "$(_doctor_command_status ffprobe)",
  "HandBrakeCLI": "$(_doctor_command_status HandBrakeCLI)",
  "mediainfo": "$(_doctor_command_status mediainfo)",
  "jq": "$(_doctor_command_status jq)",
  "curl": "$(_doctor_command_status curl)",
  "git": "$(_doctor_command_status git)",
  "python3": "$(_doctor_command_status python3)"
}
EOF
    return 0
}

ptk_doctor_run() {
    case "${1:-text}" in
        text)
            _emit_text
            ;;
        json)
            _emit_json
            ;;
        *)
            echo "[ERROR] Unsupported doctor format: $1" >&2
            return 2
            ;;
    esac
}
