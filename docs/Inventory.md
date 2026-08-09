# Inventaire

## Sprint 1.15.0.1

L'inventaire est configurable avec :

```text
INVENTORY_FOLLOW_SYMLINKS
INVENTORY_INCLUDE_HIDDEN
INVENTORY_HASH_ENABLED
INVENTORY_HASH_ALGORITHM
```

## Sprint 1.15.0.2

Une identité stable est disponible :

```text
hash:<hash>
```

ou, sans hash :

```text
name-size:<name>|<size>
```

## Sprint 1.15.0.3

Ajout de la comparaison de deux inventaires locaux :

```bash
./plex-toolkit inventory-compare --config config/inventory.conf old.txt new.txt
```

Résultats :

```text
UNCHANGED
CHANGED
ADDED
REMOVED
```

## Sprint 1.15.0.4

Ajout du rapprochement entre un inventaire local et Plex :

```bash
./plex-toolkit inventory-plex-compare   --config config/plex.conf   inventory.txt   <library-key>
```

Résultats :

```text
MATCH
LOCAL_ONLY
```

Le rapprochement utilise le titre normalisé et l'année lorsqu'elle est présente dans le nom local.

Cette étape est volontairement diagnostique.

Elle ne déclenche :

- aucun refresh Plex ;
- aucune modification Plex ;
- aucun renommage ;
- aucune suppression.

Les données Plex utilisées sont lues via l'API existante.
