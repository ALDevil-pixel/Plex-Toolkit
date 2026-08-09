# cleanup

## Modes

Par défaut, `cleanup` fonctionne en lecture seule :

```bash
plex-toolkit cleanup
```

Pour appliquer réellement les suppressions :

```bash
plex-toolkit cleanup --fix
```

`--dry-run` force explicitement le mode lecture seule :

```bash
plex-toolkit cleanup --dry-run
```

Les suppressions effectuées en mode `--fix` sont journalisées dans le log de cleanup.
