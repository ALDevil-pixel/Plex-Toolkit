#!/usr/bin/env bash

_check_cmd() {
  command -v "$1" >/dev/null 2>&1
}

_emit_text() {
  local ok=0 warn=0
  for c in bash ffmpeg ffprobe HandBrakeCLI mediainfo jq curl git python3; do
    if _check_cmd "$c"; then
      printf "[ OK ] %-12s\n" "$c"; ok=$((ok+1))
    else
      printf "[WARN] %-12s missing\n" "$c"; warn=$((warn+1))
    fi
  done
  echo
  echo "Directories:"
  for d in config commands plugins tests logs docs; do
    if [[ -d "$d" ]]; then
      printf "[ OK ] %s\n" "$d"
    else
      printf "[WARN] %s missing\n" "$d"; warn=$((warn+1))
    fi
  done
  echo
  echo "Summary"
  echo "Success : $ok"
  echo "Warning : $warn"
}

_emit_json() {
cat <<EOF
{
  "bash": "$(_check_cmd bash && echo installed || echo missing)",
  "ffmpeg": "$(_check_cmd ffmpeg && echo installed || echo missing)",
  "ffprobe": "$(_check_cmd ffprobe && echo installed || echo missing)",
  "jq": "$(_check_cmd jq && echo installed || echo missing)"
}
EOF
}

ptk_doctor_run() {
  if [[ "$1" == "json" ]]; then
    _emit_json
  else
    _emit_text
  fi
}
