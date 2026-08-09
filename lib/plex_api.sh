#!/usr/bin/env bash
# Client HTTP Plex commun.
#
# Ce module centralise les appels API et ne contient aucune logique métier.

ptk_plex_curl_args() {
    local -a args=(--silent --show-error --fail --connect-timeout "$PLEX_TIMEOUT" --max-time "$PLEX_TIMEOUT")

    if [[ "${PLEX_VERIFY_TLS,,}" != "true" ]]; then
        args+=(--insecure)
    fi

    printf '%s\n' "${args[@]}"
}

ptk_plex_request() {
    local method="${1:-GET}"
    local path="${2:-}"
    local body="${3:-}"

    [[ -n "$PLEX_URL" ]] || {
        echo "[ERROR] Plex URL is not configured." >&2
        return 2
    }

    [[ -n "$PLEX_TOKEN" ]] || {
        echo "[ERROR] Plex token is not configured." >&2
        return 2
    }

    local url
    url="$(ptk_plex_url "$path")"

    local -a args
    mapfile -t args < <(ptk_plex_curl_args)

    args+=(-X "$method" -H "X-Plex-Token: $PLEX_TOKEN" -H "Accept: application/json")

    [[ -n "$body" ]] && args+=(--data "$body")

    local attempt=0
    local max_attempts=$((PLEX_RETRIES + 1))

    while (( attempt < max_attempts )); do
        attempt=$((attempt + 1))

        if curl "${args[@]}" "$url"; then
            return 0
        fi

        if (( attempt < max_attempts )); then
            ptk_log WARN "Plex request failed (attempt $attempt/$max_attempts): $method $path"
            sleep 1
        fi
    done

    ptk_log ERROR "Plex request failed after $max_attempts attempts: $method $path"
    return 1
}

ptk_plex_ping() {
    ptk_plex_request GET "/identity" >/dev/null
}
