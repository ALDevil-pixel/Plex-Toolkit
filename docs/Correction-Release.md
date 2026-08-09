# Release de correction

## Partie 1
- Restauration des fichiers perdus lors de la consolidation.
- Correction du dispatcher CLI.
- Ajout du routage de `--config`.
- Correction de la validation booléenne.
- Restauration de l'exécutabilité du lanceur.

## Partie 2
- Priorité : défauts → configuration → options CLI explicites.
- Séparation validation/interprétation des booléens.

## Partie 3
- Comparaison d'inventaires : `UNCHANGED`, `CHANGED`, `REMOVED`, `ADDED`.
- Détection des modifications et déplacements.

## Partie 4
- Séparation des options communes et spécifiques aux commandes.

## Partie 5
- Tests historiques rendus indépendants de `SPRINT_STATE.md`.
- Ajout d'un runner de non-régression historique.

## Partie 6
### Permissions des entry points

Les scripts utilisés comme entry points et plugins doivent rester exécutables après consolidation et packaging.

Les permissions sont maintenant vérifiées pour :

- `plex-toolkit`
- `plugins/anime/audit.sh`
- `plugins/anime/rename.sh`
- `plugins/movies/duplicates.sh`
- `plugins/plex/verify.sh`

Un test dédié empêche une future régression silencieuse des permissions.
