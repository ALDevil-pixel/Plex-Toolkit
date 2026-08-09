#!/usr/bin/env bash
# Centralized terminal colors.
#
# Colors are disabled automatically when output is not a TTY or when
# PTK_COLOR is disabled.

ptk_color_reset=$'\033[0m'
ptk_color_red=$'\033[31m'
ptk_color_green=$'\033[32m'
ptk_color_yellow=$'\033[33m'
ptk_color_blue=$'\033[34m'

ptk_apply_colors() {
    if ! ptk_color_enabled 2>/dev/null; then
        C_RESET=""
        C_RED=""
        C_GREEN=""
        C_YELLOW=""
        C_BLUE=""
        return 0
    fi

    C_RESET="$ptk_color_reset"
    C_RED="$ptk_color_red"
    C_GREEN="$ptk_color_green"
    C_YELLOW="$ptk_color_yellow"
    C_BLUE="$ptk_color_blue"
}
