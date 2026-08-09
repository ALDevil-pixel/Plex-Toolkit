# Sprint 1.12.0 - Partie 4

## Sécurité des doublons

- Ajout d'une revérification SHA-256 immédiatement avant suppression.
- Refus de supprimer un fichier disparu ou modifié depuis l'analyse.
- Prévalidation de tous les fichiers candidats d'un groupe avant suppression.
- Conservation de la politique de sélection du keeper.
- Vérification de l'idempotence de `--fix`.
- Ajout d'un test de sécurité dédié.
