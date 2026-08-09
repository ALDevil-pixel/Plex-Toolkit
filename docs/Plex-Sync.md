# Synchronisation Plex

## Sprint 1.14.0.1

Cette première partie prépare la synchronisation sans effectuer de modification.

Configuration :

```text
config/plex-sync.conf
```

Paramètres :

```text
PLEX_SYNC_MODE
PLEX_SYNC_MOVIE_EXTENSIONS
PLEX_SYNC_REQUIRE_YEAR
PLEX_SYNC_ALLOW_PLEX_ONLY
```

Le mode actuellement supporté est :

```text
local-to-plex
```

## Plan

Commande :

```bash
./plex-toolkit plex-sync-plan --config config/plex.conf <répertoire-local> <library-key>
```

Le plan transforme les résultats de `plex-compare` en actions proposées :

```text
ADD_TO_PLEX
REVIEW
NONE
```

`ADD_TO_PLEX` signifie qu'un fichier local peut être proposé pour une future synchronisation vers Plex.

Cette partie **n'envoie aucune requête de modification à Plex**.

`PLEX_ONLY` reste informatif et ne déclenche aucune suppression locale.

`--fix` est volontairement refusé par `plex-sync-plan`.

Les prochaines parties pourront implémenter les actions une par une, avec leurs propres validations et tests.
