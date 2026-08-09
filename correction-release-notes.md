# Release de correction - Partie 3

## Comparaison d'inventaires

- Correction de la classification des fichiers modifiés.
- Un fichier modifié au même chemin est maintenant `CHANGED`.
- Un fichier déplacé avec le même hash est rapproché comme le même média.
- Les vrais ajouts et suppressions restent `ADDED` / `REMOVED`.
- Correction du test de non-régression du dispatcher.
- Ajout de tests de non-régression pour les quatre états d'inventaire.
