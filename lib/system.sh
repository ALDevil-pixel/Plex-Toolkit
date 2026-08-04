#!/usr/bin/env bash
# Plex-Toolkit - lib/system.sh

_ptk_version() {
    command -v "$1" >/dev/null 2>&1 || return 1
    "$1" --version 2>/dev/null | head -n1
}

ptk_collect_system_info() {
    echo "=== Plex-Toolkit System Information ==="
    echo "Hostname : $(hostname)"
    echo "OS       : $(uname -s)"
    echo "Kernel   : $(uname -r)"
    echo "Arch     : $(uname -m)"
    echo

    if command -v free >/dev/null 2>&1; then
        echo "Memory"
        free -h
        echo
    fi

    echo "Components"
    if _ptk_version ffmpeg >/tmp/ptk_ffmpeg.$$ 2>/dev/null; then
        echo "FFmpeg   : $(cat /tmp/ptk_ffmpeg.$$)"
        rm -f /tmp/ptk_ffmpeg.$$
    else
        echo "FFmpeg   : Not installed"
    fi

    if command -v HandBrakeCLI >/dev/null 2>&1; then
        echo "HandBrake: $(HandBrakeCLI --version | head -n1)"
    else
        echo "HandBrake: Not installed"
    fi

    if command -v plexmediaserver >/dev/null 2>&1; then
        echo "Plex     : Installed"
    else
        echo "Plex     : Not detected"
    fi
}
