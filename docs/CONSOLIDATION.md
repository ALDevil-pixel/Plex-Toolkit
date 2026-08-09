# Consolidation v0.2.1

## Lot 6

Intégration des briques communes de codes de retour et d'erreurs dans les quatre commandes principales :

- `rename`
- `cleanup`
- `check`
- `inventory`

Comportement harmonisé :
- `0` : succès
- `1` : erreur d'exécution
- `2` : erreur d'utilisation

Les chemins explicitement fournis sont validés avant l'appel au moteur métier.
