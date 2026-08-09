# Consolidation v0.2.1

## Lot 3

Ajout de `lib/cli_options.sh` pour préparer la gestion commune des options CLI.

Options communes :
- `--dry-run`
- `--fix`
- `--verbose` / `-v`
- `--quiet` / `-q`

Le module ne remplace pas encore les parseurs propres aux commandes. Il sert de base commune pour les prochaines intégrations.
