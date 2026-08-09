# CLI

## Options communes

Les commandes utilisent les options communes :

```text
--dry-run
--fix
--verbose
--quiet
--config <fichier>
```

Le mode par défaut reste lecture seule.

`--fix` n'est accepté que par les commandes qui autorisent une modification.

### `--config`

`--config` est maintenant pris en charge par le parser CLI commun.

Le fichier est routé vers la variable de configuration correspondant à son nom :

```text
plex.conf       → PTK_PLEX_CONFIG
plex-sync.conf  → PTK_PLEX_SYNC_CONFIG
inventory.conf  → PTK_INVENTORY_CONFIG
anime.conf      → PTK_ANIME_CONFIG
movies.conf     → PTK_MOVIE_CONFIG
report.conf     → PTK_REPORT_CONFIG
check.conf      → PTK_CHECK_CONFIG
```

La variable générique `PTK_CONFIG_FILE` est également renseignée.

La variable legacy `PLEXTK_CONFIG` reste exportée pour compatibilité.

## Dispatcher

Les noms de commandes utilisent des tirets :

```text
plex-sync-add
inventory-plex-compare
```

Les fonctions shell utilisent des underscores :

```text
cmd_plex_sync_add
cmd_inventory_plex_compare
```

Le dispatcher réalise automatiquement cette conversion.

Cela évite de dupliquer des branches de dispatch uniquement pour adapter le nom de la fonction.
