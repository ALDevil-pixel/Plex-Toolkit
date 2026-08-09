# Consolidation v0.2.1

## Lot 5

Ajout des codes de sortie et de la gestion commune des erreurs CLI.

Codes :
- `0` : succès
- `1` : erreur d'exécution
- `2` : erreur d'utilisation / paramètres

Nouveaux modules :
- `lib/exit_codes.sh`
- `lib/cli_errors.sh`

Ce lot prépare l'harmonisation des commandes sans modifier leur logique métier.
