#!/usr/bin/env bash

ptk_help_show() {
    local command="${1:-}"

    case "$command" in
        "")
            cat <<'EOF'
Plex Toolkit Help

Usage:
  plex-toolkit <command> [options]

Main commands:
  audit
  check
  cleanup
  doctor
  duplicates
  info
  inventory
  list
  rename
  self-check
  version

Use:
  plex-toolkit help <command>
for command-specific help.
EOF
            ;;
        *)
            local doc="docs/CLI.md"
            if [[ -f "$doc" ]]; then
                echo "Plex Toolkit - $command"
                echo
                grep -A 20 -E "^# $command$|^## $command$" "$doc" || {
                    echo "No dedicated help is available for: $command"
                    return 1
                }
            else
                echo "[ERROR] Documentation file not found: $doc" >&2
                return 1
            fi
            ;;
    esac
}
