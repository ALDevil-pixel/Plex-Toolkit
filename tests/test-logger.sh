#!/usr/bin/env bash
set -e

source lib/logger.sh

TEST_LOG="$(mktemp)"
export PTK_LOG_FILE="$TEST_LOG"

PTK_QUIET=1
ptk_log INFO "test message"
ptk_log_command_start "check"
ptk_log_command_end "check" 0
ptk_log_command_end "check" 1

grep "test message" "$TEST_LOG" >/dev/null
grep "Starting: check" "$TEST_LOG" >/dev/null
grep "Completed: check (exit=0)" "$TEST_LOG" >/dev/null
grep "Failed: check (exit=1)" "$TEST_LOG" >/dev/null

rm -f "$TEST_LOG"
echo OK
