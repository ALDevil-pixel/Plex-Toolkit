# check

## Modes

Par défaut :

```bash
plex-toolkit check
```

effectue uniquement une analyse.

Pour appliquer les corrections sûres :

```bash
plex-toolkit check --fix
```

`--dry-run` force explicitement le mode lecture seule :

```bash
plex-toolkit check --dry-run
```

### Corrections automatiques

Le mode `--fix` supprime les fichiers de 0 octet.

Les extensions non conformes sont uniquement signalées. Elles ne sont pas renommées ou supprimées automatiquement, car une extension incorrecte ne permet pas de déterminer de façon fiable le format réel du fichier.
