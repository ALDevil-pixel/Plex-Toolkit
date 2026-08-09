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
- Les tests historiques sont traités comme des tests de non-régression.
- Ils ne dépendent plus du numéro courant de `SPRINT_STATE.md`.
- Ajout d'un runner historique et d'un contrôle dédié.
