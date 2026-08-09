#!/usr/bin/env bash
set -e

source lib/terminal.sh
source lib/colors.sh
source lib/display.sh
source lib/filesystem.sh
source lib/progress.sh

ptk_is_tty >/dev/null 2>&1 || true
ptk_apply_colors

ptk_require_dir /tmp/plex-toolkit-test-dir-$$
test -d /tmp/plex-toolkit-test-dir-$$
rmdir /tmp/plex-toolkit-test-dir-$$

PTK_DRY_RUN=1
ptk_safe_remove /tmp/plex-toolkit-test-do-not-delete
ptk_progress 50 100 >/tmp/ptk-progress.out
grep '50%' /tmp/ptk-progress.out >/dev/null

rm -f /tmp/ptk-progress.out
echo OK
