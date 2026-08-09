# Release de correction - Partie 2

## Configuration

- Correction de la priorité entre configuration et options CLI.
- `--fix` et `--dry-run` restent toujours prioritaires lorsqu'ils sont explicitement fournis.
- `--verbose` et `--quiet` ne sont plus écrasés silencieusement par la configuration.
- Normalisation des valeurs booléennes avant utilisation.
- Ajout de tests de précédence.
