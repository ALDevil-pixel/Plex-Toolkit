#!/usr/bin/env bash
mkdir -p /tmp/ptkdup/A /tmp/ptkdup/B
echo test >/tmp/ptkdup/A/movie.mkv
cp /tmp/ptkdup/A/movie.mkv /tmp/ptkdup/B/movie.mkv
source lib/duplicates.sh
ptk_find_duplicates /tmp/ptkdup
rm -rf /tmp/ptkdup
