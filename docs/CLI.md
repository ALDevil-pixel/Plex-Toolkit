# rename

## Modes

Par défaut, `rename` fonctionne en lecture seule :

```bash
plex-toolkit rename
```

Pour appliquer réellement les renommages :

```bash
plex-toolkit rename --fix
```

`--dry-run` force explicitement le mode lecture seule :

```bash
plex-toolkit rename --dry-run
```

Les conflits de destination sont ignorés afin d'éviter tout écrasement de fichier existant.
Les renommages réellement effectués sont journalisés.
