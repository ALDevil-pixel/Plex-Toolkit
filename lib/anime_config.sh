#!/usr/bin/env bash
# Chargement et validation de la configuration Anime.

ptk_load_anime_config() {
    local config_file="${1:-config/anime.conf}"

    source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
    ptk_load_config "$config_file" || return 1

    : "${ANIME_ROOT:=}"
    : "${ANIME_SERIES_PATTERN:=}"
    : "${ANIME_SEASON_PATTERN:=}"
    : "${ANIME_EPISODE_PATTERN:=}"
    : "${ANIME_VIDEO_EXTENSIONS:=}"
    : "${ANIME_REQUIRE_SEASON:=true}"
    : "${ANIME_REQUIRE_EPISODE:=true}"

    ptk_validate_anime_config
}

ptk_validate_anime_config() {
    ptk_config_bool "$ANIME_REQUIRE_SEASON" >/dev/null || {
        echo "[ERROR] Invalid boolean: ANIME_REQUIRE_SEASON=$ANIME_REQUIRE_SEASON" >&2
        return 1
    }

    ptk_config_bool "$ANIME_REQUIRE_EPISODE" >/dev/null || {
        echo "[ERROR] Invalid boolean: ANIME_REQUIRE_EPISODE=$ANIME_REQUIRE_EPISODE" >&2
        return 1
    }

    [[ -n "$ANIME_SERIES_PATTERN" ]] || {
        echo "[ERROR] Configuration value is empty: ANIME_SERIES_PATTERN" >&2
        return 1
    }

    [[ -n "$ANIME_SEASON_PATTERN" ]] || {
        echo "[ERROR] Configuration value is empty: ANIME_SEASON_PATTERN" >&2
        return 1
    }

    [[ -n "$ANIME_EPISODE_PATTERN" ]] || {
        echo "[ERROR] Configuration value is empty: ANIME_EPISODE_PATTERN" >&2
        return 1
    }

    [[ -n "$ANIME_VIDEO_EXTENSIONS" ]] || {
        echo "[ERROR] Configuration value is empty: ANIME_VIDEO_EXTENSIONS" >&2
        return 1
    }

    return 0
}
