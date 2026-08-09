# Architecture

## Couches principales

```text
plex-toolkit
    ↓
commands/
    ↓
lib/
    ├── cli_options.sh
    ├── cli_errors.sh
    ├── exit_codes.sh
    ├── logger.sh
    ├── config.sh
    ├── terminal.sh
    ├── colors.sh
    ├── display.sh
    └── filesystem.sh
```

Les fonctions communes doivent être centralisées dans `lib/`.

## Compatibilité legacy

Les anciens noms restent disponibles lorsqu'une API historique les utilise :

```text
is_tty
require_dir
safe_remove
progress
```

Ils délèguent vers les fonctions `ptk_*`.

`common.sh`, `args.sh`, `cli.sh`, `errors.sh` et `validation.sh` restent des couches legacy traitées dans la Partie 1.

Aucune nouvelle commande ne doit introduire une seconde implémentation d'une fonction déjà présente dans `lib/`.
