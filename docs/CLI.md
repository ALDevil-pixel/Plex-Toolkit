# Commandes CLI

## help

```bash
plex-toolkit help
plex-toolkit help <command>
```

`help` est strictement en lecture seule.

## version

```bash
plex-toolkit version
```

`version` lit le fichier `VERSION` et affiche sa première ligne.
Il est strictement en lecture seule.

Options communes disponibles pour ces commandes :

```text
--dry-run
--verbose / -v
--quiet / -q
```

`--fix` est refusé pour les commandes qui ne proposent aucune modification.
