# Release de correction

Les numéros de parties ci-dessous désignent les étapes de correction du dépôt.
Ils ne constituent pas des versions applicatives.

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
- Permissions des entry points et plugins restaurées.
- Ajout d'un test de permissions.

## Partie 7
### Documentation et versions

- Remplacement du README obsolète issu d'un ancien sprint.
- Le README décrit désormais le projet consolidé.
- La version applicative reste `0.2.1`, sans bump artificiel lié aux corrections.
- `VERSION` et `version` sont contrôlés pour rester identiques.
- La présence de la version dans le changelog et le README est vérifiée automatiquement.
