#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

for f in \
    config/movies.conf \
    lib/movie_config.sh \
    lib/movie_scanner.sh \
    lib/duplicates.sh \
    commands/movie-scan \
    commands/movie-duplicates \
    tests/test-movie-config.sh \
    tests/test-movie-scan.sh \
    tests/test-movie-duplicates.sh \
    tests/test-movie-duplicates-safety.sh
do
    test -f "$f"
done

grep -q 'ptk_load_movie_config' commands/movie-scan
grep -q 'ptk_load_movie_config' commands/movie-duplicates
grep -q 'ptk_movie_scan' commands/movie-scan
grep -q 'ptk_find_duplicates' commands/movie-duplicates
grep -q 'ptk_select_duplicate_keeper' lib/duplicates.sh
grep -q 'ptk_file_sha256' lib/duplicates.sh

echo "Sprint 1.12.0 coherence: OK"
