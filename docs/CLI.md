# audit

## Usage

```bash
plex-toolkit audit
plex-toolkit audit --json
plex-toolkit audit config/library.conf
```

Options communes de lecture seule :

```text
--dry-run
--verbose
--quiet
```

`audit` est une commande d'analyse uniquement. Elle ne modifie jamais les bibliothèques.

`--fix` est volontairement refusé afin d'éviter de présenter une commande sans correction automatique comme si elle pouvait modifier les fichiers.
