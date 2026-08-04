#!/usr/bin/env bash
# lib/mediainfo_analyzer.sh

ptk_analyze_file() {
    local file="$1"
    if ! command -v mediainfo >/dev/null 2>&1; then
        echo "[WARN] mediainfo not installed"
        return 1
    fi

    local vcodec acodec width height
    vcodec=$(mediainfo --Inform="Video;%Format%" "$file")
    acodec=$(mediainfo --Inform="Audio;%Format%" "$file")
    width=$(mediainfo --Inform="Video;%Width%" "$file")
    height=$(mediainfo --Inform="Video;%Height%" "$file")

    echo "File      : $file"
    echo "Video     : ${vcodec:-unknown}"
    echo "Audio     : ${acodec:-unknown}"
    echo "Resolution: ${width}x${height}"
}
