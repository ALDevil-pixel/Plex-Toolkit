#!/usr/bin/env bash
require_dir(){ [[ -d "$1" ]] || mkdir -p "$1"; }
safe_remove(){ [[ "${DRY_RUN:-false}" == true ]] && { echo "[DRY-RUN] rm $1"; return; }; rm -rf -- "$1"; }
