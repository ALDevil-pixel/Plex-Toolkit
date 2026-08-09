#!/usr/bin/env bash
# Display helpers.
#
# The public color variables are retained for compatibility with older
# modules. New code should prefer the logger and CLI display helpers.

source "$(dirname "${BASH_SOURCE[0]}")/terminal.sh"
source "$(dirname "${BASH_SOURCE[0]}")/colors.sh"

ptk_display_init() {
    ptk_apply_colors
}

ptk_display_info() {
    printf '%s[INFO]%s %s\n' "${C_BLUE:-}" "${C_RESET:-}" "$*"
}

ptk_display_success() {
    printf '%s[ OK ]%s %s\n' "${C_GREEN:-}" "${C_RESET:-}" "$*"
}

ptk_display_warn() {
    printf '%s[WARN]%s %s\n' "${C_YELLOW:-}" "${C_RESET:-}" "$*"
}

ptk_display_error() {
    printf '%s[ERROR]%s %s\n' "${C_RED:-}" "${C_RESET:-}" "$*" >&2
}

ptk_display_init
