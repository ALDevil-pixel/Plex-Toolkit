#!/usr/bin/env bash
source lib/media_type.sh

test "$(ptk_detect_media_type "/media/Anime")" = "anime"
test "$(ptk_detect_media_type "/media/Series")" = "series"
test "$(ptk_detect_media_type "/media/Movies")" = "movie"

echo OK
