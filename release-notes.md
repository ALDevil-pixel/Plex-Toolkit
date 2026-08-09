# Sprint 1.12.0 - Partie 2

## Doublons Films

- Remplacement de la comparaison superficielle par une détection en deux étapes.
- Regroupement préalable par taille.
- Vérification exacte par SHA-256.
- Support SHA-256 via `sha256sum` ou `shasum`.
- Ajout de la commande `movie-duplicates`.
- Dry-run par défaut.
- `--fix` supprime uniquement les doublons dont le contenu est vérifié identique.
- Conservation du premier fichier du groupe.
- Ajout de tests de non-régression et d'application.
