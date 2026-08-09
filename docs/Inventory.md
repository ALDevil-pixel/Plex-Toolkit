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

## Sprint 1.15.0.5

Ajout de la génération persistante d'un rapport local/Plex :

```bash
./plex-toolkit inventory-plex-report   --config config/plex.conf   inventory.txt   <library-key>   reports/plex-compare.txt
```

Le rapport contient :

```text
Status|Local path|Local name|Plex title|Year|Plex ratingKey
```

Le fichier est écrit de manière atomique : les données sont générées dans un fichier temporaire puis déplacées vers la destination.

La commande reste strictement en lecture seule et refuse `--fix`.

Aucun fichier média n'est modifié.
