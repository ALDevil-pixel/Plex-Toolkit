#!/usr/bin/env bash
# Legacy error compatibility layer.
#
# New commands should use lib/cli_errors.sh and lib/exit_codes.sh.

fatal() {
    printf '[ERROR] %s\n' "$*" >&2
    return "${PTK_EXIT_ERROR:-1}"
}
