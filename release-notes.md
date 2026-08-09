# Sprint 1.14.0 - Partie 1

## Plan de synchronisation Plex

- Ajout d'une configuration dédiée à la synchronisation.
- Ajout du mode `local-to-plex`.
- Ajout de `plex-sync-plan`.
- Transformation des résultats de comparaison en actions proposées.
- `ADD_TO_PLEX` proposé pour les fichiers locaux compatibles.
- `PLEX_ONLY` reste informatif et ne déclenche aucune suppression.
- `--fix` explicitement refusé par le plan.
- Aucun appel de modification Plex.
- Ajout de tests dédiés.
