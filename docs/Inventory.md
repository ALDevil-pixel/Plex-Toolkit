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

Ajout de la comparaison de deux inventaires :

```bash
./plex-toolkit inventory-compare --config config/inventory.conf old.txt new.txt
```

Résultats possibles :

```text
UNCHANGED
CHANGED
ADDED
REMOVED
```

`CHANGED` peut notamment représenter :

- un changement de taille ;
- une modification de date ;
- un changement de chemin pour une même identité.

La comparaison est strictement en lecture seule.

Elle ne modifie ni les inventaires, ni les fichiers locaux.

Le module est :

```text
lib/inventory_compare.sh
```
