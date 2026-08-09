# duplicates

## Auto Fix

La recherche de doublons reste non destructive par défaut.

```bash
plex-toolkit duplicates --deep /media/Movies
```

Pour supprimer automatiquement les doublons réellement identifiés par SHA-256 :

```bash
plex-toolkit duplicates --deep --fix /media/Movies
```

Le premier fichier rencontré est conservé et les suivants ayant exactement le même SHA-256 sont proposés/supprimés.

Sans `--deep`, aucun fichier n'est supprimé.
