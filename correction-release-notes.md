# Release de correction - Partie 1

## Consolidation

- Restauration des fichiers suivis par Git mais absents du ZIP consolidé.
- Aucun fichier existant n'est écrasé par une version Git.

## CLI

- Conversion automatique des tirets de commande en underscores pour appeler `cmd_*`.
- Support commun de `--config`.
- Conservation de `PLEXTK_CONFIG` pour compatibilité.
- Préparation des options spécifiques (`--deep`, `--min-size`, `--extensions`, `--summary`) sans les rejeter au niveau commun.

## Configuration

- Ajout de `ptk_config_validate_bool`.
- Ajout de `ptk_config_bool_value`.
- Les valeurs `true` et `false` sont maintenant distinguées de leur utilisation comme prédicat shell.

## Linux

- Le lanceur `plex-toolkit` est marqué exécutable.

## Tests

- Ajout de `tests/test-correction-cli-config.sh`.
