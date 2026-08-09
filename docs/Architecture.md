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
    └── config.sh
```

Les commandes récentes utilisent directement ces modules communs.

## Compatibilité legacy

Les fichiers suivants restent temporairement présents pour compatibilité avec d'anciens appels :

```text
lib/common.sh
lib/args.sh
lib/cli.sh
lib/errors.sh
lib/validation.sh
```

Ils ne constituent plus la nouvelle API interne.

Ils servent uniquement de couche de compatibilité et doivent déléguer vers les conventions actuelles lorsqu'une fonction commune existe.

Aucune nouvelle commande ne doit dépendre de ces fichiers.
