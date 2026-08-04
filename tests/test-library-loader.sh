#!/usr/bin/env bash
mkdir -p config
echo 'Movies=/tmp' > config/library.conf
source lib/library_loader.sh
ptk_load_libraries config/library.conf >/dev/null
rm -rf config
echo OK
