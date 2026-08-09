#!/usr/bin/env bash
# Terminal helpers

ptk_is_tty() {
    [[ -t 1 ]]
}

is_tty() {
    ptk_is_tty
}

ptk_color_enabled() {
    [[ "${PTK_COLOR:-true}" == "true" ]] && ptk_is_tty
}
