# Sprint 1.15.0 - Partie 3

## Comparaison d'inventaires

- Ajout de `inventory-compare`.
- Comparaison basée sur l'identité des fichiers.
- Distinction `UNCHANGED`, `CHANGED`, `ADDED` et `REMOVED`.
- Prise en compte du hash lorsqu'il est disponible.
- Fallback nom + taille lorsque le hash est absent.
- Commande strictement en lecture seule.
- Ajout d'un test dédié.
