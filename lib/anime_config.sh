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

ptk_validate_anime_pattern() {
    local name="$1"
    local pattern="${!name:-}"

    [[ -n "$pattern" ]] || {
        echo "[ERROR] Configuration value is empty: $name" >&2
        return 1
    }

    # Only placeholders understood by the formatter are accepted.
    if grep -Eq '\{[^}]+\}' <<< "$pattern"; then
        while read -r placeholder; do
            case "$placeholder" in
                '{title}'|'{season}'|'{season:02d}'|'{episode}'|'{episode:02d}') ;;
                *)
                    echo "[ERROR] Unsupported placeholder in $name: $placeholder" >&2
                    return 1
                    ;;
            esac
        done < <(grep -Eo '\{[^}]+\}' <<< "$pattern")
    fi

    return 0
}

ptk_validate_anime_config() {
    ptk_config_validate_bool "$ANIME_REQUIRE_SEASON"  >/dev/null || {
        echo "[ERROR] Invalid boolean: ANIME_REQUIRE_SEASON=$ANIME_REQUIRE_SEASON" >&2
        return 1
    }

    ptk_config_validate_bool "$ANIME_REQUIRE_EPISODE"  >/dev/null || {
        echo "[ERROR] Invalid boolean: ANIME_REQUIRE_EPISODE=$ANIME_REQUIRE_EPISODE" >&2
        return 1
    }

    ptk_validate_anime_pattern ANIME_SERIES_PATTERN || return 1
    ptk_validate_anime_pattern ANIME_SEASON_PATTERN || return 1
    ptk_validate_anime_pattern ANIME_EPISODE_PATTERN || return 1

    [[ -n "$ANIME_VIDEO_EXTENSIONS" ]] || {
        echo "[ERROR] Configuration value is empty: ANIME_VIDEO_EXTENSIONS" >&2
        return 1
    }

    return 0
}
