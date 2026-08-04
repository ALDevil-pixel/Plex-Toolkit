#!/usr/bin/env bash
# Détection des fichiers indésirables

ptk_find_junk_files() {
    local path="$1"
    [[ -d "$path" ]] || return 1

    find "$path" -type f \(         -name "Thumbs.db" -o         -name ".DS_Store" -o         -name "desktop.ini" -o         -name "*.tmp" -o         -name "*.bak" -o         -name "*.old"     \) | while read -r file; do
        echo "[JUNK] $file"
    done
}
