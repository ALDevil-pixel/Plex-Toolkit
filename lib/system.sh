#!/usr/bin/env bash
check_binary(){ command -v "$1" >/dev/null 2>&1; }
check_disk(){ df -h; }
