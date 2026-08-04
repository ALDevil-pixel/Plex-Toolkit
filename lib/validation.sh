#!/usr/bin/env bash
validate_config(){
for f in library.conf anime.yaml movies.yaml collections.yaml plex.yaml library.yaml; do
 [[ -f "$ROOT/config/$f" ]] || echo "Missing: $f"
done
}
