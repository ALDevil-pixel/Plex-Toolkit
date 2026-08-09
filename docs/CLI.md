# duplicates

## Options

```bash
plex-toolkit duplicates [options] [directory]
```

Options :

- `--dry-run` : lecture seule, comportement par défaut.
- `--fix` : supprime les doublons identifiés.
- `--deep` : vérifie les doublons avec SHA-256.
- `--min-size <octets>` : ignore les fichiers plus petits.
- `--extensions mkv,mp4,ts` : limite l'analyse aux extensions indiquées.
- `--summary [fichier]` : affiche le résumé du rapport.

### Auto Fix

Pour qu'une suppression soit autorisée, `--deep` est obligatoire :

```bash
plex-toolkit duplicates --deep --fix /media/Movies
```

Sans `--deep`, les fichiers ne sont jamais supprimés.
