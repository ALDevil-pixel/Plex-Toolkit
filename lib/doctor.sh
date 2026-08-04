#!/usr/bin/env bash
# lib/doctor.sh

check_bin() {
    command -v "$1" >/dev/null 2>&1
}

ptk_doctor_run() {
    echo "Plex-Toolkit Doctor"
    for b in bash ffmpeg HandBrakeCLI; do
        if check_bin "$b"; then
            printf "[ OK ] %s\n" "$b"
        else
            printf "[WARN] %s not found\n" "$b"
        fi
    done
    [[ -d config ]] && echo "[ OK ] config/" || echo "[WARN] config/ missing"
    [[ -d plugins ]] && echo "[ OK ] plugins/" || echo "[WARN] plugins/ missing"
}
